import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:dio/dio.dart';

import '../database/database.dart';
import '../database/daos/research_feed_dao.dart';

/// Fetches recent research papers from public APIs.
///
/// Sources:
/// - PubMed/PMC (English) — NCBI E-utilities API (free, no key required)
/// - CNKI/Wanfang (Chinese) — via Europe PMC for Chinese abstracts
/// - CyberLeninka (Russian) — via Europe PMC for Russian abstracts
///
/// Constraints:
/// - Max 20 abstracts per session
/// - Only called on Wi-Fi + charging (enforced by WorkManager)
/// - Keywords matched to Phoenix protocol areas
class ResearchFetcher {
  final ResearchFeedDao _dao;

  static const _maxPerSession = 20;

  /// Phoenix-relevant search keywords.
  static const keywords = [
    'autophagy',
    'spermidine',
    'mTOR inhibition',
    'time-restricted eating',
    'NAD+ longevity',
    'senolytic fisetin',
    'cold exposure thermogenesis',
    'sulforaphane NRF2',
    'urolithin A mitophagy',
    'NMN supplementation',
    'intermittent fasting health',
    'resistance training aging',
  ];

  /// Area classification for keywords.
  static const _keywordToArea = {
    'autophagy': 'nutrition',
    'spermidine': 'supplements',
    'mTOR inhibition': 'supplements',
    'time-restricted eating': 'nutrition',
    'NAD+ longevity': 'supplements',
    'senolytic fisetin': 'supplements',
    'cold exposure thermogenesis': 'conditioning',
    'sulforaphane NRF2': 'nutrition',
    'urolithin A mitophagy': 'supplements',
    'NMN supplementation': 'supplements',
    'intermittent fasting health': 'nutrition',
    'resistance training aging': 'exercise',
  };

  ResearchFetcher(this._dao);

  /// Run a full fetch cycle. Returns the number of new papers added.
  Future<int> fetchRecent({int daysBack = 30}) async {
    int totalAdded = 0;

    // Rotate through keywords — pick 3-4 per session to stay under limits
    final now = DateTime.now();
    final keywordIndex = now.day % keywords.length;
    final sessionKeywords = [
      keywords[keywordIndex],
      keywords[(keywordIndex + 1) % keywords.length],
      keywords[(keywordIndex + 2) % keywords.length],
      keywords[(keywordIndex + 3) % keywords.length],
    ];

    for (final keyword in sessionKeywords) {
      if (totalAdded >= _maxPerSession) break;

      try {
        // PubMed (English)
        final pubmedResults = await _fetchPubMed(keyword, daysBack: daysBack);
        for (final paper in pubmedResults) {
          if (totalAdded >= _maxPerSession) break;
          if (await _addIfNew(paper)) totalAdded++;
        }

        // Europe PMC (covers Chinese and Russian sources too)
        final epmcResults = await _fetchEuropePMC(keyword, daysBack: daysBack);
        for (final paper in epmcResults) {
          if (totalAdded >= _maxPerSession) break;
          if (await _addIfNew(paper)) totalAdded++;
        }
      } catch (e) {
        // Network errors are expected during background tasks — log and skip
        debugPrint('[ResearchFetcher] Error fetching "$keyword": $e');
        continue;
      }
    }

    return totalAdded;
  }

  /// Allowed hosts for research fetching — prevents SSRF if keywords become dynamic.
  static const _allowedHosts = {
    'eutils.ncbi.nlm.nih.gov',
    'www.ebi.ac.uk',
  };

  static final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ))..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Enforce HTTPS and allowed hosts only
        if (options.uri.scheme != 'https' ||
            !_allowedHosts.contains(options.uri.host)) {
          handler.reject(DioException(
            requestOptions: options,
            type: DioExceptionType.cancel,
            error: 'Request blocked: ${options.uri.host} not in allowlist',
          ));
          return;
        }
        handler.next(options);
      },
    ));

  /// Fetch from PubMed E-utilities (free API, no key required for low volume).
  Future<List<_RawPaper>> _fetchPubMed(String keyword, {int daysBack = 30}) async {
    final papers = <_RawPaper>[];

    // Step 1: ESearch
    final searchResp = await _dio.get(
      'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi',
      queryParameters: {
        'db': 'pubmed',
        'term': keyword,
        'retmax': '5',
        'sort': 'date',
        'retmode': 'json',
        'datetype': 'pdat',
        'reldate': '$daysBack',
      },
    );
    if (searchResp.statusCode != 200) return papers;

    final searchJson = searchResp.data is String
        ? jsonDecode(searchResp.data)
        : searchResp.data;
    final idList = List<String>.from(
      searchJson['esearchresult']?['idlist'] ?? [],
    );
    if (idList.isEmpty) return papers;

    // Step 2: EFetch abstracts
    final ids = idList.join(',');
    final fetchResp = await _dio.get(
      'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi',
      queryParameters: {
        'db': 'pubmed',
        'id': ids,
        'rettype': 'abstract',
        'retmode': 'xml',
      },
    );
    if (fetchResp.statusCode != 200) return papers;

    // Simple XML parsing for PubMed articles
    final xml = fetchResp.data.toString();
    final articles = _parsePubMedXml(xml, keyword);
    papers.addAll(articles);

    return papers;
  }

  /// Fetch from Europe PMC (covers multi-language sources).
  Future<List<_RawPaper>> _fetchEuropePMC(String keyword, {int daysBack = 30}) async {
    final papers = <_RawPaper>[];

    final resp = await _dio.get(
      'https://www.ebi.ac.uk/europepmc/webservices/rest/search',
      queryParameters: {
        'query': keyword,
        'resultType': 'core',
        'pageSize': '5',
        'format': 'json',
        'sort': 'DATE_CREATED desc',
      },
    );
    if (resp.statusCode != 200) return papers;

    final json = resp.data is String ? jsonDecode(resp.data) : resp.data;
    final resultList = json['resultList']?['result'] as List? ?? [];

    for (final r in resultList) {
      final title = r['title'] as String? ?? '';
      final abstractText = r['abstractText'] as String? ?? '';
      if (title.isEmpty || abstractText.isEmpty) continue;

      final doi = r['doi'] as String?;
      final pmid = r['pmid'] as String?;
      final lang = _detectLanguage(title, abstractText);

      papers.add(_RawPaper(
        title: title,
        abstractText: abstractText,
        doi: doi,
        url: doi != null
            ? 'https://doi.org/$doi'
            : pmid != null
                ? 'https://pubmed.ncbi.nlm.nih.gov/$pmid/'
                : '',
        source: lang == 'zh'
            ? 'cnki'
            : lang == 'ru'
                ? 'cyberleninka'
                : 'pubmed',
        language: lang,
        area: _keywordToArea[keyword] ?? 'general',
      ));
    }

    return papers;
  }

  /// Minimal PubMed XML parser — extracts title, abstract, DOI.
  List<_RawPaper> _parsePubMedXml(String xml, String keyword) {
    final papers = <_RawPaper>[];
    final articlePattern = RegExp(
      r'<PubmedArticle>(.*?)</PubmedArticle>',
      dotAll: true,
    );

    for (final match in articlePattern.allMatches(xml)) {
      final article = match.group(1) ?? '';

      final title = _extractXmlTag(article, 'ArticleTitle');
      final abstract = _extractXmlTag(article, 'AbstractText');
      final pmid = _extractXmlTag(article, 'PMID');
      final doi = _extractDoi(article);

      if (title.isEmpty || abstract.isEmpty) continue;

      papers.add(_RawPaper(
        title: title,
        abstractText: abstract,
        doi: doi,
        url: doi != null
            ? 'https://doi.org/$doi'
            : pmid.isNotEmpty
                ? 'https://pubmed.ncbi.nlm.nih.gov/$pmid/'
                : '',
        source: 'pubmed',
        language: 'en',
        area: _keywordToArea[keyword] ?? 'general',
      ));
    }

    return papers;
  }

  String _extractXmlTag(String xml, String tag) {
    final pattern = RegExp('<$tag[^>]*>(.*?)</$tag>', dotAll: true);
    final match = pattern.firstMatch(xml);
    return match?.group(1)?.replaceAll(RegExp(r'<[^>]+>'), '').trim() ?? '';
  }

  String? _extractDoi(String article) {
    final pattern = RegExp(
      r'<ArticleId IdType="doi">(.*?)</ArticleId>',
      dotAll: true,
    );
    final match = pattern.firstMatch(article);
    return match?.group(1)?.trim();
  }

  /// Simple language detection based on character ranges.
  String _detectLanguage(String title, String abstract_) {
    final combined = title + abstract_;
    // Chinese characters range
    if (RegExp(r'[\u4e00-\u9fff]').hasMatch(combined)) return 'zh';
    // Cyrillic range
    if (RegExp(r'[\u0400-\u04ff]').hasMatch(combined)) return 'ru';
    return 'en';
  }

  /// Add paper to DB if it doesn't already exist (dedup by DOI or title).
  Future<bool> _addIfNew(_RawPaper paper) async {
    if (paper.doi != null && paper.doi!.isNotEmpty) {
      if (await _dao.existsByDoi(paper.doi!)) return false;
    } else {
      if (await _dao.existsByTitle(paper.title)) return false;
    }

    await _dao.addEntry(ResearchFeedCompanion(
      foundDate: Value(DateTime.now()),
      source: Value(paper.source),
      language: Value(paper.language),
      title: Value(paper.title),
      abstractText: Value(paper.abstractText),
      doi: Value(paper.doi),
      url: Value(paper.url),
      area: Value(paper.area),
      keySummary: Value(''), // Will be filled by ResearchEvaluator
      impact: Value('medium'), // Default, refined by evaluator
    ));

    return true;
  }
}

class _RawPaper {
  final String title;
  final String abstractText;
  final String? doi;
  final String url;
  final String source;
  final String language;
  final String area;

  const _RawPaper({
    required this.title,
    required this.abstractText,
    this.doi,
    required this.url,
    required this.source,
    required this.language,
    required this.area,
  });
}

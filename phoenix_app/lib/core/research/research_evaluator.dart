import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';

import '../database/database.dart';
import '../database/daos/research_feed_dao.dart';
import '../database/tables.dart';
import '../llm/llm_engine.dart';
import '../llm/prompt_templates.dart';

/// Evaluates fetched research papers using the LLM (BitNet or template fallback).
///
/// For each paper without a summary:
/// 1. Generates a 1-sentence key summary
/// 2. Rates impact on Phoenix protocol (high/medium/low)
/// 3. Determines if paper suggests a protocol update
///
/// BitNet is loaded, used for evaluation, then unloaded to free RAM.
class ResearchEvaluator {
  final ResearchFeedDao _dao;
  final LlmEngine? _engine;

  ResearchEvaluator(this._dao, [this._engine]);

  /// Evaluate all papers that don't have a keySummary yet.
  /// Returns number of papers evaluated.
  Future<int> evaluateNew() async {
    final entries = await _dao.getRecentEntries(days: 30);
    final unevaluated = entries.where((e) => e.keySummary.isEmpty).toList();

    int evaluated = 0;

    for (final entry in unevaluated) {
      try {
        final result = await _evaluate(entry);
        await _dao.updateEntry(ResearchFeedCompanion(
          id: Value(entry.id),
          foundDate: Value(entry.foundDate),
          source: Value(entry.source),
          language: Value(entry.language),
          title: Value(entry.title),
          abstractText: Value(entry.abstractText),
          doi: Value(entry.doi),
          url: Value(entry.url),
          area: Value(result.area ?? entry.area),
          keySummary: Value(result.summary),
          impact: Value(result.impact),
          userRead: Value(entry.userRead),
          proposedUpdate: Value(result.proposesUpdate),
          updateProposal: Value(result.updateProposal),
          updateStatus: Value(
            result.proposesUpdate ? ResearchUpdateStatus.pending : null,
          ),
        ));
        evaluated++;
      } catch (e) {
        // Log and skip papers that fail evaluation
        debugPrint('[ResearchEvaluator] Evaluation failed for paper: $e');
        continue;
      }
    }

    return evaluated;
  }

  /// Evaluate a single paper.
  Future<_EvaluationResult> _evaluate(ResearchFeedData entry) async {
    // If LLM is available, use it for smarter evaluation
    if (_engine != null && _engine.isLlmAvailable) {
      return _evaluateWithLlm(entry);
    }

    // Fallback: keyword-based heuristic evaluation
    return _evaluateWithKeywords(entry);
  }

  /// LLM-based evaluation.
  Future<_EvaluationResult> _evaluateWithLlm(ResearchFeedData entry) async {
    final response = await _engine!.generate(
      template: _ResearchEvalTemplate(),
      context: {
        'title': entry.title,
        'abstract': entry.abstractText,
      },
      maxTokens: 200,
    );

    return _parseLlmResponse(response, entry);
  }

  _EvaluationResult _parseLlmResponse(String response, ResearchFeedData entry) {
    String summary = '';
    String impact = ResearchImpact.medium;
    String? area;
    bool proposesUpdate = false;
    String? updateProposal;

    for (final line in response.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.startsWith('RIASSUNTO:')) {
        summary = trimmed.substring('RIASSUNTO:'.length).trim();
      } else if (trimmed.startsWith('IMPATTO:')) {
        final val = trimmed.substring('IMPATTO:'.length).trim().toLowerCase();
        if (['high', 'medium', 'low'].contains(val)) impact = val;
      } else if (trimmed.startsWith('AREA:')) {
        area = trimmed.substring('AREA:'.length).trim().toLowerCase();
      } else if (trimmed.startsWith('AGGIORNAMENTO:')) {
        proposesUpdate = trimmed.toLowerCase().contains('sì');
      } else if (trimmed.startsWith('PROPOSTA:')) {
        updateProposal = trimmed.substring('PROPOSTA:'.length).trim();
        if (updateProposal.isEmpty) updateProposal = null;
      }
    }

    // Fallback if LLM didn't produce a summary
    if (summary.isEmpty) {
      summary = _generateHeuristicSummary(entry);
    }

    return _EvaluationResult(
      summary: summary,
      impact: impact,
      area: area,
      proposesUpdate: proposesUpdate,
      updateProposal: updateProposal,
    );
  }

  /// Keyword-based heuristic evaluation (no LLM needed).
  Future<_EvaluationResult> _evaluateWithKeywords(ResearchFeedData entry) async {
    final text = '${entry.title} ${entry.abstractText}'.toLowerCase();

    // Impact scoring
    final highImpactTerms = [
      'randomized controlled trial',
      'meta-analysis',
      'systematic review',
      'rct',
      'double-blind',
      'human trial',
      'clinical trial',
    ];
    final mediumImpactTerms = [
      'cohort study',
      'prospective',
      'intervention',
      'pilot study',
    ];

    String impact = ResearchImpact.low;
    for (final term in highImpactTerms) {
      if (text.contains(term)) {
        impact = ResearchImpact.high;
        break;
      }
    }
    if (impact == ResearchImpact.low) {
      for (final term in mediumImpactTerms) {
        if (text.contains(term)) {
          impact = ResearchImpact.medium;
          break;
        }
      }
    }

    // Protocol update detection
    bool proposesUpdate = false;
    String? updateProposal;

    final updateTriggers = {
      'dosage': 'Possibile aggiornamento dosaggio',
      'dose-response': 'Nuovi dati dose-risposta',
      'optimal dose': 'Dose ottimale identificata',
      'contrary to': 'Risultati contrari a evidenze precedenti',
      'superior to': 'Trattamento superiore identificato',
      'no significant': 'Nessun effetto significativo trovato',
    };

    for (final trigger in updateTriggers.entries) {
      if (text.contains(trigger.key)) {
        proposesUpdate = true;
        updateProposal = '${trigger.value}: ${entry.title}';
        break;
      }
    }

    return _EvaluationResult(
      summary: _generateHeuristicSummary(entry),
      impact: impact,
      area: null, // Keep existing area from fetcher
      proposesUpdate: proposesUpdate,
      updateProposal: updateProposal,
    );
  }

  /// Generate a simple summary from the abstract's first sentence.
  String _generateHeuristicSummary(ResearchFeedData entry) {
    final abstract = entry.abstractText;
    // Try to get the conclusion or last sentence
    final sentences = abstract.split(RegExp(r'(?<=[.!?])\s+'));

    // Look for conclusion-like sentences
    for (final s in sentences.reversed) {
      if (s.toLowerCase().contains('conclusion') ||
          s.toLowerCase().contains('results show') ||
          s.toLowerCase().contains('findings suggest') ||
          s.toLowerCase().contains('in summary')) {
        return s.length > 200 ? '${s.substring(0, 197)}...' : s;
      }
    }

    // Fallback: first sentence
    if (sentences.isNotEmpty) {
      final first = sentences.first;
      return first.length > 200 ? '${first.substring(0, 197)}...' : first;
    }

    return entry.title;
  }
}

class _EvaluationResult {
  final String summary;
  final String impact;
  final String? area;
  final bool proposesUpdate;
  final String? updateProposal;

  const _EvaluationResult({
    required this.summary,
    required this.impact,
    this.area,
    this.proposesUpdate = false,
    this.updateProposal,
  });
}

/// Prompt template for LLM-based research evaluation.
class _ResearchEvalTemplate implements PromptTemplate {
  @override
  String get name => 'research_eval';

  @override
  String render(Map<String, dynamic> context) {
    final title = context['title'] ?? '';
    final abstract_ = context['abstract'] ?? '';

    return '''Sei un ricercatore che valuta studi per il protocollo Phoenix (longevità, autophagia, esercizio, nutrizione, integratori).

Titolo: $title
Abstract: $abstract_

Rispondi SOLO con questo formato esatto:
RIASSUNTO: [una frase in italiano con il finding chiave]
IMPATTO: [high/medium/low]
AREA: [nutrition/exercise/supplements/conditioning/general]
AGGIORNAMENTO: [sì/no]
PROPOSTA: [se sì, cosa cambiare nel protocollo in 1 frase; se no, lascia vuoto]''';
  }
}

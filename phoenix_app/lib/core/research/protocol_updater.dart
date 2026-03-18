import '../database/daos/research_feed_dao.dart';
import '../database/database.dart';
import '../database/tables.dart';

/// Generates monthly protocol update proposals from collected research.
///
/// Workflow:
/// 1. Collects all papers from the last 30 days
/// 2. Groups by area (nutrition/exercise/supplements/conditioning)
/// 3. Identifies high-impact findings
/// 4. Generates proposals for protocol changes
/// 5. User approves/rejects each proposal (protocol NEVER changes automatically)
class ProtocolUpdater {
  final ResearchFeedDao _dao;

  ProtocolUpdater(this._dao);

  /// Generate a monthly report summarizing research findings.
  Future<MonthlyResearchReport> generateMonthlyReport() async {
    final entries = await _dao.getRecentEntries(days: 30);

    if (entries.isEmpty) {
      return const MonthlyResearchReport(
        totalPapers: 0,
        byArea: {},
        highImpact: [],
        pendingUpdates: [],
        summary: 'Nessun nuovo studio trovato questo mese.',
      );
    }

    // Group by area
    final byArea = <String, List<ResearchFeedData>>{};
    for (final entry in entries) {
      byArea.putIfAbsent(entry.area, () => []).add(entry);
    }

    // High impact papers
    final highImpact = entries
        .where((e) => e.impact == ResearchImpact.high)
        .toList();

    // Pending update proposals
    final pendingUpdates = await _dao.getPendingUpdates();

    // Generate summary
    final summary = _generateSummary(entries, byArea, highImpact, pendingUpdates);

    return MonthlyResearchReport(
      totalPapers: entries.length,
      byArea: byArea.map((k, v) => MapEntry(k, v.length)),
      highImpact: highImpact,
      pendingUpdates: pendingUpdates,
      summary: summary,
    );
  }

  /// Approve a protocol update proposal.
  Future<void> approveUpdate(int entryId) async {
    await _dao.setUpdateStatus(entryId, ResearchUpdateStatus.approved);
  }

  /// Reject a protocol update proposal.
  Future<void> rejectUpdate(int entryId) async {
    await _dao.setUpdateStatus(entryId, ResearchUpdateStatus.rejected);
  }

  String _generateSummary(
    List<ResearchFeedData> all,
    Map<String, List<ResearchFeedData>> byArea,
    List<ResearchFeedData> highImpact,
    List<ResearchFeedData> pending,
  ) {
    final buffer = StringBuffer();

    buffer.writeln('## Report Ricerca Mensile');
    buffer.writeln('');
    buffer.writeln('**${all.length} studi** analizzati questo mese.');
    buffer.writeln('');

    // By area
    if (byArea.isNotEmpty) {
      buffer.writeln('### Per area');
      for (final entry in byArea.entries) {
        final areaName = _areaDisplayName(entry.key);
        buffer.writeln('- **$areaName**: ${entry.value.length} studi');
      }
      buffer.writeln('');
    }

    // High impact
    if (highImpact.isNotEmpty) {
      buffer.writeln('### Studi ad alto impatto');
      for (final paper in highImpact.take(5)) {
        buffer.writeln('- **${paper.title}**');
        if (paper.keySummary.isNotEmpty) {
          buffer.writeln('  ${paper.keySummary}');
        }
      }
      buffer.writeln('');
    }

    // Pending updates
    if (pending.isNotEmpty) {
      buffer.writeln('### Proposte di aggiornamento');
      buffer.writeln(
        '*Il protocollo non cambia mai automaticamente. '
        'Approva o rifiuta ogni proposta.*',
      );
      buffer.writeln('');
      for (final p in pending) {
        buffer.writeln('- ${p.updateProposal ?? p.title}');
      }
    }

    return buffer.toString();
  }

  static String _areaDisplayName(String area) {
    return switch (area) {
      'nutrition' => 'Nutrizione',
      'exercise' => 'Esercizio',
      'supplements' => 'Integratori',
      'conditioning' => 'Condizionamento',
      _ => 'Generale',
    };
  }
}

class MonthlyResearchReport {
  final int totalPapers;
  final Map<String, int> byArea;
  final List<ResearchFeedData> highImpact;
  final List<ResearchFeedData> pendingUpdates;
  final String summary;

  const MonthlyResearchReport({
    required this.totalPapers,
    required this.byArea,
    required this.highImpact,
    required this.pendingUpdates,
    required this.summary,
  });
}

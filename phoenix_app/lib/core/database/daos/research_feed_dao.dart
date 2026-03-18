import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'research_feed_dao.g.dart';

@DriftAccessor(tables: [ResearchFeed])
class ResearchFeedDao extends DatabaseAccessor<PhoenixDatabase>
    with _$ResearchFeedDaoMixin {
  ResearchFeedDao(super.db);

  Future<int> addEntry(ResearchFeedCompanion entry) {
    return into(researchFeed).insert(entry);
  }

  Future<bool> updateEntry(ResearchFeedCompanion entry) {
    return update(researchFeed).replace(entry);
  }

  /// Watch all entries ordered by date descending.
  Stream<List<ResearchFeedData>> watchAll({int limit = 50}) {
    return (select(researchFeed)
          ..orderBy([(r) => OrderingTerm.desc(r.foundDate)])
          ..limit(limit))
        .watch();
  }

  /// Watch unread entries.
  Stream<List<ResearchFeedData>> watchUnread() {
    return (select(researchFeed)
          ..where((r) => r.userRead.equals(false))
          ..orderBy([(r) => OrderingTerm.desc(r.foundDate)]))
        .watch();
  }

  /// Get unread count.
  Future<int> getUnreadCount() async {
    final count = countAll();
    final query = selectOnly(researchFeed)
      ..addColumns([count])
      ..where(researchFeed.userRead.equals(false));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Mark entry as read.
  Future<void> markRead(int id) {
    return (update(researchFeed)..where((r) => r.id.equals(id)))
        .write(const ResearchFeedCompanion(userRead: Value(true)));
  }

  /// Mark all as read.
  Future<void> markAllRead() {
    return (update(researchFeed)..where((r) => r.userRead.equals(false)))
        .write(const ResearchFeedCompanion(userRead: Value(true)));
  }

  /// Get entries with pending update proposals.
  Future<List<ResearchFeedData>> getPendingUpdates() {
    return (select(researchFeed)
          ..where((r) =>
              r.proposedUpdate.equals(true) &
              r.updateStatus.equals(ResearchUpdateStatus.pending))
          ..orderBy([(r) => OrderingTerm.desc(r.foundDate)]))
        .get();
  }

  /// Watch pending updates.
  Stream<List<ResearchFeedData>> watchPendingUpdates() {
    return (select(researchFeed)
          ..where((r) =>
              r.proposedUpdate.equals(true) &
              r.updateStatus.equals(ResearchUpdateStatus.pending))
          ..orderBy([(r) => OrderingTerm.desc(r.foundDate)]))
        .watch();
  }

  /// Set update status (approved/rejected).
  Future<void> setUpdateStatus(int id, String status) {
    return (update(researchFeed)..where((r) => r.id.equals(id)))
        .write(ResearchFeedCompanion(updateStatus: Value(status)));
  }

  /// Get entries found in last N days.
  Future<List<ResearchFeedData>> getRecentEntries({int days = 30}) {
    final since = DateTime.now().subtract(Duration(days: days));
    return (select(researchFeed)
          ..where((r) => r.foundDate.isBiggerOrEqualValue(since))
          ..orderBy([(r) => OrderingTerm.desc(r.foundDate)]))
        .get();
  }

  /// Get entries by impact level.
  Future<List<ResearchFeedData>> getByImpact(String impact) {
    return (select(researchFeed)
          ..where((r) => r.impact.equals(impact))
          ..orderBy([(r) => OrderingTerm.desc(r.foundDate)]))
        .get();
  }

  /// Check if a paper with this DOI already exists (dedup).
  Future<bool> existsByDoi(String doi) async {
    final results = await (select(researchFeed)
          ..where((r) => r.doi.equals(doi))
          ..limit(1))
        .get();
    return results.isNotEmpty;
  }

  /// Check if a paper with this title already exists (dedup for non-DOI).
  Future<bool> existsByTitle(String title) async {
    final results = await (select(researchFeed)
          ..where((r) => r.title.equals(title))
          ..limit(1))
        .get();
    return results.isNotEmpty;
  }

  /// Count entries per source for stats.
  Future<Map<String, int>> countBySource() async {
    final all = await select(researchFeed).get();
    final counts = <String, int>{};
    for (final entry in all) {
      counts[entry.source] = (counts[entry.source] ?? 0) + 1;
    }
    return counts;
  }
}

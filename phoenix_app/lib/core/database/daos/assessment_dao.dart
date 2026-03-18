import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'assessment_dao.g.dart';

@DriftAccessor(tables: [Assessments])
class AssessmentDao extends DatabaseAccessor<PhoenixDatabase>
    with _$AssessmentDaoMixin {
  AssessmentDao(super.db);

  Future<int> addAssessment(AssessmentsCompanion entry) {
    return into(assessments).insert(entry);
  }

  Future<bool> updateAssessment(AssessmentsCompanion entry) {
    return update(assessments).replace(entry);
  }

  Future<int> deleteAssessment(int id) {
    return (delete(assessments)..where((a) => a.id.equals(id))).go();
  }

  /// Get all assessments ordered by date descending.
  Future<List<Assessment>> getAll() {
    return (select(assessments)
          ..orderBy([(a) => OrderingTerm.desc(a.date)]))
        .get();
  }

  /// Watch all assessments (for reactive UI).
  Stream<List<Assessment>> watchAll() {
    return (select(assessments)
          ..orderBy([(a) => OrderingTerm.desc(a.date)]))
        .watch();
  }

  /// Get the most recent assessment.
  Future<Assessment?> getLatest() async {
    final results = await (select(assessments)
          ..orderBy([(a) => OrderingTerm.desc(a.date)])
          ..limit(1))
        .get();
    return results.isEmpty ? null : results.first;
  }

  /// Get assessment by ID.
  Future<Assessment?> getById(int id) async {
    final results = await (select(assessments)
          ..where((a) => a.id.equals(id)))
        .get();
    return results.isEmpty ? null : results.first;
  }

  /// Check if an assessment is due (>= 28 days since last one).
  Future<bool> isAssessmentDue() async {
    final latest = await getLatest();
    if (latest == null) return true;
    final daysSince = DateTime.now().difference(latest.date).inDays;
    return daysSince >= 28;
  }

  /// Days until next assessment is due.
  Future<int> daysUntilDue() async {
    final latest = await getLatest();
    if (latest == null) return 0;
    final daysSince = DateTime.now().difference(latest.date).inDays;
    return (28 - daysSince).clamp(0, 28);
  }

  /// Get the last N assessments for trend comparison.
  Future<List<Assessment>> getRecent({int limit = 5}) {
    return (select(assessments)
          ..orderBy([(a) => OrderingTerm.desc(a.date)])
          ..limit(limit))
        .get();
  }
}

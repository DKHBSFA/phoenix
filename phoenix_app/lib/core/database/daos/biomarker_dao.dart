import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'biomarker_dao.g.dart';

@DriftAccessor(tables: [Biomarkers])
class BiomarkerDao extends DatabaseAccessor<PhoenixDatabase>
    with _$BiomarkerDaoMixin {
  BiomarkerDao(super.db);

  Future<int> addBiomarker(BiomarkersCompanion entry) {
    return into(biomarkers).insert(entry);
  }

  Stream<List<Biomarker>> watchByType(String type) {
    return (select(biomarkers)
          ..where((b) => b.type.equals(type))
          ..orderBy([(b) => OrderingTerm.desc(b.date)]))
        .watch();
  }

  Future<List<Biomarker>> getByType(String type, {int? limit}) {
    final query = select(biomarkers)
      ..where((b) => b.type.equals(type))
      ..orderBy([(b) => OrderingTerm.desc(b.date)]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<Biomarker?> getLatestByType(String type) {
    return (select(biomarkers)
          ..where((b) => b.type.equals(type))
          ..orderBy([(b) => OrderingTerm.desc(b.date)])
          ..limit(1))
        .getSingleOrNull();
  }
}

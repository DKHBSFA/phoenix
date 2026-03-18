import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'llm_report_dao.g.dart';

@DriftAccessor(tables: [LlmReports])
class LlmReportDao extends DatabaseAccessor<PhoenixDatabase>
    with _$LlmReportDaoMixin {
  LlmReportDao(super.db);

  Future<int> saveReport({
    required String type,
    required String outputText,
    String promptTemplate = '',
    String contextDataJson = '{}',
  }) {
    return into(llmReports).insert(LlmReportsCompanion.insert(
      generatedAt: DateTime.now(),
      type: type,
      promptTemplate: promptTemplate,
      contextDataJson: contextDataJson,
      outputText: outputText,
    ));
  }

  Future<List<LlmReport>> getByType(String type, {int limit = 10}) {
    return (select(llmReports)
          ..where((r) => r.type.equals(type))
          ..orderBy([(r) => OrderingTerm.desc(r.generatedAt)])
          ..limit(limit))
        .get();
  }

  Stream<List<LlmReport>> watchRecent({int limit = 20}) {
    return (select(llmReports)
          ..orderBy([(r) => OrderingTerm.desc(r.generatedAt)])
          ..limit(limit))
        .watch();
  }
}

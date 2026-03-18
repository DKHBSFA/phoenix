import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'ring_data_dao.g.dart';

@DriftAccessor(tables: [RingHrSamples, RingSleepStages, RingSteps])
class RingDataDao extends DatabaseAccessor<PhoenixDatabase>
    with _$RingDataDaoMixin {
  RingDataDao(super.db);

  // ── HR Samples ──────────────────────────────────────────────

  /// Upsert HR sample — dedup on (timestamp, source).
  Future<void> upsertHrSample(RingHrSamplesCompanion entry) async {
    final ts = entry.timestamp.value;
    final src = entry.source.value;
    final existing = await (select(ringHrSamples)
          ..where((r) => r.timestamp.equals(ts) & r.source.equals(src))
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) {
      await (update(ringHrSamples)..where((r) => r.id.equals(existing.id)))
          .write(entry);
    } else {
      await into(ringHrSamples).insert(entry);
    }
  }

  /// Replace HR samples for a day (delete existing log_sync entries, then insert).
  Future<void> replaceHrSamplesForDay(
    DateTime day,
    List<RingHrSamplesCompanion> entries,
  ) async {
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    await (delete(ringHrSamples)
          ..where((r) =>
              r.timestamp.isBetweenValues(dayStart, dayEnd) &
              r.source.equals('log_sync')))
        .go();
    if (entries.isNotEmpty) {
      await batch((b) => b.insertAll(ringHrSamples, entries));
    }
  }

  /// Watch HR samples for a date range.
  Stream<List<RingHrSample>> watchHrSamples(DateTime start, DateTime end) {
    return (select(ringHrSamples)
          ..where((r) => r.timestamp.isBetweenValues(start, end))
          ..orderBy([(r) => OrderingTerm.asc(r.timestamp)]))
        .watch();
  }

  /// Get HR samples for a date range (non-reactive).
  Future<List<RingHrSample>> getHrSamples(DateTime start, DateTime end) {
    return (select(ringHrSamples)
          ..where((r) => r.timestamp.isBetweenValues(start, end))
          ..orderBy([(r) => OrderingTerm.asc(r.timestamp)]))
        .get();
  }

  // ── Sleep Stages ────────────────────────────────────────────

  /// Insert sleep stages for a night (delete existing first).
  Future<void> replaceSleepStages(
    DateTime nightDate,
    List<RingSleepStagesCompanion> stages,
  ) async {
    final dayStart = DateTime(nightDate.year, nightDate.month, nightDate.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    await (delete(ringSleepStages)
          ..where((r) => r.nightDate.isBetweenValues(dayStart, dayEnd)))
        .go();
    await batch((b) => b.insertAll(ringSleepStages, stages));
  }

  /// Get sleep stages for a night.
  Future<List<RingSleepStage>> getSleepStages(DateTime nightDate) {
    final dayStart = DateTime(nightDate.year, nightDate.month, nightDate.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return (select(ringSleepStages)
          ..where((r) => r.nightDate.isBetweenValues(dayStart, dayEnd))
          ..orderBy([(r) => OrderingTerm.asc(r.startTime)]))
        .get();
  }

  /// Check if we have sleep data for last night.
  Future<bool> hasLastNightSleep() async {
    final now = DateTime.now();
    final nightDate = now.hour < 12
        ? DateTime(now.year, now.month, now.day - 1)
        : DateTime(now.year, now.month, now.day);
    final stages = await getSleepStages(nightDate);
    return stages.isNotEmpty;
  }

  // ── Steps ───────────────────────────────────────────────────

  /// Insert steps (batch, for sync).
  Future<void> insertSteps(List<RingStepsCompanion> entries) {
    return batch((b) => b.insertAll(ringSteps, entries));
  }

  /// Delete steps for a day then re-insert (sync replaces full day).
  Future<void> replaceStepsForDay(
    DateTime day,
    List<RingStepsCompanion> entries,
  ) async {
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    await (delete(ringSteps)
          ..where((r) => r.timestamp.isBetweenValues(dayStart, dayEnd)))
        .go();
    if (entries.isNotEmpty) {
      await batch((b) => b.insertAll(ringSteps, entries));
    }
  }

  /// Get total steps for today.
  Future<int> getTodaySteps() async {
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final rows = await (select(ringSteps)
          ..where((r) => r.timestamp.isBetweenValues(dayStart, dayEnd)))
        .get();
    return rows.fold<int>(0, (sum, r) => sum + r.steps);
  }

  /// Watch steps for a day.
  Stream<List<RingStep>> watchStepsForDay(DateTime day) {
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return (select(ringSteps)
          ..where((r) => r.timestamp.isBetweenValues(dayStart, dayEnd))
          ..orderBy([(r) => OrderingTerm.asc(r.timestamp)]))
        .watch();
  }
}

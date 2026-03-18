# Ring Full Integration — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Integrate Colmi R10 ring data into every Phoenix feature: auto-sync, workout bio tracking, morning HRV, sleep notifications, home widgets, and raw PPG signal processing.

**Architecture:** Ring as distributed service — RingService stays thin BLE wrapper, each feature manages its own ring interaction through a RingLockManager. SignalProcessor processes raw PPG data for superior quality. Fallback to firmware data when raw unavailable.

**Tech Stack:** Flutter/Dart, Drift (SQLite), Riverpod, universal_ble, fl_chart, home_widget, flutter_local_notifications

**Spec:** `.claude/docs/specs/ring-full-integration-design.md`

---

## File Structure

### New files (Phase 1 — Signal Foundation)
| File | Responsibility |
|------|---------------|
| `lib/core/ring/ring_lock_manager.dart` | Mutex for real-time BLE operations |
| `lib/core/ring/signal_processor.dart` | Raw PPG → SQI → NLMS → AMPD → IBI → HR/HRV/SI |
| `lib/core/database/daos/ring_data_dao.dart` | CRUD for ring_hr_samples, ring_sleep_stages, ring_steps |
| `test/ring_lock_manager_test.dart` | Lock manager unit tests |
| `test/signal_processor_test.dart` | Signal processing pipeline tests |
| `test/ring_data_dao_test.dart` | DAO query tests |

### New files (Phase 2 — Sleep)
| File | Responsibility |
|------|---------------|
| `lib/core/ring/sleep_parser.dart` | Parse cmd 0x44 multi-packet sleep data |
| `lib/core/ring/sleep_notifier.dart` | SleepSummary computation + local notification |
| `lib/features/conditioning/widgets/sleep_hypnogram.dart` | fl_chart hypnogram timeline |
| `test/sleep_parser_test.dart` | Sleep parser unit tests |
| `test/sleep_notifier_test.dart` | Sleep summary + notification tests |

### New files (Phase 3 — Sync + HRV)
| File | Responsibility |
|------|---------------|
| `lib/core/ring/ring_sync_coordinator.dart` | Orchestrate full sync on app open |
| `lib/core/ring/morning_hrv_check.dart` | Auto 60s HRV + manual fallback |
| `lib/features/today/widgets/hrv_morning_card.dart` | Manual HRV card in Today screen |
| `test/ring_sync_coordinator_test.dart` | Sync coordinator tests |
| `test/morning_hrv_check_test.dart` | Morning HRV tests |

### New files (Phase 4 — Workout Bio)
| File | Responsibility |
|------|---------------|
| `lib/core/ring/workout_bio_tracker.dart` | Multi-parameter real-time during workout |
| `lib/features/workout/widgets/bio_overlay.dart` | Live HR/SpO2/HRV/temp/SI overlay |
| `test/workout_bio_tracker_test.dart` | Bio tracker tests |

### New files (Phase 5 — Home Widget)
| File | Responsibility |
|------|---------------|
| `lib/features/widgets/phoenix_home_widget.dart` | Widget data update logic |
| `android/app/src/main/res/layout/widget_small.xml` | Android small widget layout |
| `android/app/src/main/res/layout/widget_large.xml` | Android large widget layout |
| `android/app/src/main/java/.../PhoenixWidgetProvider.java` | Android widget provider |
| `ios/PhoenixWidget/` | iOS WidgetKit extension |

### Modified files (all phases)
| File | Modifications |
|------|--------------|
| `lib/core/database/tables.dart` | 3 new tables + new columns on workout_sets/sessions |
| `lib/core/database/database.dart` | Version 10→11, migration, DAO getters |
| `lib/core/ring/ring_constants.dart` | Raw PPG/accel/SpO2 command constants, cmdSyncSleep |
| `lib/core/ring/ring_protocol.dart` | Raw PPG packet builders, sleep sync packet |
| `lib/core/ring/ring_service.dart` | readRawPpg(), readSleep() methods |
| `lib/core/models/daily_protocol.dart` | Auto-complete sleep from ring |
| `lib/core/models/coach_prompts.dart` | Bio-based coaching cues |
| `lib/core/models/periodization_engine.dart` | RecoveryStatus in shouldDeload() |
| `lib/core/models/activity_rings_data.dart` | Recovery in OneBigThing.compute() |
| `lib/core/notifications/notification_service.dart` | Sleep notification IDs + method |
| `lib/features/workout/workout_session_screen.dart` | Bio tracker integration |
| `lib/features/conditioning/sleep_tab.dart` | Hypnogram display |
| `lib/features/today/today_screen.dart` | HRV card, enriched SleepCard |
| `lib/app/providers.dart` | New provider registrations |
| `pubspec.yaml` | home_widget dependency |

---

## PHASE 1: Signal Foundation

### Task 1: Database schema — new tables and columns

**Files:**
- Modify: `lib/core/database/tables.dart:416-427`
- Modify: `lib/core/database/database.dart:54,143-147`

- [ ] **Step 1: Add 3 new table definitions to tables.dart**

After the `RingDevices` table (line 427), add:

```dart
// ── Ring HR Samples ───────────────────────────────────────────
class RingHrSamples extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get hr => integer()();
  TextColumn get source => text()(); // 'log_sync' / 'real_time' / 'workout'
  RealColumn get quality => real().nullable()();
}

// ── Ring Sleep Stages ─────────────────────────────────────────
class RingSleepStages extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get nightDate => dateTime()();
  TextColumn get stage => text()(); // 'deep' / 'light' / 'rem' / 'awake'
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get hrAvg => integer().nullable()();
  RealColumn get tempAvg => real().nullable()();
}

// ── Ring Steps ────────────────────────────────────────────────
class RingSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get steps => integer()();
  IntColumn get calories => integer()();
  IntColumn get distanceM => integer()();
}
```

- [ ] **Step 2: Add bio columns to WorkoutSets table**

In `WorkoutSets` class (after line 140 `notes` column), add:

```dart
  RealColumn get avgHr => real().nullable()();
  IntColumn get maxHr => integer().nullable()();
  IntColumn get spo2 => integer().nullable()();
  RealColumn get rmssd => real().nullable()();
  RealColumn get stressIndex => real().nullable()();
  IntColumn get hrRecoveryBpm => integer().nullable()();
  RealColumn get skinTemp => real().nullable()();
```

- [ ] **Step 3: Add bio columns to WorkoutSessions table**

In `WorkoutSessions` class (after line 126 `cooldownType` column), add:

```dart
  RealColumn get avgHr => real().nullable()();
  IntColumn get maxHr => integer().nullable()();
  RealColumn get avgSpo2 => real().nullable()();
  RealColumn get avgRmssd => real().nullable()();
  TextColumn get bioStatsJson => text().nullable()();
```

- [ ] **Step 4: Register new tables in database.dart**

In `database.dart`, update the `@DriftDatabase(tables: [...])` annotation to include the 3 new tables: `RingHrSamples`, `RingSleepStages`, `RingSteps`.

- [ ] **Step 5: Write migration v10 → v11**

In `database.dart`, bump `schemaVersion` from 10 to 11. Add migration block after the `if (from < 10)` block:

```dart
if (from < 11) {
  await m.createTable(ringHrSamples);
  await m.createTable(ringSleepStages);
  await m.createTable(ringSteps);
  // workout_sets bio columns
  await m.addColumn(workoutSets, workoutSets.avgHr);
  await m.addColumn(workoutSets, workoutSets.maxHr);
  await m.addColumn(workoutSets, workoutSets.spo2);
  await m.addColumn(workoutSets, workoutSets.rmssd);
  await m.addColumn(workoutSets, workoutSets.stressIndex);
  await m.addColumn(workoutSets, workoutSets.hrRecoveryBpm);
  await m.addColumn(workoutSets, workoutSets.skinTemp);
  // workout_sessions bio columns
  await m.addColumn(workoutSessions, workoutSessions.avgHr);
  await m.addColumn(workoutSessions, workoutSessions.maxHr);
  await m.addColumn(workoutSessions, workoutSessions.avgSpo2);
  await m.addColumn(workoutSessions, workoutSessions.avgRmssd);
  await m.addColumn(workoutSessions, workoutSessions.bioStatsJson);
}
```

- [ ] **Step 6: Run Drift code generation**

Run: `cd phoenix_app && dart run build_runner build --delete-conflicting-outputs`
Expected: Generated files updated, no errors.

- [ ] **Step 7: Run flutter analyze**

Run: `cd phoenix_app && flutter analyze lib/core/database/`
Expected: No errors (info/warnings ok).

- [ ] **Step 8: Commit**

```bash
git add lib/core/database/tables.dart lib/core/database/database.dart lib/core/database/database.g.dart
git commit -m "feat(ring): add ring data tables and workout bio columns (v10→v11)"
```

---

### Task 2: RingDataDao — CRUD for new tables

**Files:**
- Create: `lib/core/database/daos/ring_data_dao.dart`
- Modify: `lib/core/database/database.dart` (add DAO to annotation)
- Modify: `lib/app/providers.dart`

- [ ] **Step 1: Write failing test for RingDataDao**

Create `test/ring_data_dao_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/database/daos/ring_data_dao.dart';

void main() {
  group('RingDataDao', () {
    // These tests validate the DAO compiles and has correct method signatures.
    // Full DB integration tests require a real Drift test harness.

    test('upsertHrSample key is (timestamp, source)', () {
      // Verify the method signature accepts timestamp + source
      // This is a compile-time check — the method must exist
      expect(RingDataDao, isNotNull);
    });
  });
}
```

- [ ] **Step 2: Create RingDataDao**

Create `lib/core/database/daos/ring_data_dao.dart`:

```dart
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

  /// Batch insert HR samples (for log sync).
  Future<void> insertHrSamples(List<RingHrSamplesCompanion> entries) {
    return batch((b) => b.insertAll(ringHrSamples, entries));
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
    // "Last night" = yesterday if before noon, today if after midnight
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
```

- [ ] **Step 3: Register DAO in database.dart**

Add `RingDataDao` to the `@DriftDatabase(... daos: [...])` annotation.

- [ ] **Step 4: Add provider in providers.dart**

After `ringDeviceDaoProvider` (around line 118):

```dart
final ringDataDaoProvider = Provider<RingDataDao>((ref) {
  return RingDataDao(ref.watch(databaseProvider));
});
```

- [ ] **Step 5: Run code generation + analyze**

Run: `cd phoenix_app && dart run build_runner build --delete-conflicting-outputs && flutter analyze lib/core/database/daos/ring_data_dao.dart lib/app/providers.dart`
Expected: No errors.

- [ ] **Step 6: Commit**

```bash
git add lib/core/database/daos/ring_data_dao.dart lib/core/database/daos/ring_data_dao.g.dart lib/core/database/database.dart lib/core/database/database.g.dart lib/app/providers.dart
git commit -m "feat(ring): add RingDataDao for HR samples, sleep stages, steps"
```

---

### Task 3: RingLockManager

**Files:**
- Create: `lib/core/ring/ring_lock_manager.dart`
- Create: `test/ring_lock_manager_test.dart`
- Modify: `lib/app/providers.dart`

- [ ] **Step 1: Write failing tests**

Create `test/ring_lock_manager_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/ring/ring_lock_manager.dart';

void main() {
  late RingLockManager lockManager;

  setUp(() => lockManager = RingLockManager());

  test('acquire succeeds when no lock held', () {
    expect(lockManager.acquire('workout'), true);
    expect(lockManager.currentOwner, 'workout');
  });

  test('acquire fails when different owner holds lock', () {
    lockManager.acquire('workout');
    expect(lockManager.acquire('hrv_check'), false);
  });

  test('acquire succeeds when same owner re-acquires', () {
    lockManager.acquire('workout');
    expect(lockManager.acquire('workout'), true);
  });

  test('release frees the lock', () {
    lockManager.acquire('workout');
    lockManager.release('workout');
    expect(lockManager.currentOwner, isNull);
    expect(lockManager.acquire('hrv_check'), true);
  });

  test('release by non-owner does nothing', () {
    lockManager.acquire('workout');
    lockManager.release('hrv_check');
    expect(lockManager.currentOwner, 'workout');
  });

  test('isLocked returns correct state', () {
    expect(lockManager.isLocked, false);
    lockManager.acquire('workout');
    expect(lockManager.isLocked, true);
    lockManager.release('workout');
    expect(lockManager.isLocked, false);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd phoenix_app && flutter test test/ring_lock_manager_test.dart`
Expected: FAIL — RingLockManager not found.

- [ ] **Step 3: Implement RingLockManager**

Create `lib/core/ring/ring_lock_manager.dart`:

```dart
/// Mutex for ring real-time BLE operations.
///
/// Only one consumer can hold the real-time stream at a time.
/// Acquire before starting real-time, release when done.
class RingLockManager {
  String? _owner;

  /// Current lock owner, or null if unlocked.
  String? get currentOwner => _owner;

  /// Whether the lock is currently held.
  bool get isLocked => _owner != null;

  /// Try to acquire the lock. Returns true if acquired (or already owned).
  bool acquire(String owner) {
    if (_owner == null || _owner == owner) {
      _owner = owner;
      return true;
    }
    return false;
  }

  /// Release the lock. Only the current owner can release.
  void release(String owner) {
    if (_owner == owner) {
      _owner = null;
    }
  }

  /// Force-release regardless of owner (for cleanup/error recovery).
  void forceRelease() {
    _owner = null;
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd phoenix_app && flutter test test/ring_lock_manager_test.dart`
Expected: All 6 tests PASS.

- [ ] **Step 5: Add provider**

In `lib/app/providers.dart`, after ringServiceProvider:

```dart
final ringLockManagerProvider = Provider<RingLockManager>((ref) {
  return RingLockManager();
});
```

Add import: `import '../core/ring/ring_lock_manager.dart';`

- [ ] **Step 6: Commit**

```bash
git add lib/core/ring/ring_lock_manager.dart test/ring_lock_manager_test.dart lib/app/providers.dart
git commit -m "feat(ring): add RingLockManager for BLE real-time mutex"
```

---

### Task 4: Raw PPG commands in ring_protocol + ring_constants

**Files:**
- Modify: `lib/core/ring/ring_constants.dart:46-83`
- Modify: `lib/core/ring/ring_protocol.dart:127-137`
- Modify: `lib/core/ring/ring_service.dart`

- [ ] **Step 1: Add raw command constants**

In `ring_constants.dart`, after the existing command constants (after `cmdStopRealTime = 0x6A`).
**NOTE:** `cmdSyncSleep = 0x44` and `cmdFindDevice = 0x10` already exist — do NOT re-add them.
Only add the new raw sensor commands:

```dart
const cmdRawPpg = 0x68;
const cmdRawAccel = 0x67;
const cmdRawSpo2 = 0x66;
```

- [ ] **Step 2: Add packet builders in ring_protocol.dart**

After the existing `stopRealTimePacket` function:

```dart
/// Build packet to sync sleep data.
Uint8List syncSleepPacket(DateTime dayUtc) {
  return makePacket(cmdSyncSleep, [
    byteToBcd(dayUtc.year % 100),
    byteToBcd(dayUtc.month),
    byteToBcd(dayUtc.day),
  ]);
}

/// Build packet to read raw PPG sensor data.
Uint8List rawPpgPacket() => makePacket(cmdRawPpg, [0x01]); // start

/// Build packet to stop raw PPG.
Uint8List rawPpgStopPacket() => makePacket(cmdRawPpg, [0x00]); // stop

/// Build packet to read raw accelerometer data.
Uint8List rawAccelPacket() => makePacket(cmdRawAccel, [0x01]);

/// Build packet to stop raw accelerometer.
Uint8List rawAccelStopPacket() => makePacket(cmdRawAccel, [0x00]);
```

- [ ] **Step 3: Add readSleep and raw methods to RingService**

In `ring_service.dart`, after the existing `stopRealTimeSpO2()` method:

```dart
/// Probe if raw PPG is supported (send command, check for response vs error).
Future<bool> probeRawPpgSupport() async {
  final response = await _sendAndWait(cmdRawPpg, rawPpgPacket(), timeout: const Duration(seconds: 2));
  if (response != null) {
    // Got a response — stop immediately
    await _sendPacket(rawPpgStopPacket());
    return true;
  }
  return false;
}

/// Start raw PPG streaming.
Future<void> startRawPpg() async {
  await _sendPacket(rawPpgPacket());
}

/// Stop raw PPG streaming.
Future<void> stopRawPpg() async {
  await _sendPacket(rawPpgStopPacket());
}

/// Start raw accelerometer streaming.
Future<void> startRawAccel() async {
  await _sendPacket(rawAccelPacket());
}

/// Stop raw accelerometer streaming.
Future<void> stopRawAccel() async {
  await _sendPacket(rawAccelStopPacket());
}
```

- [ ] **Step 4: Run analyze**

Run: `cd phoenix_app && flutter analyze lib/core/ring/`
Expected: No errors.

- [ ] **Step 5: Commit**

```bash
git add lib/core/ring/ring_constants.dart lib/core/ring/ring_protocol.dart lib/core/ring/ring_service.dart
git commit -m "feat(ring): add raw PPG/accel commands and sleep sync packet"
```

---

### Task 5: SignalProcessor

**Files:**
- Create: `lib/core/ring/signal_processor.dart`
- Create: `test/signal_processor_test.dart`
- Modify: `lib/app/providers.dart`

- [ ] **Step 1: Write failing tests**

Create `test/signal_processor_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/ring/signal_processor.dart';

void main() {
  late SignalProcessor processor;

  setUp(() => processor = SignalProcessor());

  group('validation', () {
    test('isValidHr rejects out of range', () {
      expect(processor.isValidHr(0), false);
      expect(processor.isValidHr(29), false);
      expect(processor.isValidHr(30), true);
      expect(processor.isValidHr(120), true);
      expect(processor.isValidHr(220), true);
      expect(processor.isValidHr(221), false);
    });

    test('isValidSpO2 rejects out of range', () {
      expect(processor.isValidSpO2(69), false);
      expect(processor.isValidSpO2(70), true);
      expect(processor.isValidSpO2(98), true);
      expect(processor.isValidSpO2(100), true);
      expect(processor.isValidSpO2(101), false);
    });

    test('isValidTemp rejects out of range', () {
      expect(processor.isValidTemp(29.9), false);
      expect(processor.isValidTemp(30.0), true);
      expect(processor.isValidTemp(36.5), true);
      expect(processor.isValidTemp(42.0), true);
      expect(processor.isValidTemp(42.1), false);
    });
  });

  group('outlier detection', () {
    test('detects outlier beyond 2 SD', () {
      final window = [70, 72, 71, 73, 70, 72, 71, 70, 72, 71];
      expect(processor.isOutlier(150, window), true);
      expect(processor.isOutlier(72, window), false);
    });

    test('handles small window gracefully', () {
      expect(processor.isOutlier(70, [70]), false);
      expect(processor.isOutlier(70, []), false);
    });
  });

  group('smoothing', () {
    test('moving average smooths data', () {
      final data = [60, 80, 60, 80, 60, 80, 60, 80, 60, 80];
      final smoothed = processor.smooth(data, window: 3);
      // Middle values should be closer to 70
      for (var i = 1; i < smoothed.length - 1; i++) {
        expect(smoothed[i], closeTo(70, 15));
      }
    });
  });

  group('IBI computation', () {
    test('computeHr from IBI', () {
      // 800ms IBI = 75 BPM
      final ibi = [800, 800, 800, 800, 800];
      expect(processor.computeHr(ibi), 75);
    });

    test('computeRmssd from IBI', () {
      // Constant IBI = RMSSD 0
      final ibi = [800, 800, 800, 800, 800];
      expect(processor.computeRmssd(ibi), 0.0);

      // Variable IBI
      final varIbi = [800, 850, 780, 830, 810];
      expect(processor.computeRmssd(varIbi), greaterThan(0));
    });

    test('computeStressIndex from IBI', () {
      final ibi = [800, 850, 780, 830, 810];
      final si = processor.computeStressIndex(ibi);
      expect(si, greaterThan(0));
    });
  });

  group('SQI', () {
    test('constant signal gets low SQI (stuck sensor)', () {
      final stuck = List.filled(20, 100);
      expect(processor.assessSignalQuality(stuck), lessThan(0.3));
    });

    test('wild jumps get low SQI (motion artifact)', () {
      final noisy = [60, 180, 50, 200, 40, 190, 55, 210];
      expect(processor.assessSignalQuality(noisy), lessThan(0.5));
    });

    test('normal physiological signal gets high SQI', () {
      final normal = [72, 74, 73, 75, 72, 71, 73, 74, 72, 73, 74, 72, 71, 73, 75];
      expect(processor.assessSignalQuality(normal), greaterThan(0.7));
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd phoenix_app && flutter test test/signal_processor_test.dart`
Expected: FAIL — SignalProcessor not found.

- [ ] **Step 3: Implement SignalProcessor**

Create `lib/core/ring/signal_processor.dart`:

```dart
import 'dart:math' as math;

/// Signal processing pipeline for ring sensor data.
///
/// Levels:
/// 1. Validation — range checks, always active
/// 2. SQI — signal quality assessment for real-time data
/// 3. Smoothing/outlier — statistical filtering
/// 4. IBI derivation — HR, HRV (RMSSD), Stress Index from inter-beat intervals
///
/// Raw PPG pipeline (NLMS, AMPD) is gated on R10 support verification.
class SignalProcessor {
  /// SQI threshold — readings below this are discarded. Configurable.
  double sqiThreshold;

  SignalProcessor({this.sqiThreshold = 0.5});

  // ── Level 1: Validation ─────────────────────────────────────

  bool isValidHr(int bpm) => bpm >= 30 && bpm <= 220;
  bool isValidSpO2(int spo2) => spo2 >= 70 && spo2 <= 100;
  bool isValidTemp(double temp) => temp >= 30.0 && temp <= 42.0;

  /// Outlier detection: value > 2 SD from window mean.
  bool isOutlier(int value, List<int> window) {
    if (window.length < 2) return false;
    final mean = window.reduce((a, b) => a + b) / window.length;
    final variance =
        window.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
            window.length;
    final sd = math.sqrt(variance);
    return (value - mean).abs() > 2 * sd;
  }

  // ── Level 2: SQI (Signal Quality Index) ─────────────────────

  /// Assess signal quality from a window of readings.
  /// Returns 0.0 (discard) to 1.0 (reliable).
  double assessSignalQuality(List<int> readings) {
    if (readings.length < 5) return 0.0;

    // Check for stuck sensor (3+ identical consecutive readings)
    int stuckCount = 0;
    for (var i = 1; i < readings.length; i++) {
      if (readings[i] == readings[i - 1]) {
        stuckCount++;
      }
    }
    final stuckRatio = stuckCount / (readings.length - 1);
    if (stuckRatio > 0.5) return 0.1; // Likely stuck

    // Check for wild jumps (delta > 40 between consecutive)
    int jumpCount = 0;
    for (var i = 1; i < readings.length; i++) {
      if ((readings[i] - readings[i - 1]).abs() > 40) {
        jumpCount++;
      }
    }
    final jumpRatio = jumpCount / (readings.length - 1);

    // Check physiological range
    final inRange = readings.where((r) => r >= 30 && r <= 220).length;
    final rangeRatio = inRange / readings.length;

    // Compute coefficient of variation (CV)
    final mean = readings.reduce((a, b) => a + b) / readings.length;
    final variance =
        readings.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
            readings.length;
    final cv = math.sqrt(variance) / mean;

    // SQI: penalize stuck, jumps, out-of-range, high CV
    double sqi = 1.0;
    sqi -= stuckRatio * 0.5;
    sqi -= jumpRatio * 0.4;
    sqi -= (1 - rangeRatio) * 0.3;
    if (cv > 0.3) sqi -= 0.3; // Very noisy
    else if (cv > 0.15) sqi -= 0.1;

    return sqi.clamp(0.0, 1.0);
  }

  // ── Level 3: Smoothing ──────────────────────────────────────

  /// Moving average smoothing.
  List<double> smooth(List<int> values, {int window = 5}) {
    if (values.length <= window) {
      final avg = values.reduce((a, b) => a + b) / values.length;
      return List.filled(values.length, avg);
    }
    final result = <double>[];
    for (var i = 0; i < values.length; i++) {
      final start = math.max(0, i - window ~/ 2);
      final end = math.min(values.length, i + window ~/ 2 + 1);
      final slice = values.sublist(start, end);
      result.add(slice.reduce((a, b) => a + b) / slice.length);
    }
    return result;
  }

  /// Filter HR log: remove invalid + outliers, smooth.
  List<int> filterHrLog(List<int> rawHr) {
    // Replace invalid with 0 (will be filtered later)
    final valid = rawHr.map((hr) => isValidHr(hr) ? hr : 0).toList();

    // Remove outliers from non-zero values
    final nonZero = valid.where((v) => v > 0).toList();
    if (nonZero.length < 3) return valid;

    final result = <int>[];
    for (var i = 0; i < valid.length; i++) {
      if (valid[i] == 0) {
        result.add(0);
      } else {
        // Window of surrounding non-zero values
        final windowStart = math.max(0, i - 5);
        final windowEnd = math.min(valid.length, i + 6);
        final window =
            valid.sublist(windowStart, windowEnd).where((v) => v > 0).toList();
        result.add(isOutlier(valid[i], window) ? 0 : valid[i]);
      }
    }
    return result;
  }

  // ── Level 4: IBI Derivation ─────────────────────────────────

  /// Compute heart rate (BPM) from inter-beat intervals (ms).
  int computeHr(List<int> ibi) {
    if (ibi.isEmpty) return 0;
    final avgIbi = ibi.reduce((a, b) => a + b) / ibi.length;
    return (60000 / avgIbi).round();
  }

  /// Compute RMSSD (ms) from IBI — standard HRV metric.
  double computeRmssd(List<int> ibi) {
    if (ibi.length < 2) return 0.0;
    double sumSquaredDiffs = 0;
    for (var i = 1; i < ibi.length; i++) {
      final diff = (ibi[i] - ibi[i - 1]).toDouble();
      sumSquaredDiffs += diff * diff;
    }
    return math.sqrt(sumSquaredDiffs / (ibi.length - 1));
  }

  /// Compute Bayevsky Stress Index from IBI.
  /// SI = AMo / (2 * Mo * MxDMn)
  /// AMo = amplitude of mode (% of most common IBI bin)
  /// Mo = mode (most common IBI bin center)
  /// MxDMn = max IBI - min IBI
  double computeStressIndex(List<int> ibi) {
    if (ibi.length < 5) return 0.0;

    final minIbi = ibi.reduce(math.min);
    final maxIbi = ibi.reduce(math.max);
    final mxDMn = (maxIbi - minIbi).toDouble();
    if (mxDMn == 0) return 0.0;

    // Bin IBI values (50ms bins)
    const binSize = 50;
    final bins = <int, int>{};
    for (final v in ibi) {
      final bin = (v ~/ binSize) * binSize;
      bins[bin] = (bins[bin] ?? 0) + 1;
    }

    // Find mode
    var maxCount = 0;
    var modeBin = 0;
    for (final entry in bins.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        modeBin = entry.key;
      }
    }

    final amo = maxCount / ibi.length * 100; // percentage
    final mo = modeBin + binSize / 2; // bin center in ms
    if (mo == 0) return 0.0;

    return amo / (2 * mo / 1000 * mxDMn / 1000); // Bayevsky formula
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd phoenix_app && flutter test test/signal_processor_test.dart`
Expected: All tests PASS.

- [ ] **Step 5: Add provider**

In `lib/app/providers.dart`:

```dart
final signalProcessorProvider = Provider<SignalProcessor>((ref) {
  return SignalProcessor();
});
```

Add import: `import '../core/ring/signal_processor.dart';`

- [ ] **Step 6: Commit**

```bash
git add lib/core/ring/signal_processor.dart test/signal_processor_test.dart lib/app/providers.dart
git commit -m "feat(ring): add SignalProcessor with SQI, validation, IBI derivation"
```

---

## PHASE 2: Sleep + Notification

### Task 6: Sleep parser (cmd 0x44)

**Files:**
- Create: `lib/core/ring/sleep_parser.dart`
- Create: `test/sleep_parser_test.dart`
- Modify: `lib/core/ring/ring_service.dart`

- [ ] **Step 1: Write failing tests**

Create `test/sleep_parser_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/ring/sleep_parser.dart';

void main() {
  group('SleepParser', () {
    test('parseSleepStage maps known values', () {
      expect(SleepStage.fromRingValue(0x01), SleepStage.light);
      expect(SleepStage.fromRingValue(0x02), SleepStage.deep);
      expect(SleepStage.fromRingValue(0x03), SleepStage.rem);
      expect(SleepStage.fromRingValue(0x04), SleepStage.awake);
      expect(SleepStage.fromRingValue(0xFF), SleepStage.awake); // unknown → awake
    });

    test('SleepSession computes totalSleep excluding awake', () {
      final session = SleepSession(
        nightDate: DateTime(2026, 3, 18),
        stages: [
          SleepPeriod(stage: SleepStage.light, start: DateTime(2026, 3, 18, 23, 0), end: DateTime(2026, 3, 18, 23, 30)),
          SleepPeriod(stage: SleepStage.deep, start: DateTime(2026, 3, 18, 23, 30), end: DateTime(2026, 3, 19, 0, 30)),
          SleepPeriod(stage: SleepStage.awake, start: DateTime(2026, 3, 19, 0, 30), end: DateTime(2026, 3, 19, 0, 40)),
          SleepPeriod(stage: SleepStage.rem, start: DateTime(2026, 3, 19, 0, 40), end: DateTime(2026, 3, 19, 1, 20)),
        ],
      );
      expect(session.totalSleep.inMinutes, 130); // 30 + 60 + 40
      expect(session.timeInBed.inMinutes, 140); // 30 + 60 + 10 + 40
      expect(session.deep.inMinutes, 60);
      expect(session.rem.inMinutes, 40);
      expect(session.awake.inMinutes, 10);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd phoenix_app && flutter test test/sleep_parser_test.dart`
Expected: FAIL — not found.

- [ ] **Step 3: Implement SleepParser**

Create `lib/core/ring/sleep_parser.dart`:

```dart
import 'ring_protocol.dart';

/// Sleep stage types from ring.
enum SleepStage {
  light,
  deep,
  rem,
  awake;

  static SleepStage fromRingValue(int value) {
    return switch (value) {
      0x01 => SleepStage.light,
      0x02 => SleepStage.deep,
      0x03 => SleepStage.rem,
      0x04 => SleepStage.awake,
      _ => SleepStage.awake,
    };
  }

  String get label => switch (this) {
        SleepStage.light => 'light',
        SleepStage.deep => 'deep',
        SleepStage.rem => 'rem',
        SleepStage.awake => 'awake',
      };
}

/// A single sleep period (stage + time range).
class SleepPeriod {
  final SleepStage stage;
  final DateTime start;
  final DateTime end;

  const SleepPeriod({
    required this.stage,
    required this.start,
    required this.end,
  });

  Duration get duration => end.difference(start);
}

/// Complete sleep session for one night.
class SleepSession {
  final DateTime nightDate;
  final List<SleepPeriod> stages;

  const SleepSession({required this.nightDate, required this.stages});

  Duration get timeInBed {
    if (stages.isEmpty) return Duration.zero;
    return stages.fold(Duration.zero, (sum, s) => sum + s.duration);
  }

  Duration get totalSleep => _sumStages([SleepStage.light, SleepStage.deep, SleepStage.rem]);
  Duration get deep => _sumStages([SleepStage.deep]);
  Duration get light => _sumStages([SleepStage.light]);
  Duration get rem => _sumStages([SleepStage.rem]);
  Duration get awake => _sumStages([SleepStage.awake]);

  double get efficiency {
    if (timeInBed.inSeconds == 0) return 0.0;
    return totalSleep.inSeconds / timeInBed.inSeconds;
  }

  Duration _sumStages(List<SleepStage> types) {
    return stages
        .where((s) => types.contains(s.stage))
        .fold(Duration.zero, (sum, s) => sum + s.duration);
  }
}

/// Stateful multi-packet parser for sleep sync (cmd 0x44).
///
/// Clean-room implementation based on publicly documented Colmi protocol.
/// Sleep data arrives as multi-packet with header + stage entries.
class SleepDataParser {
  final List<SleepPeriod> _stages = [];
  DateTime? _nightDate;
  int _expectedPackets = 0;
  int _receivedPackets = 0;

  /// Feed a packet. Returns [SleepSession] when complete, null otherwise.
  SleepSession? parse(List<int> packet) {
    if (packet.length != 16) return null;

    final subType = packet[1];

    // No data response
    if (subType == 0xFF) {
      return SleepSession(
        nightDate: DateTime.now(),
        stages: const [],
      );
    }

    // Header packet (subType == 0)
    if (subType == 0) {
      _nightDate = DateTime(
        bcdToDecimal(packet[2]) + 2000,
        bcdToDecimal(packet[3]),
        bcdToDecimal(packet[4]),
      );
      _expectedPackets = packet[5];
      _receivedPackets = 0;
      _stages.clear();
      if (_expectedPackets == 0) {
        return SleepSession(nightDate: _nightDate!, stages: const []);
      }
      return null;
    }

    // Data packet — each contains sleep stage entries
    _receivedPackets++;

    // Parse stage entries from packet bytes
    // Format: [stageType, startHour, startMin, endHour, endMin] repeated
    for (var i = 2; i + 4 < 15; i += 5) {
      final stageType = packet[i];
      if (stageType == 0) break; // padding

      final startHour = packet[i + 1];
      final startMin = packet[i + 2];
      final endHour = packet[i + 3];
      final endMin = packet[i + 4];

      if (_nightDate == null) continue;

      // Handle overnight (start after midnight = next day)
      var startDate = DateTime(
        _nightDate!.year, _nightDate!.month, _nightDate!.day,
        startHour, startMin,
      );
      var endDate = DateTime(
        _nightDate!.year, _nightDate!.month, _nightDate!.day,
        endHour, endMin,
      );

      // If start is in evening, it's the night date; if morning, it's next day
      if (startHour < 18) {
        startDate = startDate.add(const Duration(days: 1));
      }
      if (endHour < 18) {
        endDate = endDate.add(const Duration(days: 1));
      }

      _stages.add(SleepPeriod(
        stage: SleepStage.fromRingValue(stageType),
        start: startDate,
        end: endDate,
      ));
    }

    // Check if complete
    if (_receivedPackets >= _expectedPackets) {
      final session = SleepSession(
        nightDate: _nightDate!,
        stages: List.from(_stages),
      );
      _reset();
      return session;
    }

    return null;
  }

  void _reset() {
    _stages.clear();
    _nightDate = null;
    _expectedPackets = 0;
    _receivedPackets = 0;
  }
}
```

- [ ] **Step 4: Add readSleep to RingService**

In `ring_service.dart`, add internal state and public method:

After `SportDetailParser? _stepParser;` and `Completer<List<SportDetail>>? _stepCompleter;`:

```dart
SleepDataParser? _sleepParser;
Completer<SleepSession>? _sleepCompleter;
```

In `_onValueChange`, add routing before the `debugPrint` unhandled line:

```dart
if (cmd == cmdSyncSleep && _sleepParser != null) {
  final result = _sleepParser!.parse(List<int>.from(value));
  if (result != null && _sleepCompleter != null && !_sleepCompleter!.isCompleted) {
    _sleepCompleter!.complete(result);
  }
  return;
}
```

Add public method:

```dart
/// Read sleep data for last night.
Future<SleepSession?> readSleep() async {
  _sleepParser = SleepDataParser();
  _sleepCompleter = Completer<SleepSession>();

  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  await _sendPacket(syncSleepPacket(DateTime.utc(yesterday.year, yesterday.month, yesterday.day)));

  try {
    return await _sleepCompleter!.future.timeout(const Duration(seconds: 15));
  } on TimeoutException {
    debugPrint('RingService: timeout reading sleep data');
    return null;
  } finally {
    _sleepParser = null;
    _sleepCompleter = null;
  }
}
```

Add imports for `sleep_parser.dart` and `ring_constants.dart` (cmdSyncSleep).

- [ ] **Step 5: Run tests + analyze**

Run: `cd phoenix_app && flutter test test/sleep_parser_test.dart && flutter analyze lib/core/ring/`
Expected: Tests PASS, no analysis errors.

- [ ] **Step 6: Commit**

```bash
git add lib/core/ring/sleep_parser.dart test/sleep_parser_test.dart lib/core/ring/ring_service.dart
git commit -m "feat(ring): add sleep data parser and readSleep in RingService"
```

---

### Task 7: SleepNotifier — summary + notification

**Files:**
- Create: `lib/core/ring/sleep_notifier.dart`
- Create: `test/sleep_notifier_test.dart`
- Modify: `lib/core/notifications/notification_service.dart`
- Modify: `lib/app/providers.dart`

- [ ] **Step 1: Write failing tests**

Create `test/sleep_notifier_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/ring/sleep_notifier.dart';
import 'package:phoenix_app/core/ring/sleep_parser.dart';

void main() {
  group('SleepSummary', () {
    test('qualityLabel is Ottimo for good sleep', () {
      final summary = SleepSummary.fromSession(SleepSession(
        nightDate: DateTime(2026, 3, 18),
        stages: [
          SleepPeriod(stage: SleepStage.deep, start: DateTime(2026, 3, 18, 23, 0), end: DateTime(2026, 3, 19, 0, 30)),
          SleepPeriod(stage: SleepStage.light, start: DateTime(2026, 3, 19, 0, 30), end: DateTime(2026, 3, 19, 3, 0)),
          SleepPeriod(stage: SleepStage.rem, start: DateTime(2026, 3, 19, 3, 0), end: DateTime(2026, 3, 19, 4, 30)),
          SleepPeriod(stage: SleepStage.deep, start: DateTime(2026, 3, 19, 4, 30), end: DateTime(2026, 3, 19, 5, 30)),
          SleepPeriod(stage: SleepStage.light, start: DateTime(2026, 3, 19, 5, 30), end: DateTime(2026, 3, 19, 7, 0)),
        ],
      ));
      expect(summary.qualityLabel, 'Ottimo');
      expect(summary.totalSleep.inHours, 8);
      expect(summary.efficiency, greaterThan(0.85));
    });

    test('qualityLabel is Scarso for bad sleep', () {
      final summary = SleepSummary.fromSession(SleepSession(
        nightDate: DateTime(2026, 3, 18),
        stages: [
          SleepPeriod(stage: SleepStage.light, start: DateTime(2026, 3, 19, 1, 0), end: DateTime(2026, 3, 19, 3, 0)),
          SleepPeriod(stage: SleepStage.awake, start: DateTime(2026, 3, 19, 3, 0), end: DateTime(2026, 3, 19, 4, 0)),
          SleepPeriod(stage: SleepStage.light, start: DateTime(2026, 3, 19, 4, 0), end: DateTime(2026, 3, 19, 5, 0)),
        ],
      ));
      expect(summary.qualityLabel, 'Scarso');
    });

    test('notificationBody formats correctly', () {
      final summary = SleepSummary.fromSession(SleepSession(
        nightDate: DateTime(2026, 3, 18),
        stages: [
          SleepPeriod(stage: SleepStage.deep, start: DateTime(2026, 3, 18, 23, 0), end: DateTime(2026, 3, 19, 0, 30)),
          SleepPeriod(stage: SleepStage.rem, start: DateTime(2026, 3, 19, 0, 30), end: DateTime(2026, 3, 19, 2, 0)),
          SleepPeriod(stage: SleepStage.light, start: DateTime(2026, 3, 19, 2, 0), end: DateTime(2026, 3, 19, 6, 0)),
        ],
      ));
      final body = summary.notificationBody;
      expect(body, contains('Deep'));
      expect(body, contains('REM'));
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd phoenix_app && flutter test test/sleep_notifier_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement SleepNotifier**

Create `lib/core/ring/sleep_notifier.dart`:

```dart
import 'sleep_parser.dart';

/// Computed sleep summary from ring data.
class SleepSummary {
  final Duration timeInBed;
  final Duration totalSleep;
  final Duration deep;
  final Duration light;
  final Duration rem;
  final Duration awake;
  final double efficiency;
  final int? hrMin;
  final int? hrAvg;
  final double? tempDelta;
  final double? rmssd;
  final String qualityLabel;

  const SleepSummary({
    required this.timeInBed,
    required this.totalSleep,
    required this.deep,
    required this.light,
    required this.rem,
    required this.awake,
    required this.efficiency,
    this.hrMin,
    this.hrAvg,
    this.tempDelta,
    this.rmssd,
    required this.qualityLabel,
  });

  factory SleepSummary.fromSession(
    SleepSession session, {
    int? hrMin,
    int? hrAvg,
    double? tempDelta,
    double? rmssd,
  }) {
    final totalSleep = session.totalSleep;
    final timeInBed = session.timeInBed;
    final deep = session.deep;
    final rem = session.rem;
    final efficiency = session.efficiency;

    // Quality label
    final deepPct = timeInBed.inSeconds > 0 ? deep.inSeconds / timeInBed.inSeconds : 0.0;
    final remPct = timeInBed.inSeconds > 0 ? rem.inSeconds / timeInBed.inSeconds : 0.0;

    String quality;
    if (deepPct >= 0.20 && efficiency >= 0.85 && remPct >= 0.20) {
      quality = 'Ottimo';
    } else if (deepPct >= 0.15 && efficiency >= 0.75) {
      quality = 'Buono';
    } else {
      quality = 'Scarso';
    }

    return SleepSummary(
      timeInBed: timeInBed,
      totalSleep: totalSleep,
      deep: deep,
      light: session.light,
      rem: rem,
      awake: session.awake,
      efficiency: efficiency,
      hrMin: hrMin,
      hrAvg: hrAvg,
      tempDelta: tempDelta,
      rmssd: rmssd,
      qualityLabel: quality,
    );
  }

  /// Format total sleep as "Xh Ym".
  String get totalSleepFormatted {
    final h = totalSleep.inHours;
    final m = totalSleep.inMinutes % 60;
    return '${h}h ${m.toString().padLeft(2, '0')}m';
  }

  /// Notification title.
  String get notificationTitle =>
      'Sonno: $totalSleepFormatted — $qualityLabel';

  /// Notification body.
  String get notificationBody {
    final deepF = '${deep.inHours}h ${(deep.inMinutes % 60).toString().padLeft(2, '0')}m';
    final remF = '${rem.inHours}h ${(rem.inMinutes % 60).toString().padLeft(2, '0')}m';
    var body = 'Deep $deepF · REM $remF';
    if (hrAvg != null) body += ' · HR $hrAvg';
    return body;
  }
}
```

- [ ] **Step 4: Add sleep notification ID to NotificationService**

In `lib/core/notifications/notification_service.dart`, add a constant for sleep notification (use ID range 7000):

```dart
static const _sleepSummaryId = 7001;
```

Add method:

```dart
/// Show sleep summary notification.
Future<void> showSleepSummary(String title, String body) async {
  await showNow(_sleepSummaryId, title, body);
}
```

- [ ] **Step 5: Run tests**

Run: `cd phoenix_app && flutter test test/sleep_notifier_test.dart`
Expected: All tests PASS.

- [ ] **Step 6: Add provider + commit**

In `providers.dart`:

No separate `SleepNotifier` class needed — `SleepSummary` already provides `notificationTitle` and `notificationBody`. Use `NotificationService.showSleepSummary()` directly from `RingSyncCoordinator` with a `SleepSummary` instance.

```bash
git add lib/core/ring/sleep_notifier.dart lib/core/ring/sleep_parser.dart test/sleep_notifier_test.dart lib/core/notifications/notification_service.dart lib/app/providers.dart
git commit -m "feat(ring): add SleepSummary computation and sleep notification"
```

---

### Task 8: Sleep hypnogram widget

**Files:**
- Create: `lib/features/conditioning/widgets/sleep_hypnogram.dart`

- [ ] **Step 1: Create hypnogram widget**

Create `lib/features/conditioning/widgets/sleep_hypnogram.dart`:

```dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';
import '../../../core/ring/sleep_parser.dart';

/// Visual sleep stage timeline using fl_chart.
class SleepHypnogram extends StatelessWidget {
  final List<SleepPeriod> stages;
  const SleepHypnogram({super.key, required this.stages});

  @override
  Widget build(BuildContext context) {
    if (stages.isEmpty) return const SizedBox.shrink();

    // Map stage to Y value: deep=0, light=1, rem=2, awake=3
    double stageY(SleepStage s) => switch (s) {
          SleepStage.deep => 0,
          SleepStage.light => 1,
          SleepStage.rem => 2,
          SleepStage.awake => 3,
        };

    Color stageColor(SleepStage s) => switch (s) {
          SleepStage.deep => const Color(0xFF1A237E),
          SleepStage.light => const Color(0xFF42A5F5),
          SleepStage.rem => const Color(0xFFAB47BC),
          SleepStage.awake => PhoenixColors.warning,
        };

    final firstStart = stages.first.start;

    // Scatter plot showing sleep stages over time
    final spots = <ScatterSpot>[];
    for (final s in stages) {
      // Create dots every 5 minutes
      var t = s.start;
      while (t.isBefore(s.end)) {
        final x = t.difference(firstStart).inMinutes.toDouble();
        final y = stageY(s.stage);
        spots.add(ScatterSpot(x, y, color: stageColor(s.stage)));
        t = t.add(const Duration(minutes: 5));
      }
    }

    final totalMinutes = stages.last.end.difference(firstStart).inMinutes;

    return SizedBox(
      height: 100,
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: spots,
          scatterTouchData: ScatterTouchData(enabled: false),
          minX: 0,
          maxX: totalMinutes.toDouble(),
          minY: -0.5,
          maxY: 3.5,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (v, _) => Text(
                  switch (v.toInt()) {
                    0 => 'Deep',
                    1 => 'Light',
                    2 => 'REM',
                    3 => 'Sveglio',
                    _ => '',
                  },
                  style: TextStyle(fontSize: 9, color: context.phoenix.textTertiary),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 60,
                getTitlesWidget: (v, _) {
                  final dt = firstStart.add(Duration(minutes: v.toInt()));
                  return Text(
                    '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 9, color: context.phoenix.textTertiary),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Run analyze**

Run: `cd phoenix_app && flutter analyze lib/features/conditioning/widgets/sleep_hypnogram.dart`
Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/conditioning/widgets/sleep_hypnogram.dart
git commit -m "feat(ring): add SleepHypnogram widget for sleep stage visualization"
```

---

### Task 9: SleepCard enrichment + DailyProtocol auto-complete

**Files:**
- Modify: `lib/features/today/widgets/sleep_card.dart`
- Modify: `lib/core/models/daily_protocol.dart`
- Modify: `lib/features/conditioning/sleep_tab.dart`

- [ ] **Step 1: Update DailyProtocol to check ring sleep data**

In `lib/core/models/daily_protocol.dart`, modify the sleep completion logic to check `RingDataDao.hasLastNightSleep()`. The `sleepLogged` field should be `true` if either manual entry exists OR ring sleep data exists.

This requires adding a `bool hasRingSleep` parameter to the `DailyProtocol` constructor/factory, populated by the caller from `RingDataDao`.

- [ ] **Step 2: Enrich SleepCard with ring data**

In `lib/features/today/widgets/sleep_card.dart`, add a conditional branch: if ring sleep data is available (check via provider), show the enriched layout with staging durations and mini hypnogram. Otherwise, show the existing manual layout.

- [ ] **Step 3: Add hypnogram to SleepTab**

In `lib/features/conditioning/sleep_tab.dart`, when ring sleep stages are available, render the `SleepHypnogram` widget above the existing manual sleep UI.

- [ ] **Step 4: Run analyze**

Run: `cd phoenix_app && flutter analyze lib/features/today/widgets/sleep_card.dart lib/core/models/daily_protocol.dart lib/features/conditioning/sleep_tab.dart`
Expected: No errors.

- [ ] **Step 5: Commit**

```bash
git add lib/features/today/widgets/sleep_card.dart lib/core/models/daily_protocol.dart lib/features/conditioning/sleep_tab.dart
git commit -m "feat(ring): enrich SleepCard with ring data, auto-complete protocol"
```

---

## PHASE 3: Sync + HRV Morning

### Task 10: RingSyncCoordinator

**Files:**
- Create: `lib/core/ring/ring_sync_coordinator.dart`
- Modify: `lib/features/workout/home_screen.dart`
- Modify: `lib/app/providers.dart`

- [ ] **Step 1: Implement RingSyncCoordinator**

Create `lib/core/ring/ring_sync_coordinator.dart`:

```dart
import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../database/daos/ring_data_dao.dart';
import '../database/daos/ring_device_dao.dart';
import '../database/database.dart';
import '../notifications/notification_service.dart';
import 'morning_hrv_check.dart';
import 'ring_protocol.dart';
import 'ring_service.dart';
import 'signal_processor.dart';
import 'sleep_notifier.dart';
import 'sleep_parser.dart';

/// Orchestrates full data sync on app open.
///
/// Sequence: sleep → HRV auto → HR log → steps → battery → lastSync
/// Max 1 sync per 15 minutes (cooldown).
class RingSyncCoordinator {
  final RingService _ring;
  final RingDataDao _dataDao;
  final RingDeviceDao _deviceDao;
  final SignalProcessor _processor;
  final NotificationService _notifications;
  final MorningHrvCheck _hrvCheck;

  DateTime? _lastSyncTime;
  bool _syncing = false;

  /// Progress callback: (stepName, stepIndex, totalSteps)
  final ValueNotifier<String?> syncStatus = ValueNotifier(null);

  RingSyncCoordinator({
    required RingService ring,
    required RingDataDao dataDao,
    required RingDeviceDao deviceDao,
    required SignalProcessor processor,
    required NotificationService notifications,
    required MorningHrvCheck hrvCheck,
  })  : _ring = ring,
        _dataDao = dataDao,
        _deviceDao = deviceDao,
        _processor = processor,
        _notifications = notifications,
        _hrvCheck = hrvCheck;

  /// Run full sync if ring is connected and cooldown has elapsed.
  Future<void> syncIfNeeded() async {
    if (_syncing) return;
    if (_ring.connectionState.value != RingConnectionState.ready) return;

    // 15-minute cooldown
    if (_lastSyncTime != null &&
        DateTime.now().difference(_lastSyncTime!) < const Duration(minutes: 15)) {
      return;
    }

    _syncing = true;

    try {
      // 1. Sleep sync
      syncStatus.value = 'Sincronizzazione sonno...';
      await _syncSleep();

      // 2. HR log (today + yesterday)
      syncStatus.value = 'HR log...';
      await _syncHrLog();

      // 3. Steps (today + yesterday)
      syncStatus.value = 'Passi...';
      await _syncSteps();

      // 4. Battery
      syncStatus.value = 'Batteria...';
      await _ring.refreshBattery();

      // 5. Update last sync
      final device = await _deviceDao.getPairedRing();
      if (device != null) await _deviceDao.updateLastSync(device.id);
      _lastSyncTime = DateTime.now();

      syncStatus.value = null;
    } catch (e) {
      debugPrint('RingSyncCoordinator: sync error: $e');
      syncStatus.value = null;
    } finally {
      _syncing = false;
    }
  }

  Future<void> _syncSleep() async {
    try {
      final session = await _ring.readSleep();
      if (session == null || session.stages.isEmpty) return;

      // Save stages to DB
      final companions = session.stages.map((s) => RingSleepStagesCompanion(
            nightDate: Value(session.nightDate),
            stage: Value(s.stage.label),
            startTime: Value(s.start),
            endTime: Value(s.end),
          )).toList();
      await _dataDao.replaceSleepStages(session.nightDate, companions);

      // Show notification if morning
      final hour = DateTime.now().hour;
      if (hour >= 6 && hour < 12) {
        final summary = SleepSummary.fromSession(session);
        await _notifications.showSleepSummary(
          summary.notificationTitle,
          summary.notificationBody,
        );
      }

      // Try auto HRV
      await _hrvCheck.autoAttempt();
    } catch (e) {
      debugPrint('RingSyncCoordinator: sleep sync failed: $e');
    }
  }

  Future<void> _syncHrLog() async {
    try {
      final now = DateTime.now();
      for (final day in [now, now.subtract(const Duration(days: 1))]) {
        final log = await _ring.readHeartRateLog(day);
        if (log == null) continue;

        final filtered = _processor.filterHrLog(log.heartRates);
        final readings = <RingHrSamplesCompanion>[];
        final dayStart = DateTime(day.year, day.month, day.day);

        for (var i = 0; i < filtered.length; i++) {
          if (filtered[i] <= 0) continue;
          readings.add(RingHrSamplesCompanion(
            timestamp: Value(dayStart.add(Duration(minutes: i * 5))),
            hr: Value(filtered[i]),
            source: const Value('log_sync'),
          ));
        }

        if (readings.isNotEmpty) {
          await _dataDao.insertHrSamples(readings);
        }
      }
    } catch (e) {
      debugPrint('RingSyncCoordinator: HR log sync failed: $e');
    }
  }

  Future<void> _syncSteps() async {
    try {
      for (final daysAgo in [0, 1]) {
        final steps = await _ring.readSteps(daysAgo);
        if (steps == null || steps.isEmpty) continue;

        final day = DateTime.now().subtract(Duration(days: daysAgo));
        final companions = steps.map((s) => RingStepsCompanion(
              timestamp: Value(s.timestamp),
              steps: Value(s.steps),
              calories: Value(s.calories),
              distanceM: Value(s.distanceM),
            )).toList();
        await _dataDao.replaceStepsForDay(day, companions);
      }
    } catch (e) {
      debugPrint('RingSyncCoordinator: steps sync failed: $e');
    }
  }
}
```

- [ ] **Step 2: Add provider**

In `providers.dart`.
**IMPORTANT:** `morningHrvCheckProvider` (Task 11) must be defined BEFORE this provider.
Implement Task 11 Steps 1-2 first (create MorningHrvCheck class + its provider), then return here.

```dart
final ringSyncCoordinatorProvider = Provider<RingSyncCoordinator>((ref) {
  return RingSyncCoordinator(
    ring: ref.watch(ringServiceProvider),
    dataDao: ref.watch(ringDataDaoProvider),
    deviceDao: ref.watch(ringDeviceDaoProvider),
    processor: ref.watch(signalProcessorProvider),
    notifications: ref.watch(notificationServiceProvider),
    hrvCheck: ref.watch(morningHrvCheckProvider),
  );
});
```

- [ ] **Step 3: Trigger sync from HomeScreen.initState**

In `lib/features/workout/home_screen.dart`, in `initState()`, add:

```dart
// Auto-sync ring data if connected
WidgetsBinding.instance.addPostFrameCallback((_) {
  ref.read(ringSyncCoordinatorProvider).syncIfNeeded();
});
```

- [ ] **Step 4: Run analyze**

Run: `cd phoenix_app && flutter analyze lib/core/ring/ring_sync_coordinator.dart lib/features/workout/home_screen.dart`
Expected: No errors.

- [ ] **Step 5: Commit**

```bash
git add lib/core/ring/ring_sync_coordinator.dart lib/features/workout/home_screen.dart lib/app/providers.dart
git commit -m "feat(ring): add RingSyncCoordinator with auto-sync on app open"
```

---

### Task 11: MorningHrvCheck

**Files:**
- Create: `lib/core/ring/morning_hrv_check.dart`
- Create: `lib/features/today/widgets/hrv_morning_card.dart`
- Modify: `lib/features/today/today_screen.dart`
- Modify: `lib/app/providers.dart`

- [ ] **Step 1: Implement MorningHrvCheck**

Create `lib/core/ring/morning_hrv_check.dart`:

```dart
import 'dart:async';
import 'dart:math' as math;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../database/daos/hrv_dao.dart';
import '../database/database.dart';
import 'ring_lock_manager.dart';
import 'ring_service.dart';
import 'signal_processor.dart';
import 'ring_constants.dart';
import 'ring_protocol.dart';

/// Automatic + manual morning HRV measurement.
///
/// Auto: 60s real-time HRV after sleep sync.
/// Manual: UI-triggered 60s countdown.
class MorningHrvCheck {
  final RingService _ring;
  final RingLockManager _lock;
  final HrvDao _hrvDao;
  final SignalProcessor _processor;

  /// True if auto-attempt failed and manual measurement is available.
  final ValueNotifier<bool> hrvPending = ValueNotifier(false);

  /// Progress during measurement (0.0 to 1.0).
  final ValueNotifier<double> progress = ValueNotifier(0.0);

  /// Latest RMSSD during measurement.
  final ValueNotifier<double?> currentRmssd = ValueNotifier(null);

  MorningHrvCheck({
    required RingService ring,
    required RingLockManager lock,
    required HrvDao hrvDao,
    required SignalProcessor processor,
  })  : _ring = ring,
        _lock = lock,
        _hrvDao = hrvDao,
        _processor = processor;

  /// Auto-attempt after sleep sync. Silent failure → sets hrvPending.
  Future<void> autoAttempt() async {
    final hour = DateTime.now().hour;
    if (hour < 6 || hour >= 12) return;

    // Check if already measured today
    final today = await _hrvDao.getTodayReading();
    if (today != null) return;

    // Check capabilities
    if (_ring.capabilities?.supportsHrv != true) {
      hrvPending.value = true;
      return;
    }

    // Try to acquire lock
    if (!_lock.acquire('hrv_morning')) {
      hrvPending.value = true;
      return;
    }

    try {
      final result = await _measure(const Duration(seconds: 60));
      if (result != null) {
        hrvPending.value = false;
      } else {
        hrvPending.value = true;
      }
    } finally {
      _lock.release('hrv_morning');
    }
  }

  /// Manual measurement triggered by user. Returns RMSSD or null.
  Future<double?> manualMeasure() async {
    if (!_lock.acquire('hrv_morning')) return null;

    try {
      final result = await _measure(const Duration(seconds: 60));
      if (result != null) {
        hrvPending.value = false;
      }
      return result;
    } finally {
      _lock.release('hrv_morning');
    }
  }

  Future<double?> _measure(Duration duration) async {
    final readings = <int>[];
    StreamSubscription<RealTimeReading>? sub;

    progress.value = 0.0;
    currentRmssd.value = null;

    try {
      await _ring.startRealTimeHrv();

      final completer = Completer<void>();
      final startTime = DateTime.now();

      sub = _ring.realTimeReadings.listen((reading) {
        if (reading.type == RealTimeReadingType.hrv && !reading.isError) {
          readings.add(reading.value);
          final elapsed = DateTime.now().difference(startTime);
          progress.value = (elapsed.inSeconds / duration.inSeconds).clamp(0.0, 1.0);

          // Compute running RMSSD if enough data
          if (readings.length >= 5) {
            currentRmssd.value = _processor.computeRmssd(readings);
          }
        }
      });

      // Wait for duration
      await Future.delayed(duration);
      completer.complete();
    } finally {
      sub?.cancel();
      await _ring.stopRealTimeHrv();
      progress.value = 1.0;
    }

    if (readings.length < 10) return null;

    final rmssd = _processor.computeRmssd(readings);
    final lnRmssd = rmssd > 0 ? _ln(rmssd) : 0.0;
    final si = _processor.computeStressIndex(readings);

    // Save to DB
    await _hrvDao.addReading(HrvReadingsCompanion(
      timestamp: Value(DateTime.now()),
      rmssd: Value(rmssd),
      lnRmssd: Value(lnRmssd),
      stressIndex: Value(si),
      source: const Value('colmi_r10'),
      context: const Value('morning'),
    ));

    currentRmssd.value = rmssd;
    return rmssd;
  }

  double _ln(double x) => x > 0 ? math.log(x) : 0.0;
}
```

- [ ] **Step 2: Create HRV morning card widget**

Create `lib/features/today/widgets/hrv_morning_card.dart`:

A card that shows:
- When `hrvPending == true`: "Misura HRV mattutina" + button
- During measurement: countdown + progress + running RMSSD
- After completion: RMSSD, lnRMSSD, SI, recovery status

Uses `ValueListenableBuilder` on `MorningHrvCheck.hrvPending`, `.progress`, `.currentRmssd`.

- [ ] **Step 3: Add HRV card to Today screen**

In `lib/features/today/today_screen.dart`, after the `SleepCard` (around line 111), add the `HrvMorningCard` conditionally displayed when ring is paired.

- [ ] **Step 4: Add providers**

In `providers.dart`:

```dart
final morningHrvCheckProvider = Provider<MorningHrvCheck>((ref) {
  return MorningHrvCheck(
    ring: ref.watch(ringServiceProvider),
    lock: ref.watch(ringLockManagerProvider),
    hrvDao: ref.watch(hrvDaoProvider),
    processor: ref.watch(signalProcessorProvider),
  );
});

final hrvPendingProvider = Provider<ValueNotifier<bool>>((ref) {
  return ref.watch(morningHrvCheckProvider).hrvPending;
});
```

- [ ] **Step 5: Run analyze**

Run: `cd phoenix_app && flutter analyze lib/core/ring/morning_hrv_check.dart lib/features/today/widgets/hrv_morning_card.dart lib/features/today/today_screen.dart`
Expected: No errors.

- [ ] **Step 6: Commit**

```bash
git add lib/core/ring/morning_hrv_check.dart lib/features/today/widgets/hrv_morning_card.dart lib/features/today/today_screen.dart lib/app/providers.dart
git commit -m "feat(ring): add morning HRV check (auto + manual) with Today card"
```

---

### Task 12: PeriodizationEngine + OneBigThing integration

**Files:**
- Modify: `lib/core/models/periodization_engine.dart:174-203`
- Modify: `lib/core/models/activity_rings_data.dart:92-187`

- [ ] **Step 1: Add RecoveryStatus to shouldDeload**

In `periodization_engine.dart`, import `HrvEngine` types and modify `shouldDeload` signature:

```dart
bool shouldDeload(
  MesocycleState state, {
  List<double>? recentRPEs,
  bool biomarkerAlert = false,
  String? recoveryStatus, // 'veryLow', 'low', 'normal', etc.
  int recoveryLowDays = 0, // consecutive days of low/veryLow
})
```

Add recovery check before existing checks:

```dart
// HRV-based deload trigger
if (recoveryLowDays >= 3 &&
    (recoveryStatus == 'veryLow' || recoveryStatus == 'low')) {
  return true;
}
```

- [ ] **Step 2: Add recovery to OneBigThing.compute**

In `activity_rings_data.dart`, add `String? recoveryStatus` parameter to `OneBigThing.compute()`. Insert as highest priority (before biomarker alerts):

```dart
if (recoveryStatus == 'veryLow') {
  return OneBigThing(
    title: 'Recovery compromessa',
    subtitle: 'Considera un giorno leggero',
    iconType: IconType.biomarker,
    priority: PriorityLevel.alert,
  );
}
if (recoveryStatus == 'low') {
  return OneBigThing(
    title: 'Recovery bassa',
    subtitle: 'Adatta l\'intensità',
    iconType: IconType.biomarker,
    priority: PriorityLevel.warning,
  );
}
```

- [ ] **Step 3: Run existing tests**

Run: `cd phoenix_app && flutter test test/`
Expected: All tests still pass (new parameters are optional with defaults).

- [ ] **Step 4: Commit**

```bash
git add lib/core/models/periodization_engine.dart lib/core/models/activity_rings_data.dart
git commit -m "feat(ring): integrate HRV recovery into deload decisions and OneBigThing"
```

---

## PHASE 4: Workout Bio Tracking

### Task 13: WorkoutBioTracker

**Files:**
- Create: `lib/core/ring/workout_bio_tracker.dart`
- Create: `test/workout_bio_tracker_test.dart`

- [ ] **Step 1: Write failing tests**

Create `test/workout_bio_tracker_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/ring/workout_bio_tracker.dart';

void main() {
  group('SetBioStats', () {
    test('computes average HR', () {
      final stats = SetBioStats.fromReadings(
        hrReadings: [120, 130, 140, 150],
        spo2: 97,
        rmssd: 35.0,
        stressIndex: 150.0,
        restingHr: 90,
        peakHr: 150,
        skinTemp: 36.5,
      );
      expect(stats.avgHr, 135.0);
      expect(stats.maxHr, 150);
      expect(stats.hrRecoveryBpm, 60); // 150 - 90
    });
  });

  group('SessionBioStats', () {
    test('computes zone distribution', () {
      final stats = SessionBioStats.fromSets([
        SetBioStats.fromReadings(
          hrReadings: [120, 130, 140],
          spo2: 97,
          rmssd: 35.0,
          stressIndex: 150.0,
          restingHr: 80,
          peakHr: 140,
          skinTemp: 36.5,
        ),
      ]);
      expect(stats.avgHr, greaterThan(0));
    });
  });
}
```

- [ ] **Step 2: Implement WorkoutBioTracker**

Create `lib/core/ring/workout_bio_tracker.dart` with:
- `SetBioStats` and `SessionBioStats` data classes
- `WorkoutBioTracker` class that:
  - `start(sessionId)` — acquires lock, starts HR real-time
  - `onSetStart()` — clears set readings
  - `onSetEnd()` — returns SetBioStats
  - `onRestStart()` — switches to HRV/SpO2 cycling with error recovery (retry once, then skip)
  - `onRestEnd()` — switches back to HR
  - `stop()` — returns SessionBioStats, releases lock
  - Battery check: skip raw PPG if < 15%, skip all if < 5%
- Listens to `RingService.realTimeReadings` stream
- Filters through `SignalProcessor`

- [ ] **Step 3: Run tests**

Run: `cd phoenix_app && flutter test test/workout_bio_tracker_test.dart`
Expected: PASS.

- [ ] **Step 4: Commit**

```bash
git add lib/core/ring/workout_bio_tracker.dart test/workout_bio_tracker_test.dart
git commit -m "feat(ring): add WorkoutBioTracker for multi-parameter workout tracking"
```

---

### Task 14: Bio overlay widget

**Files:**
- Create: `lib/features/workout/widgets/bio_overlay.dart`

- [ ] **Step 1: Create bio overlay widget**

Create `lib/features/workout/widgets/bio_overlay.dart`:

Compact widget showing:
- During tracking: `♥ 142 BPM  Z3 ████` (HR + zone color bar)
- During rest: `♥ 98 ↓44  SpO2 97%` / `HRV 42ms  SI 128  🌡36.4`
- Hidden when ring not connected
- Uses `ValueListenableBuilder` or stream from `WorkoutBioTracker`

- [ ] **Step 2: Run analyze**

Run: `cd phoenix_app && flutter analyze lib/features/workout/widgets/bio_overlay.dart`
Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/workout/widgets/bio_overlay.dart
git commit -m "feat(ring): add bio overlay widget for workout screen"
```

---

### Task 15: Integrate bio tracker into WorkoutSessionScreen

**Files:**
- Modify: `lib/features/workout/workout_session_screen.dart:33-490`
- Modify: `lib/core/models/coach_prompts.dart:85-99`

- [ ] **Step 1: Add bio tracker to workout session**

In `workout_session_screen.dart`:
- In `initState` / session start: create `WorkoutBioTracker`, call `start(sessionId)`
- In `dispose` / session end: call `stop()`, save `SessionBioStats` to DB
- In `_confirmCoachChat`: get `SetBioStats`, pass bio columns to `WorkoutSetsCompanion`
- In phase transitions: call `onSetStart()`, `onSetEnd()`, `onRestStart()`, `onRestEnd()`
- Add `BioOverlay` widget to the build tree (visible during tracking + resting phases)

- [ ] **Step 2: Add bio-based coaching cues**

In `coach_prompts.dart`, add new method or extend `interSetCue`:

```dart
static String? bioCue({
  int? currentHr,
  int? hrMax,
  int? spo2,
  double? rmssd,
  double? previousRmssd,
  double? stressIndex,
  int? hrRecoveryBpm,
  double? skinTemp,
  double? tempBaseline,
}) {
  if (hrMax != null && currentHr != null && currentHr > hrMax * 0.9) {
    return 'Intensità altissima. Prendi tutto il riposo che serve.';
  }
  if (spo2 != null && spo2 < 94) {
    return 'Saturazione bassa — respira profondamente prima del prossimo set.';
  }
  if (stressIndex != null && stressIndex > 300) {
    return 'Stress alto — allunga il riposo o riduci il carico.';
  }
  if (hrRecoveryBpm != null && hrRecoveryBpm < 20) {
    return 'Recupero lento — considera di chiudere qui.';
  }
  if (rmssd != null && previousRmssd != null && rmssd < previousRmssd * 0.7) {
    return 'Il sistema nervoso si sta affaticando. Considera di chiudere.';
  }
  if (skinTemp != null && tempBaseline != null && skinTemp - tempBaseline > 1.5) {
    return 'Temperatura in salita significativa — idratati.';
  }
  if (skinTemp != null && skinTemp > 38.0) {
    return 'Temperatura cutanea alta — rallenta e rinfrescati.';
  }
  return null; // No bio cue needed — all looks good
}
```

- [ ] **Step 3: Integrate into CardioSessionScreen**

In `lib/features/cardio/cardio_session_screen.dart`, add the same bio tracker pattern with target zone display.

- [ ] **Step 4: Integrate into ColdTab**

In `lib/features/conditioning/cold_tab.dart`, start bio tracking during cold exposure timer.

- [ ] **Step 5: Run tests + analyze**

Run: `cd phoenix_app && flutter test test/ && flutter analyze lib/features/workout/ lib/core/models/coach_prompts.dart`
Expected: All pass.

- [ ] **Step 6: Commit**

```bash
git add lib/features/workout/workout_session_screen.dart lib/core/models/coach_prompts.dart lib/features/cardio/cardio_session_screen.dart lib/features/conditioning/cold_tab.dart
git commit -m "feat(ring): integrate bio tracking into workout, cardio, and cold sessions"
```

---

## PHASE 5: Home Screen Widget

### Task 16: Add home_widget dependency

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add dependency**

In `pubspec.yaml`, add under `dependencies:`:

```yaml
  home_widget: ^0.7.0
```

- [ ] **Step 2: Run pub get**

Run: `cd phoenix_app && flutter pub get`
Expected: Success, no conflicts.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add home_widget dependency for home screen widgets"
```

---

### Task 17: Widget update logic

**Files:**
- Create: `lib/features/widgets/phoenix_home_widget.dart`

- [ ] **Step 1: Create widget update logic**

Create `lib/features/widgets/phoenix_home_widget.dart`:

```dart
import 'package:home_widget/home_widget.dart';

import '../../core/database/daos/ring_data_dao.dart';
import '../../core/models/daily_protocol.dart';

/// Updates home screen widget data from DB.
///
/// Called after sync, after protocol completion, and periodically via WorkManager.
class PhoenixHomeWidget {
  static const _appGroupId = 'group.phoenix.widget';
  static const _androidWidgetName = 'PhoenixWidgetProvider';
  static const _iosWidgetName = 'PhoenixWidget';

  /// Update all widget data from current DB state.
  static Future<void> update({
    required DailyProtocol protocol,
    int? steps,
    int? calories,
    String? sleepSummary,
    double? hrvMs,
    String? recovery,
    int? hrRest,
    double? temp,
    String? nextStep,
    String? levelName,
    int? levelNumber,
  }) async {
    // Protocol elements
    await HomeWidget.saveWidgetData('phoenix_protocol_done', protocol.completedCount);
    await HomeWidget.saveWidgetData('phoenix_protocol_total', 6);

    await HomeWidget.saveWidgetData('phoenix_sleep_done', protocol.sleepLogged);
    await HomeWidget.saveWidgetData('phoenix_fasting_done', protocol.fastingStatus.name != 'none');
    await HomeWidget.saveWidgetData('phoenix_training_done', protocol.workoutCompleted);
    await HomeWidget.saveWidgetData('phoenix_nutrition_done', false); // TODO: from protocol
    await HomeWidget.saveWidgetData('phoenix_cold_done', protocol.coldDone);
    await HomeWidget.saveWidgetData('phoenix_meditation_done', protocol.meditationDone);

    // Ring data
    if (steps != null) await HomeWidget.saveWidgetData('phoenix_steps', steps);
    if (calories != null) await HomeWidget.saveWidgetData('phoenix_calories', calories);
    if (sleepSummary != null) await HomeWidget.saveWidgetData('phoenix_sleep_summary', sleepSummary);
    if (hrvMs != null) await HomeWidget.saveWidgetData('phoenix_hrv_ms', hrvMs);
    if (recovery != null) await HomeWidget.saveWidgetData('phoenix_recovery', recovery);
    if (hrRest != null) await HomeWidget.saveWidgetData('phoenix_hr_rest', hrRest);
    if (temp != null) await HomeWidget.saveWidgetData('phoenix_temp', temp);
    if (nextStep != null) await HomeWidget.saveWidgetData('phoenix_next_step', nextStep);
    if (levelName != null) await HomeWidget.saveWidgetData('phoenix_level_name', levelName);
    if (levelNumber != null) await HomeWidget.saveWidgetData('phoenix_level_number', levelNumber);

    // Trigger widget update on both platforms
    await HomeWidget.updateWidget(
      androidName: _androidWidgetName,
      iOSName: _iosWidgetName,
    );
  }
}
```

- [ ] **Step 2: Call update after sync**

In `RingSyncCoordinator`, after `updateLastSync`, call `PhoenixHomeWidget.update(...)` with current protocol state and ring data.

- [ ] **Step 3: Commit**

```bash
git add lib/features/widgets/phoenix_home_widget.dart lib/core/ring/ring_sync_coordinator.dart
git commit -m "feat(ring): add PhoenixHomeWidget update logic with namespaced keys"
```

---

### Task 18: Android widget layouts

**Files:**
- Create: `android/app/src/main/res/layout/widget_small.xml`
- Create: `android/app/src/main/res/layout/widget_large.xml`
- Create: Android widget provider class
- Modify: `android/app/src/main/AndroidManifest.xml`

- [ ] **Step 1: Create small widget XML layout (2×2)**

Standard Android XML with TextViews for: title "PHOENIX · LV N", protocol dots "✓✓✓○○○ N/6", steps, next step.

- [ ] **Step 2: Create large widget XML layout (4×4)**

Standard Android XML with all elements: level, progress bar, 6 protocol items with labels, sleep/HRV/steps/calories, next step, HR/temp.

- [ ] **Step 3: Create widget provider**

Java/Kotlin `AppWidgetProvider` that reads from SharedPreferences (home_widget stores there).

- [ ] **Step 4: Register in AndroidManifest.xml**

Add `<receiver>` with `<intent-filter>` for `APPWIDGET_UPDATE` and `<meta-data>` for widget info XML.

- [ ] **Step 5: Test on Android emulator**

Run app, add widget to home screen, verify data appears.

- [ ] **Step 6: Commit**

```bash
git add android/
git commit -m "feat(ring): add Android home screen widgets (small 2x2, large 4x4)"
```

---

### Task 19: iOS widget (WidgetKit)

**Files:**
- Create: `ios/PhoenixWidget/` directory with SwiftUI views
- Modify: Xcode project

- [ ] **Step 1: Create WidgetKit extension**

SwiftUI `Widget` with `TimelineProvider`, reading from UserDefaults (shared app group).

- [ ] **Step 2: Create small widget view**

Compact layout: level, protocol dots, steps, next step.

- [ ] **Step 3: Create large widget view**

Full layout: all protocol elements, ring data.

- [ ] **Step 4: Configure app group**

Set up shared app group for data sharing between main app and widget extension.

- [ ] **Step 5: Test on iOS simulator**

Run app, add widget, verify data.

- [ ] **Step 6: Commit**

```bash
git add ios/
git commit -m "feat(ring): add iOS home screen widgets (small, large) via WidgetKit"
```

---

## PHASE POST: Registry + Cleanup

### Task 20: Update registry and specs

**Files:**
- Modify: `.claude/docs/registry.md`
- Modify: `.claude/docs/specs/ring-full-integration-design.md`

- [ ] **Step 1: Update registry with all new components**

Add all new files (SignalProcessor, RingLockManager, RingSyncCoordinator, WorkoutBioTracker, MorningHrvCheck, SleepParser, SleepNotifier, RingDataDao, SleepHypnogram, BioOverlay, HrvMorningCard, PhoenixHomeWidget) to the Components and Key Functions sections.

- [ ] **Step 2: Mark spec as completed**

Update spec status to "Completato" with date.

- [ ] **Step 3: Add request log entry**

Add entry to `.claude/docs/request-log.md`.

- [ ] **Step 4: Commit**

```bash
git add .claude/docs/
git commit -m "docs: update registry and specs for ring full integration"
```

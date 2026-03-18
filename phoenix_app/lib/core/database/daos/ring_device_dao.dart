import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'ring_device_dao.g.dart';

@DriftAccessor(tables: [RingDevices])
class RingDeviceDao extends DatabaseAccessor<PhoenixDatabase>
    with _$RingDeviceDaoMixin {
  RingDeviceDao(super.db);

  /// Get the paired ring (only one supported).
  Future<RingDevice?> getPairedRing() {
    return (select(ringDevices)..limit(1)).getSingleOrNull();
  }

  /// Watch the paired ring (reactive).
  Stream<RingDevice?> watchPairedRing() {
    return (select(ringDevices)..limit(1)).watchSingleOrNull();
  }

  /// Save or update the paired ring.
  Future<int> savePairedRing(RingDevicesCompanion entry) {
    return into(ringDevices).insertOnConflictUpdate(entry);
  }

  /// Update battery level for the paired ring.
  Future<void> updateBattery(int id, int level) {
    return (update(ringDevices)..where((r) => r.id.equals(id))).write(
      RingDevicesCompanion(batteryLevel: Value(level)),
    );
  }

  /// Update last sync time.
  Future<void> updateLastSync(int id) {
    return (update(ringDevices)..where((r) => r.id.equals(id))).write(
      RingDevicesCompanion(lastSync: Value(DateTime.now())),
    );
  }

  /// Update capabilities JSON.
  Future<void> updateCapabilities(int id, String capabilitiesJson) {
    return (update(ringDevices)..where((r) => r.id.equals(id))).write(
      RingDevicesCompanion(capabilitiesJson: Value(capabilitiesJson)),
    );
  }

  /// Remove the paired ring (unpair).
  Future<int> unpair() {
    return delete(ringDevices).go();
  }
}

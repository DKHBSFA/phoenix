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

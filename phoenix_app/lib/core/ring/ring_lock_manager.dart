/// Mutex for ring real-time BLE operations.
///
/// Only one consumer can hold the real-time stream at a time.
/// Acquire before starting real-time, release when done.
/// Lock auto-expires after [_timeout] to prevent deadlocks.
class RingLockManager {
  static const _timeout = Duration(minutes: 5);

  String? _owner;
  DateTime? _acquiredAt;

  /// Current lock owner, or null if unlocked.
  String? get currentOwner {
    _expireIfStale();
    return _owner;
  }

  /// Whether the lock is currently held.
  bool get isLocked {
    _expireIfStale();
    return _owner != null;
  }

  /// Try to acquire the lock. Returns true if acquired (or already owned).
  bool acquire(String owner) {
    _expireIfStale();
    if (_owner == null || _owner == owner) {
      _owner = owner;
      _acquiredAt = DateTime.now();
      return true;
    }
    return false;
  }

  /// Release the lock. Only the current owner can release.
  void release(String owner) {
    if (_owner == owner) {
      _owner = null;
      _acquiredAt = null;
    }
  }

  /// Force-release regardless of owner (for cleanup/error recovery).
  void forceRelease() {
    _owner = null;
    _acquiredAt = null;
  }

  /// Auto-expire lock if held longer than timeout.
  void _expireIfStale() {
    if (_owner != null &&
        _acquiredAt != null &&
        DateTime.now().difference(_acquiredAt!) > _timeout) {
      _owner = null;
      _acquiredAt = null;
    }
  }
}

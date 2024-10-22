class CircuitBreaker {
  final int failureThreshold;
  final Duration timeout;
  int _failureCount = 0;
  bool _open = false;
  DateTime _lastFailureTime = DateTime.now();

  CircuitBreaker({
    this.failureThreshold = 3,
    this.timeout = const Duration(seconds: 30),
  });

  bool get isOpen => _open;

  void recordSuccess() {
    _failureCount = 0;
    _open = false;
  }

  void recordFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();
    if (_failureCount >= failureThreshold) {
      _open = true;
    }
  }

  bool canProceed() {
    if (_open) {
      if (DateTime.now().difference(_lastFailureTime) > timeout) {
        _open = false;
      } else {
        return false;
      }
    }
    return true;
  }
}

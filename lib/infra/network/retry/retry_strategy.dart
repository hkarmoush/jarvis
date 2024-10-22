abstract class RetryStrategy {
  Future<T> execute<T>(Future<T> Function() action);
}

class SimpleRetryStrategy implements RetryStrategy {
  final int maxAttempts;
  final Duration delay;

  SimpleRetryStrategy({
    this.maxAttempts = 3,
    this.delay = const Duration(seconds: 1),
  });

  @override
  Future<T> execute<T>(Future<T> Function() action) async {
    int attempt = 0;
    while (attempt < maxAttempts) {
      try {
        return await action();
      } catch (e) {
        attempt++;
        if (attempt == maxAttempts) {
          rethrow;
        }
        await Future.delayed(delay);
      }
    }
    throw Exception('Max retries reached');
  }
}

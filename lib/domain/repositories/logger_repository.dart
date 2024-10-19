abstract class LoggerRepository {
  void logInfo(String message);
  void logError(String message, [Exception? error]);
  void logDebug(String message);
}

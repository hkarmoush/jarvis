import 'package:flutter/foundation.dart';
import 'package:jarvis/domain/repositories/logger_repository.dart';

class LoggerRepositoryImpl implements LoggerRepository {
  @override
  void logInfo(String message) {
    if (kDebugMode) {
      print('INFO: $message');
    }
  }

  @override
  void logError(String message, [Exception? error]) {
    if (kDebugMode) {
      print('ERROR: $message');
      if (error != null) {
        print('Exception: ${error.toString()}');
      }
    }
  }

  @override
  void logDebug(String message) {
    if (kDebugMode) {
      print('DEBUG: $message');
    }
  }
}

import 'package:logger/logger.dart';

class AppLoggerUtils {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      // noBoxingByDefault: true,
      // printTime: true,
      dateTimeFormat: (DateTime dateTime) {
        // Tùy chỉnh định dạng thời gian
        return '[${DateTime.now().toLocal().toString().split(' ')[1]}]';
      },
      // dateTimeFormat: DateTimeFormat.dateAndTime
    ),
    level: Level
        .debug, // Cấp độ log tối thiểu (có thể thay đổi trong môi trường production)
  );

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message);
  }

  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message);
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void trace(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }
}

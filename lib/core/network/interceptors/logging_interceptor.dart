import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Factory for creating logging interceptor
class LoggingInterceptor {
  /// Create a pretty logger interceptor for debugging
  static Interceptor create() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    );
  }
}

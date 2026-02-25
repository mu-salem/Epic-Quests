import 'dart:developer' as developer;
import 'package:dio/dio.dart';

/// Universal App Interceptor for Epic Quests
/// Handles global logging, metrics, and network error tracking
class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['requestStartTime'] = DateTime.now().millisecondsSinceEpoch;

    // You can add global headers like App Version, Platform, etc. here
    options.headers['X-App-Platform'] = 'Flutter';

    developer.log(
      '--> ${options.method.toUpperCase()} ${options.uri}',
      name: 'AppInterceptor',
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['requestStartTime'] as int?;
    final endTime = DateTime.now().millisecondsSinceEpoch;
    final duration = startTime != null ? endTime - startTime : -1;

    developer.log(
      '<-- ${response.statusCode} ${response.requestOptions.uri} (${duration}ms)',
      name: 'AppInterceptor',
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['requestStartTime'] as int?;
    final endTime = DateTime.now().millisecondsSinceEpoch;
    final duration = startTime != null ? endTime - startTime : -1;

    developer.log(
      '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri} (${duration}ms)\n'
      'Message: ${err.message}\n'
      'Error: ${err.error}',
      name: 'AppInterceptor',
      error: err,
    );

    // Here we can also report to Crashlytics / Sentry

    handler.next(err);
  }
}

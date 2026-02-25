import 'package:dio/dio.dart';

import 'error_handling/error_handler.dart';
import 'interceptors/app_interceptor.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Centralized API client using Dio
class ApiClient {
  late final Dio _dio;

  static const String baseUrl = 'https://epic-quests-backend.onrender.com';

  // Timeouts
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);

  // Callback for session expiration (navigate to login)
  static Function()? onSessionExpired;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  /// Setup interceptors for logging and auth
  void _setupInterceptors() {
    // Add app interceptor for global analytics & enhanced logging
    _dio.interceptors.add(AppInterceptor());

    // Add auth token interceptor with refresh logic
    _dio.interceptors.add(
      AuthInterceptor(
        dio: _dio,
        baseUrl: baseUrl,
        onSessionExpired: onSessionExpired,
      ),
    );

    // Add logging interceptor (only in debug mode)
    _dio.interceptors.add(LoggingInterceptor.create());
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}

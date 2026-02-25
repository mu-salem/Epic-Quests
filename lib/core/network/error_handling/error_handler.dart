import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Handles API errors and converts them to readable messages
class ErrorHandler {
  /// Handle Dio errors and convert to readable messages
  static ApiException handleDioError(DioException error) {
    String message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Check your internet connection.';
        break;

      case DioExceptionType.badResponse:
        message = _handleBadResponse(error.response);
        break;

      case DioExceptionType.cancel:
        message = 'Request cancelled.';
        break;

      case DioExceptionType.connectionError:
        message = 'No internet connection. Please try again.';
        break;

      case DioExceptionType.badCertificate:
        message = 'Security certificate error.';
        break;

      case DioExceptionType.unknown:
        message = 'Something went wrong. Please try again.';
        break;
    }

    return ApiException(message, error.response?.statusCode);
  }

  /// Handle bad response with detailed error message
  static String _handleBadResponse(Response? response) {
    if (response?.data != null && response?.data is Map) {
      final data = response!.data as Map<String, dynamic>;

      // Check for backend error message
      if (data.containsKey('message')) {
        return data['message'] as String;
      }

      // Check for validation errors
      if (data.containsKey('errors') && data['errors'] is List) {
        final errors = data['errors'] as List;
        if (errors.isNotEmpty) {
          return errors.first.toString();
        }
      }
    }

    return _handleStatusCode(response?.statusCode);
  }

  /// Handle HTTP status codes
  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Server error. Please try again later.';
      case 503:
        return 'Service unavailable. Try again later.';
      default:
        return 'Request failed with status: $statusCode';
    }
  }
}

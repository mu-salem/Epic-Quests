import 'package:dio/dio.dart';

import '../token_manager.dart';

/// Handles authentication token injection and refresh logic
class AuthInterceptor extends Interceptor {
  final Dio dio;
  final String baseUrl;

  // Refresh token lock to prevent concurrent refresh attempts
  bool _isRefreshing = false;

  // Callback for session expiration
  final Function()? onSessionExpired;

  AuthInterceptor({
    required this.dio,
    required this.baseUrl,
    this.onSessionExpired,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding token for public endpoints
    if (_isPublicEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    // Add auth token to requests if available
    final token = await TokenManager.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  /// Check if the endpoint is public (doesn't require authentication)
  bool _isPublicEndpoint(String path) {
    final publicEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/verify-email',
      '/auth/refresh',
      '/auth/forgot-password',
      '/auth/verify-reset-code',
      '/auth/reset-password',
    ];

    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - token expired or invalid
    if (err.response?.statusCode == 401) {
      // Check if we're already refreshing
      if (_isRefreshing) {
        // Wait for the ongoing refresh to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Retry the original request after refresh
        try {
          final options = err.requestOptions;
          final token = await TokenManager.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            final response = await dio.fetch(options);
            return handler.resolve(response);
          }
        } catch (e) {
          return handler.next(err);
        }
      }

      // Try to refresh the token
      _isRefreshing = true;
      final refreshSuccess = await _refreshToken();
      _isRefreshing = false;

      if (refreshSuccess) {
        // Retry the original request with new token
        try {
          final options = err.requestOptions;
          final newToken = await TokenManager.getAccessToken();
          if (newToken != null) {
            options.headers['Authorization'] = 'Bearer $newToken';
            final response = await dio.fetch(options);
            return handler.resolve(response);
          }
        } catch (e) {
          return handler.next(err);
        }
      } else {
        // Refresh failed - logout
        await TokenManager.clearAuthData();

        // Navigate to login screen
        onSessionExpired?.call();
      }
    }
    handler.next(err);
  }

  /// Refresh the access token using refresh token
  Future<bool> _refreshToken() async {
    try {
      // Get refresh token from secure storage
      final refreshToken = await TokenManager.getRefreshToken();

      if (refreshToken == null) {
        return false; // No refresh token available
      }

      // Call refresh endpoint
      final response = await dio.post(
        '$baseUrl/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['tokens'] != null) {
          // Save new tokens
          final newAccessToken = data['tokens']['access_token'] as String?;
          final newRefreshToken =
              data['tokens']['refresh_token'] as String?; // Token rotation!

          if (newAccessToken != null) {
            await TokenManager.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );

            return true; // Refresh successful
          }
        }
      }

      return false;
    } catch (e) {
      // Refresh failed
      return false;
    }
  }
}

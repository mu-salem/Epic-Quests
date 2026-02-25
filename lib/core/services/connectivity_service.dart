import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Service to monitor internet connectivity status
class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool _isOnline = true;
  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  /// Initialize connectivity monitoring
  Future<void> init() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _isOnline = _isConnected(result);

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final wasOnline = _isOnline;
      _isOnline = _isConnected(results);

      // Notify listeners only if status changed
      if (wasOnline != _isOnline) {
        debugPrint(
          '📡 Connectivity changed: ${_isOnline ? "ONLINE" : "OFFLINE"}',
        );
        notifyListeners();
      }
    });
  }

  /// Check if connected based on connectivity results
  bool _isConnected(List<ConnectivityResult> results) {
    // If any result is not 'none', we consider it connected
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// Dispose subscription
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  /// Wait for connection (for retry logic)
  Future<void> waitForConnection({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (_isOnline) return;

    final completer = Completer<void>();

    void listener() {
      if (_isOnline) {
        completer.complete();
        removeListener(listener);
      }
    }

    addListener(listener);

    // Add timeout
    return completer.future.timeout(
      timeout,
      onTimeout: () {
        removeListener(listener);
        throw TimeoutException('Connection timeout');
      },
    );
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}

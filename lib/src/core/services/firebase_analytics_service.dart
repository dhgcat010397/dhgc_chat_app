import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsService {
  Future<void> initialize();
  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]);
  Future<void> setUserProperty({required String name, required String value});
  Future<void> setUserId(String? userId);
  Future<void> reset();
}

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _firebaseAnalytics;

  FirebaseAnalyticsService(this._firebaseAnalytics);

  @override
  Future<void> initialize() async {
    // No specific initialization needed for Firebase
    return Future.value();
  }

  @override
  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) {
    return _firebaseAnalytics.logEvent(
      name: name,
      parameters: parameters?.cast<String, Object>(),
    );
  }

  @override
  Future<void> setUserProperty({required String name, required String value}) {
    return _firebaseAnalytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> setUserId(String? userId) {
    return _firebaseAnalytics.setUserId(id: userId);
  }

  @override
  Future<void> reset() {
    return _firebaseAnalytics.resetAnalyticsData();
  }
}

class MultiAnalyticsService implements AnalyticsService {
  final List<AnalyticsService> _services;

  MultiAnalyticsService(this._services);

  @override
  Future<void> initialize() async {
    for (final service in _services) {
      await service.initialize();
    }
  }

  @override
  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) async {
    for (final service in _services) {
      await service.logEvent(name, parameters);
    }
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    for (final service in _services) {
      await service.setUserProperty(name: name, value: value);
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    for (final service in _services) {
      await service.setUserId(userId);
    }
  }

  @override
  Future<void> reset() async {
    for (final service in _services) {
      await service.reset();
    }
  }
}

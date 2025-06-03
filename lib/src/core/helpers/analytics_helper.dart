// import 'package:firebase_auth/firebase_auth.dart';
import 'package:dhgc_chat_app/src/core/services/firebase_analytics_service.dart';
// import 'package:dhgc_chat_app/src/features/auth/domain/entities/user_entity.dart';

class AnalyticsHelper {
  final AnalyticsService _analytics;

  AnalyticsHelper(this._analytics);

  // User properties
  // Future<void> setUserProperties(UserEntity user) async {
  //   await Future.wait([
  //     _analytics.setUserId(user.uid),
  //     _analytics.setUserProperty(name: 'tier', value: user.tier),
  //     _analytics.setUserProperty(
  //       name: 'signup_date',
  //       value: user.signupDate.toIso8601String(),
  //     ),
  //     if (user.email != null)
  //       _analytics.setUserProperty(name: 'email', value: user.email!),
  //   ]);
  // }

  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) async {
    await _analytics.logEvent(name, parameters);
  }

  void logScreenView(String screenName) {
    _analytics.logEvent('screen_view', {'screen_name': screenName});
  }

  Future<void> logButtonTap(String buttonName) async {
    await _analytics.logEvent('button_tap', {'button_name': buttonName});
  }

  Future<void> logLogin(String method) async {
    await _analytics.logEvent('login', {'method': method});
  }

  Future<void> logSignUp(String method) async {
    await _analytics.logEvent('sign_up', {'method': method});
  }

  // Error tracking
  Future<void> logError(String error, StackTrace stackTrace) async {
    await _analytics.logEvent('app_error', {
      'error': error,
      'stack_trace': stackTrace.toString(),
    });
  }

  // Feature-specific tracking
  Future<void> logSearch(String query) async {
    await _analytics.logEvent('search', {
      'query': query,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Timing metrics
  Future<void> startTimer(String eventName) async {
    _timers[eventName] = DateTime.now();
  }

  Future<void> endTimer(String eventName) async {
    final startTime = _timers[eventName];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      await _analytics.logEvent('${eventName}_duration', {
        'duration_ms': duration.inMilliseconds,
      });
      _timers.remove(eventName);
    }
  }

  final Map<String, DateTime> _timers = {};

  // Reset analytics data (for logout)
  Future<void> reset() async {
    await _analytics.reset();
    _timers.clear();
  }
}

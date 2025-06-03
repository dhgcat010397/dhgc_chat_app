import 'package:dhgc_chat_app/src/core/helpers/analytics_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:dhgc_chat_app/src/core/services/firebase_analytics_service.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart';

Future<void> analyticsInjectionContainer() async {
  final firebaseAnalytics = FirebaseAnalyticsService(
    FirebaseAnalytics.instance,
  );
  // final mixpanelAnalytics = MixpanelAnalyticsService();

  final analytics = MultiAnalyticsService([
    firebaseAnalytics,
    // mixpanelAnalytics,
  ]);

  // Register with your DI system (get_it, provider, etc.)
  sl.registerSingleton<AnalyticsService>(analytics);
  sl.registerSingleton<AnalyticsHelper>(AnalyticsHelper(analytics));
}

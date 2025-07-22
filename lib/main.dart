import 'package:dhgc_chat_app/src/core/utils/configs/api_configs.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dhgc_chat_app/firebase_options.dart';
import 'package:dhgc_chat_app/src/app.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart' as di;
import 'package:dhgc_chat_app/src/core/services/firebase_notification_service.dart';
// import 'package:dhgc_chat_app/src/core/services/notification_navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load keys from .env
  await dotenv.load().then((_) {
    // Initialize API configurations
    ApiConfigs.baseUrl = dotenv.get(
      'TMDB_BASE_URL',
      fallback: 'https://api.themoviedb.org/3',
    );
    ApiConfigs.apiKey = dotenv.get('TMDB_API_KEY', fallback: '');
    ApiConfigs.imageBaseUrl = dotenv.get(
      'TMDB_IMAGE_URL',
      fallback: 'https://image.tmdb.org/t/p/w500',
    );
    ApiConfigs.apiVersion = dotenv.get('APP_VERSION', fallback: '1.0.0');
    ApiConfigs.fcmServerKey = dotenv.get('FCM_SERVER_KEY', fallback: '');
  });

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize dependency injection
  await di.initInjections();

  // final navigationService = NotificationNavigationService();

  // // Initialize notification service with handler
  // final notificationService = FirebaseNotificationService(
  //   onNotificationOpened: (message) {
  //     // This will be handled by the navigation service
  //     // We'll implement this in the next step
  //   },
  // );
  await di.sl<FirebaseNotificationService>().initialize();

  // runApp(MyApp(navigationService: di.sl<NotificationNavigationService>()));
  runApp(const MyApp());
}

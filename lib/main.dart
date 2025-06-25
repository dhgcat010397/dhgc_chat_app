import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dhgc_chat_app/firebase_options.dart';
import 'package:dhgc_chat_app/src/app.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart' as di;
import 'package:dhgc_chat_app/src/core/services/firebase_notification_service.dart';
import 'package:dhgc_chat_app/src/core/services/notification_navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load keys from .env
  await dotenv.load();

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

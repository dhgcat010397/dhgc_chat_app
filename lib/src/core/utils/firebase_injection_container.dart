import 'package:dhgc_chat_app/src/core/helpers/push_notification_helper.dart';
import 'package:dhgc_chat_app/src/core/services/fstorage_service.dart';
import 'package:dhgc_chat_app/src/core/services/firestore_service.dart';
import 'package:dhgc_chat_app/src/core/services/firebase_notification_service.dart';
import 'package:dhgc_chat_app/src/core/services/notification_navigation_service.dart';
import 'package:dhgc_chat_app/src/core/utils/configs/api_configs.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart';

Future<void> firebaseInjectionContainer() async {
  final firestoreService = FirestoreService();
  final fstorageService = FStorageService();
  // final notificationService = FirebaseNotificationService(
  //   onNotificationOpened:
  //       NotificationNavigationService().handleNotificationNavigation,
  // );
  // final pushNotificationHelper = PushNotificationHelper(
  //   serverKey: ApiConfigs.fcmServerKey,
  // );

  // Register with your DI system (get_it, provider, etc.)
  sl.registerSingleton<FirestoreService>(firestoreService);
  sl.registerSingleton<FStorageService>(fstorageService);
  // sl.registerSingleton<FirebaseNotificationService>(notificationService);
  // sl.registerSingleton<PushNotificationHelper>(pushNotificationHelper);
}

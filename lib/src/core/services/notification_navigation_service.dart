import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dhgc_chat_app/src/core/routes/app_routes.dart';

class NotificationNavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> handleNotificationNavigation(RemoteMessage message) async {
    final route = message.data['route'];
    final conversationId = message.data['conversationId'];

    if (navigatorKey.currentState == null) return;

    if (route == 'chat' && conversationId != null) {
      // Check if user is already on home screen
      final currentRoute =
          ModalRoute.of(navigatorKey.currentContext!)?.settings.name;

      if (currentRoute == AppRoutes.home) {
        // Update conversation badge via BLoC
        // navigatorKey.currentContext!.read<NotificationBloc>().add(
        //   NotificationEvent.messageReceived(conversationId: conversationId),
        // );
      } else {
        // Navigate to chat screen
        navigatorKey.currentState!.pushNamed(
          AppRoutes.chat,
          arguments: conversationId,
        );
      }
    }
  }
}

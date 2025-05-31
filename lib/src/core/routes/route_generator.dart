import 'package:flutter/material.dart';

import 'package:dhgc_chat_app/src/core/routes/app_routes.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/views/auth_page.dart';
import 'package:dhgc_chat_app/src/features/list_conversations/presentation/views/home_page.dart';
import 'package:dhgc_chat_app/src/features/chat/presentation/views/chat_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.chat:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder:
                (_) => ChatPage(
                  conversationId: args['conversationId'],
                  receiverId: args['receiverId'],
                ),
          );
        }

        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Page not found')),
          ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:dhgc_chat_app/src/core/routes/app_routes.dart';

class RedirectToAuthPage extends StatelessWidget {
  const RedirectToAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Using postFrameCallback to avoid navigation during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _redirectToLogin(context);
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  void _redirectToLogin(BuildContext context) {
    // Prevent multiple redirects
    if (ModalRoute.of(context)?.settings.name != AppRoutes.auth) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.auth,
        (route) => false, // Remove all routes
      );
    }
  }
}

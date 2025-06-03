import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dhgc_chat_app/src/core/routes/app_routes.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/bloc/auth_bloc.dart';

class AuthRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    _handleAuthState(route);
  }

  void _handleAuthState(Route route) {
    final context = route.navigator?.context;
    if (context == null) return;

    final authState = context.read<AuthBloc>().state;
    authState.whenOrNull(
      authenticated: (user) {
        if (route.settings.name == AppRoutes.auth) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      },
      unauthenticated: () {
        if (route.settings.name == AppRoutes.home) {
          Navigator.pushReplacementNamed(context, AppRoutes.auth);
        }
      },
    );
  }
}

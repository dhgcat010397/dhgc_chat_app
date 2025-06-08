import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dhgc_chat_app/src/features/splash_page.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/views/auth_page.dart';
import 'package:dhgc_chat_app/src/features/conversations/presentation/views/home_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SplashPage(),
          loading: () => const Center(child: CircularProgressIndicator()),
          authenticated: (user) => HomePage(user: user),
          unauthenticated: () => const AuthPage(), // Your existing AuthPage
          error: (message, _, __) => Center(child: Text('Error: $message')),
        );
      },
    );
  }
}

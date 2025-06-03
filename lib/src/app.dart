import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dhgc_chat_app/src/core/routes/app_routes.dart';
import 'package:dhgc_chat_app/src/core/routes/route_generator.dart';
import 'package:dhgc_chat_app/src/core/routes/auth_route_observer.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart' as di;
import 'package:dhgc_chat_app/src/features/splash_page.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/views/auth_page.dart';
import 'package:dhgc_chat_app/src/features/list_conversations/presentation/views/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AuthBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: AppRoutes.auth,
        onGenerateRoute: RouteGenerator.generateRoute,
        onGenerateInitialRoutes:
            (initialRoute) => [
              PageRouteBuilder(
                pageBuilder:
                    (_, __, ___) => BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () => const SplashPage(),
                          loading:
                              () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                          authenticated: (user) => HomePage(user: user),
                          unauthenticated:
                              () => const AuthPage(), // Your existing AuthPage
                          error:
                              (message, _, __) =>
                                  Center(child: Text('Error: $message')),
                        );
                      },
                    ),
                transitionsBuilder:
                    (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
              ),
            ],
        // Optional: Add a fallback for deep links when auth state changes
        navigatorObservers: [
          AuthRouteObserver(), // Custom observer to handle auth changes
        ],
      ),
    );
  }
}

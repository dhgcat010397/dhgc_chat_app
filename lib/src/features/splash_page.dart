import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhgc_chat_app/src/core/routes/app_routes.dart';
import 'package:dhgc_chat_app/src/core/utils/constants/app_images.dart';
import 'package:dhgc_chat_app/src/core/helpers/analytics_helper.dart';
import 'package:dhgc_chat_app/src/core/helpers/shared_pref_helper.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/views/auth_page.dart';
import 'package:dhgc_chat_app/src/features/list_conversations/presentation/views/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final AnalyticsHelper _analytics;

  @override
  void initState() {
    super.initState();
    _analytics = GetIt.I<AnalyticsHelper>();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Perform initializations
    await Future.wait([
      _loadEssentialData(),
      _checkAuthStatus(context.read<AuthBloc>()),
      // Future.delayed(const Duration(seconds: 2)), // Minimum splash duration
    ]);

    // 2. Trigger navigation via BLoC (recommended)
    // context.read<AppInitializationCubit>().completeSplash();
  }

  Future<void> _loadEssentialData() async {
    await Future.wait([
      SharedPreferencesHelper.init(),
      // DatabaseHelper.instance.database
      // LocalStorage.init(),
      // FirebaseService.initialize(),
      // SettingsService.loadConfig(),
    ]);
  }

  Future<void> _checkAuthStatus(AuthBloc authBloc) async {
    await Future.delayed(const Duration(seconds: 2));
    authBloc.add(const AuthEvent.checkAuthentication());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            authenticated: (user) => _navigateToHome(user),
            unauthenticated: () => _navigateToLogin(),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.greeting, width: 150),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHome(UserEntity user) {
    if (!mounted) return;

    // Log analytics event
    _analytics.logEvent('splash_to_home');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(user: user),
        settings: const RouteSettings(name: AppRoutes.home),
      ),
      (route) => false,
    );
  }

  void _navigateToLogin() {
    if (!mounted) return;

    _analytics.logEvent('splash_to_login');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthPage(),
        settings: const RouteSettings(name: AppRoutes.auth),
      ),
      (route) => false,
    );
  }
}

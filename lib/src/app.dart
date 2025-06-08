import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:dhgc_chat_app/src/core/routes/app_routes.dart';
import 'package:dhgc_chat_app/src/core/routes/route_generator.dart';
import 'package:dhgc_chat_app/src/core/routes/auth_route_observer.dart';
import 'package:dhgc_chat_app/src/core/utils/widgets/auth/auth_wrapper.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart' as di;
import 'package:dhgc_chat_app/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dhgc_chat_app/src/shared/presentation/bloc/search_users_bloc/search_users_bloc.dart';
import 'package:dhgc_chat_app/src/shared/presentation/bloc/user_status_bloc/user_status_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
        BlocProvider(create: (context) => di.sl<SearchUsersBloc>()),
        BlocProvider(create: (context) => di.sl<UserStatusBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
        home: const AuthWrapper(),
        // Optional: Add a fallback for deep links when auth state changes
        navigatorObservers: [
          AuthRouteObserver(), // Custom observer to handle auth changes
        ],
      ),
    );
  }
}

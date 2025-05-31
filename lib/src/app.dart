import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dhgc_chat_app/src/core/routes/app_routes.dart';
import 'package:dhgc_chat_app/src/core/routes/route_generator.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart' as di;
import 'package:dhgc_chat_app/src/features/auth/presentation/views/auth_page.dart';
// import 'package:dhgc_chat_app/src/features/list_conversations/presentation/views/home_page.dart';
import 'package:dhgc_chat_app/src/features/list_conversations/presentation/bloc/list_conversations_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              di.sl<ListConversationsBloc>()
                ..add(ListConversationsEvent.fetchData()),
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
                pageBuilder: (_, __, ___) => const AuthPage(),
                transitionsBuilder:
                    (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
              ),
            ],
      ),
    );
  }
}

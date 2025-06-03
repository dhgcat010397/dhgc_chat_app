import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dhgc_chat_app/src/core/utils/constants/app_colors.dart';
import 'package:dhgc_chat_app/src/core/utils/validators/input_validators.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/widgets/auth_button.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/widgets/password_textfield.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/widgets/text_divider.dart';
import 'package:dhgc_chat_app/src/core/utils/widgets/auth/login_via_thirdparty.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/bloc/auth_bloc.dart';

part 'login_page.dart';
part 'register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void _togglePages() {
    if (mounted) {
      setState(() {
        showLoginPage = !showLoginPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return showLoginPage
        ? LoginPage(onTap: _togglePages)
        : RegisterPage(onTap: _togglePages);
  }
}

import 'package:flutter/material.dart';

import 'package:dhgc_chat_app/src/app.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.initInjections();

  runApp(const MyApp());
}

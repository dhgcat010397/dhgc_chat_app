import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:dhgc_chat_app/firebase_options.dart';
import 'package:dhgc_chat_app/src/app.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize dependency injection
  await di.initInjections();

  runApp(const MyApp());
}

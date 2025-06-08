import 'package:dhgc_chat_app/src/shared/user_injection_container.dart';
import 'package:get_it/get_it.dart';
import 'package:dhgc_chat_app/src/core/utils/firebase_injection_container.dart';
import 'package:dhgc_chat_app/src/features/auth/auth_injection_container.dart';
import 'package:dhgc_chat_app/src/core/utils/analytics_injection_container.dart';
import 'package:dhgc_chat_app/src/features/chat/chat_injection_container.dart';
import 'package:dhgc_chat_app/src/features/conversations/conversation_injection_container.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  await analyticsInjectionContainer();
  await firebaseInjectionContainer();
  await userInjectionContainer(); // Must register before auth, to use user's remote and local data
  await authInjectionContainer();
  await chatInjectionContainer();
  await conversationInjectionContainer();
}

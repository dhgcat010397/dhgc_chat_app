import 'package:get_it/get_it.dart';

import 'package:dhgc_chat_app/src/features/auth/auth_injection_container.dart';
import 'package:dhgc_chat_app/src/core/utils/analytics_injection_container.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  await authInjectionContainer();
  await analyticsInjectionContainer();
}

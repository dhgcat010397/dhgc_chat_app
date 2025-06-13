import 'package:dhgc_chat_app/src/core/services/auth_service.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart';
import 'package:dhgc_chat_app/src/features/auth/data/repo/register_repo_impl.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/repo/register_repo.dart';
import 'package:dhgc_chat_app/src/features/auth/data/repo/login_repo_impl.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/repo/login_repo.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/login_with_google.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/login_with_facebook.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/login_with_apple.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/register_with_email_password.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/bloc/auth_bloc.dart';

Future<void> authInjectionContainer() async {
  // Register the AuthService
  sl.registerLazySingleton<AuthService>(
    () => AuthService(), // Your AuthService implementation
  );

  // Register the repositories
  sl.registerLazySingleton<RegisterRepo>(
    () => RegisterRepoImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
      authService: sl(),
    ),
  );
  sl.registerLazySingleton<LoginRepo>(
    () => LoginRepoImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
      authService: sl(),
    ),
  );

  // Register the use cases
  sl.registerLazySingleton<RegisterWithEmailAndPassword>(
    () => RegisterWithEmailAndPassword(sl()),
  );
  sl.registerLazySingleton<LoginWithEmailAndPassword>(
    () => LoginWithEmailAndPassword(sl()),
  );
  sl.registerLazySingleton<LoginWithGoogle>(() => LoginWithGoogle(sl()));
  sl.registerLazySingleton<LoginWithFacebook>(() => LoginWithFacebook(sl()));
  sl.registerLazySingleton<LoginWithApple>(() => LoginWithApple(sl()));

  // Register the LoginBloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      registerWithEmailAndPassword: sl(),
      loginWithEmailAndPassword: sl(),
      loginWithGoogle: sl(),
      loginWithFacebook: sl(),
      loginWithApple: sl(),
    ),
  );
}

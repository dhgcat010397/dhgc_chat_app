import 'package:dhgc_chat_app/src/core/services/auth_service.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart';
import 'package:dhgc_chat_app/src/features/auth/data/datasources/local/user_local_datasource.dart';
import 'package:dhgc_chat_app/src/features/auth/data/datasources/local/user_local_datasource_impl.dart';
import 'package:dhgc_chat_app/src/features/auth/data/datasources/remote/user_remote_datasource.dart';
import 'package:dhgc_chat_app/src/features/auth/data/datasources/remote/user_remote_datasource_impl.dart';
import 'package:dhgc_chat_app/src/features/auth/data/repo/login_repo_impl.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/repo/login_repo.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/login_with_apple.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/login_with_facebook.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/login_with_google.dart';
import 'package:dhgc_chat_app/src/features/auth/presentation/bloc/auth_bloc.dart';

Future<void> authInjectionContainer() async {
  // Register the AuthService
  sl.registerLazySingleton<AuthService>(
    () => AuthService(), // Your AuthService implementation
  );

  // Register the UserLocalDatasource
  sl.registerLazySingleton<UserLocalDatasource>(
    () => UserLocalDatasourceImpl(),
  );

  // Register the UserRemoteDatasource
  sl.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasourceImpl(),
  );

  // Register the NoteRepo
  sl.registerLazySingleton<LoginRepo>(
    () => LoginRepoImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
      authService: sl(),
    ),
  );

  // Register the use cases
  sl.registerLazySingleton<LoginWithEmailAndPasswordUsecase>(
    () => LoginWithEmailAndPasswordUsecase(sl()),
  );

  sl.registerLazySingleton<LoginWithGoogleUsecase>(
    () => LoginWithGoogleUsecase(sl()),
  );

  sl.registerLazySingleton<LoginWithFacebookUsecase>(
    () => LoginWithFacebookUsecase(sl()),
  );

  sl.registerLazySingleton<LoginWithAppleUsecase>(
    () => LoginWithAppleUsecase(sl()),
  );

  // Register the LoginBloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginWithEmailAndPasswordUsecase: sl(),
      loginWithGoogleUsecase: sl(),
      loginWithFacebookUsecase: sl(),
      loginWithAppleUsecase: sl(),
    ),
  );
}

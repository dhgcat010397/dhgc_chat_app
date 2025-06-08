import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/local/user_local_datasource.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/local/user_local_datasource_impl.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/remote/user_remote_datasource.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/remote/user_remote_datasource_impl.dart';
import 'package:dhgc_chat_app/src/shared/data/repo/user_repo_impl.dart';
import 'package:dhgc_chat_app/src/shared/domain/repo/user_repo.dart';
import 'package:dhgc_chat_app/src/shared/domain/usecases/check_user_exist.dart';
import 'package:dhgc_chat_app/src/shared/domain/usecases/get_user_info.dart';
import 'package:dhgc_chat_app/src/shared/domain/usecases/get_user_status.dart';
import 'package:dhgc_chat_app/src/shared/domain/usecases/search_users_by_name.dart';
import 'package:dhgc_chat_app/src/shared/domain/usecases/update_user_status.dart';
import 'package:dhgc_chat_app/src/shared/presentation/bloc/search_users_bloc/search_users_bloc.dart';
import 'package:dhgc_chat_app/src/shared/presentation/bloc/user_status_bloc/user_status_bloc.dart';

Future<void> userInjectionContainer() async {
  // Register the UserLocalDatasource
  sl.registerLazySingleton<UserLocalDatasource>(
    () => UserLocalDatasourceImpl(),
  );

  // Register the UserRemoteDatasource
  sl.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasourceImpl(sl()),
  );

  // Register the UserRepo
  sl.registerLazySingleton<UserRepo>(
    () => UserRepoImpl(localDatasource: sl(), remoteDatasource: sl()),
  );

  // Register the use cases
  sl.registerLazySingleton<CheckUserExist>(() => CheckUserExist(sl()));
  sl.registerLazySingleton<GetUserInfo>(() => GetUserInfo(sl()));
  sl.registerLazySingleton<GetUserStatus>(() => GetUserStatus(sl()));
  sl.registerLazySingleton<UpdateUserStatus>(() => UpdateUserStatus(sl()));
  sl.registerLazySingleton<SearchUsersByName>(() => SearchUsersByName(sl()));

  // Register the SearchUsersBloc
  sl.registerFactory<SearchUsersBloc>(() => SearchUsersBloc(
    searchUsersByName: sl(),
  ));
  sl.registerFactory<UserStatusBloc>(
    () => UserStatusBloc(updateUserStatus: sl()),
  );
}

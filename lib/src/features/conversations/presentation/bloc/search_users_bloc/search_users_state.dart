part of "search_users_bloc.dart";

@freezed
abstract class SearchUsersState with _$SearchUsersState {
  const factory SearchUsersState.initial() = _Initial;
  const factory SearchUsersState.loading() = _Loading;
  const factory SearchUsersState.loaded({required List<UserEntity> users}) =
      _Loaded;
  const factory SearchUsersState.error({
    String? code,
    String? message,
    StackTrace? stackTrace,
  }) = _Error;
}

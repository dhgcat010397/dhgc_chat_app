part of 'search_users_bloc.dart';

@freezed
class SearchUsersState with _$SearchUsersState {
  const factory SearchUsersState.initial() = _Initial;
  const factory SearchUsersState.loading() = _Loading;
  const factory SearchUsersState.loadMore({required List<UserEntity> users}) =
      _LoadMore;
  const factory SearchUsersState.success({
    required List<UserEntity> users,
    required bool hasReachedMax,
  }) = _Success;
  const factory SearchUsersState.error({
    required List<UserEntity> currentUsers,
    String? code,
    String? message,
    StackTrace? stackTrace,
  }) = _Error;
  const factory SearchUsersState.empty() = _Empty;
}

part of 'user_status_bloc.dart';

@freezed
class UserStatusState with _$UserStatusState {
  const factory UserStatusState.initial() = _Initial;
  const factory UserStatusState.loading() = _Loading;
  const factory UserStatusState.updated(UserStatus status) = _Updated;
  const factory UserStatusState.error({
    String? code,
    String? message,
    StackTrace? stackTrace,
  }) = _Error;
}

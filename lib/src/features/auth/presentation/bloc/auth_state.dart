part of "auth_bloc.dart";

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error({
    required String message,
    @Default('AUTH_ERROR') String code,
    StackTrace? stackTrace,
  }) = _Error;
}

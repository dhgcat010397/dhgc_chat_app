part of "auth_bloc.dart";

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkAuthentication() = _CheckAuthentication;
  const factory AuthEvent.registerWithEmailAndPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullname,
  }) = _RegisterWithEmailAndPassword;
  const factory AuthEvent.loginWithEmailAndPassword(
    String email,
    String password,
  ) = _LoginWithEmailAndPassword;
  const factory AuthEvent.loginWithGoogle() = _LoginWithGoogle;
  const factory AuthEvent.loginWithFacebook() = _LoginWithFacebook;
  const factory AuthEvent.loginWithApple() = _LoginWithApple;
}

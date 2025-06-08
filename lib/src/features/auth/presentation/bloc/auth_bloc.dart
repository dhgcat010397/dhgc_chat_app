import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/login_with_apple.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/login_with_facebook.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/usecases/login_with_google.dart';

part "auth_state.dart";
part "auth_event.dart";

part 'auth_bloc.freezed.dart'; // run: flutter pub run build_runner build --delete-conflicting-outputs

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmailAndPassword _loginWithEmailAndPassword;
  final LoginWithGoogle _loginWithGoogle;
  final LoginWithFacebook _loginWithFacebook;
  final LoginWithApple _loginWithApple;

  late UserEntity? user;

  AuthBloc({
    required LoginWithEmailAndPassword loginWithEmailAndPassword,
    required LoginWithGoogle loginWithGoogle,
    required LoginWithFacebook loginWithFacebook,
    required LoginWithApple loginWithApple,
  }) : _loginWithEmailAndPassword = loginWithEmailAndPassword,
       _loginWithGoogle = loginWithGoogle,
       _loginWithFacebook = loginWithFacebook,
       _loginWithApple = loginWithApple,
       super(const _Initial()) {
    on<AuthEvent>(
      (event, emit) => event.map(
        checkAuthentication: (event) => _onCheckAuthentication(emit),
        loginWithEmailAndPassword:
            (event) => _onLoginWithEmailAndPassword(event, emit),
        loginWithGoogle: (event) => _onLoginWithGoogle(emit),
        loginWithFacebook: (event) => _onLoginWithFacebook(emit),
        loginWithApple: (event) => _onLoginWithApple(emit),
      ),
    );
  }

  Future<void> _onCheckAuthentication(Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    try {
      emit(const AuthState.unauthenticated());
    } catch (e, stackTrace) {
      emit(
        AuthState.error(
          code: e.hashCode.toString(),
          message: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<void> _onLoginWithEmailAndPassword(
    _LoginWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    try {
      // _notesList = await getNotesListUseCase.call();
      // final email = event.email;
      // final password = event.password;
      emit(AuthState.authenticated(user!));
    } catch (e, stackTrace) {
      emit(
        AuthState.error(
          code: e.hashCode.toString(),
          message: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<void> _onLoginWithGoogle(Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    try {
      user = await _loginWithGoogle.call();
      emit(AuthState.authenticated(user!));
    } catch (e, stackTrace) {
      emit(
        AuthState.error(
          code: e.hashCode.toString(),
          message: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<void> _onLoginWithFacebook(Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    try {
      // _notesList = await getNotesListUseCase.call();
      emit(AuthState.authenticated(user!));
    } catch (e, stackTrace) {
      emit(
        AuthState.error(
          code: e.hashCode.toString(),
          message: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<void> _onLoginWithApple(Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    try {
      // _notesList = await getNotesListUseCase.call();
      emit(AuthState.authenticated(user!));
    } catch (e, stackTrace) {
      emit(
        AuthState.error(
          code: e.hashCode.toString(),
          message: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}

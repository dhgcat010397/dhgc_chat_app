import 'dart:async';

import 'package:dhgc_chat_app/src/shared/domain/entities/user_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dhgc_chat_app/src/shared/domain/usecases/update_user_status.dart';

part 'user_status_event.dart';
part 'user_status_state.dart';
part 'user_status_bloc.freezed.dart';

class UserStatusBloc extends Bloc<UserStatusEvent, UserStatusState> {
  final UpdateUserStatus _updateUserStatus;
  StreamSubscription? _statusSub;

  UserStatusBloc({required UpdateUserStatus updateUserStatus})
    : _updateUserStatus = updateUserStatus,
      super(const UserStatusState.initial()) {
    on<UserStatusEvent>(
      (event, emit) => event.map(
        subscribe: (event) => _handleSubscribe(event, emit),
        statusChanged: (event) => _handleStatusChanged(event, emit),
      ),
    );
  }

  Future<void> _handleSubscribe(
    _Subscribe event,
    Emitter<UserStatusState> emit,
  ) async {
    await _statusSub?.cancel();
    emit(const UserStatusState.loading());

    _statusSub = _updateUserStatus
        .call(event.userId)
        .listen((status) => add(UserStatusEvent.statusChanged(status)));
  }

  void _handleStatusChanged(
    _StatusChanged event,
    Emitter<UserStatusState> emit,
  ) {
    emit(UserStatusState.updated(event.status));
  }

  @override
  Future<void> close() {
    _statusSub?.cancel();
    return super.close();
  }
}

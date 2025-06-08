part of 'user_status_bloc.dart';

@freezed
class UserStatusEvent with _$UserStatusEvent {
  const factory UserStatusEvent.subscribe(String userId) = _Subscribe;
  const factory UserStatusEvent.statusChanged(UserStatus status) =
      _StatusChanged;
}

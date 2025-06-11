import 'package:equatable/equatable.dart';

import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_status.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_type.dart';
import 'package:dhgc_chat_app/src/features/chat/data/models/call_model.dart';
import 'package:dhgc_chat_app/src/core/utils/mappers/model_convertable.dart';

class CallEntity extends Equatable
    with ModelConvertible<CallEntity, CallModel> {
  final String callId;
  final CallType callType; // voice or video
  final String callerId;
  final List<String> participants;
  final DateTime? startTime;
  final DateTime? endTime;
  final CallStatus status; // calling, ongoing, missed, ended, rejected
  final Duration? duration;

  const CallEntity({
    required this.callId,
    required this.callType,
    required this.callerId,
    required this.participants,
    required this.startTime,
    this.endTime,
    required this.status,
    this.duration,
  });

  @override
  List<Object?> get props => [
    callId,
    callType,
    callerId,
    participants,
    startTime,
    endTime,
    status,
    duration,
  ];

  @override
  CallModel toModel() {
    return CallModel(
      callId: callId,
      callType: callType,
      callerId: callerId,
      participants: participants,
      startTime: startTime,
      endTime: endTime,
      status: status,
      durationMillis: duration?.inMilliseconds,
    );
  }

  CallEntity copyWith({
    String? callId,
    CallType? callType,
    String? callerId,
    List<String>? participants,
    DateTime? startTime,
    DateTime? endTime,
    CallStatus? status,
    Duration? duration,
  }) {
    return CallEntity(
      callId: callId ?? this.callId,
      callType: callType ?? this.callType,
      callerId: callerId ?? this.callerId,
      participants: participants ?? List<String>.from(this.participants),
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      duration: duration ?? this.duration,
    );
  }
}

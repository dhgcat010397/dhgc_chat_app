import 'package:equatable/equatable.dart';

import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_status.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_type.dart';
import 'package:dhgc_chat_app/src/core/utils/mappers/entity_convertable.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_entity.dart';

class CallModel extends Equatable
    with EntityConvertible<CallModel, CallEntity> {
  final String callId;
  final CallType callType; // voice or video
  final String callerId;
  final List<String> participants;
  final DateTime startTime;
  final DateTime? endTime;
  final CallStatus status; // ongoing, missed, ended...
  final int? durationMillis;

  const CallModel({
    required this.callId,
    required this.callType,
    required this.callerId,
    required this.participants,
    required this.startTime,
    this.endTime,
    required this.status,
    this.durationMillis,
  });

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      callId: json['callId'] as String,
      callType: CallType.values.firstWhere((e) => e.name == json['callType']),
      callerId: json['callerId'] as String,
      participants: List<String>.from(json['participants'] as List),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime:
          json['endTime'] != null
              ? DateTime.parse(json['endTime'] as String)
              : null,
      status: CallStatus.values.firstWhere((e) => e.name == json['status']),
      durationMillis: json['durationMillis'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callId': callId,
      'callType': callType.name,
      'callerId': callerId,
      'participants': participants,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': status.name,
      'durationMillis': durationMillis,
    };
  }

  @override
  List<Object?> get props => [
    callId,
    callType,
    callerId,
    participants,
    startTime,
    endTime,
    status,
    durationMillis,
  ];

  @override
  CallEntity toEntity() {
    return CallEntity(
      callId: callId,
      callType: callType,
      callerId: callerId,
      participants: participants,
      startTime: startTime,
      endTime: endTime,
      status: status,
      duration:
          durationMillis != null
              ? Duration(milliseconds: durationMillis!)
              : null,
    );
  }

  CallModel copyWith({
    String? callId,
    CallType? callType,
    String? callerId,
    List<String>? participants,
    DateTime? startTime,
    DateTime? endTime,
    CallStatus? status,
    int? durationMillis,
  }) {
    return CallModel(
      callId: callId ?? this.callId,
      callType: callType ?? this.callType,
      callerId: callerId ?? this.callerId,
      participants: participants ?? List<String>.from(this.participants),
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      durationMillis: durationMillis ?? this.durationMillis,
    );
  }
}

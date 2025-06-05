import 'package:equatable/equatable.dart';

import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_status.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_type.dart';
import 'package:dhgc_chat_app/src/features/chat/data/models/message_model.dart';
import 'package:dhgc_chat_app/src/core/utils/mappers/model_convertable.dart';

class MessageEntity extends Equatable
    with ModelConvertible<MessageEntity, MessageModel> {
  final String messageId;
  final String senderId;
  final String? text;
  final List<String>? imageUrls;
  final DateTime timestamp;
  final MessageType type;
  final String? callId;
  final CallStatus? callStatus;
  final bool isSeen;

  const MessageEntity({
    required this.messageId,
    required this.senderId,
    this.text,
    this.imageUrls,
    required this.timestamp,
    required this.type,
    this.callId,
    this.callStatus,
    required this.isSeen,
  });

  @override
  List<Object?> get props => [
    messageId,
    senderId,
    text,
    imageUrls,
    timestamp,
    type,
    callId,
    callStatus,
    isSeen,
  ];

  @override
  MessageModel toModel() {
    return MessageModel(
      messageId: messageId,
      senderId: senderId,
      text: text,
      imageUrls: imageUrls,
      timestamp: timestamp,
      type: type,
      callId: callId,
      callStatus: callStatus,
      isSeen: isSeen,
    );
  }

  MessageEntity copyWith({
    String? messageId,
    String? senderId,
    String? text,
    List<String>? imageUrls,
    DateTime? timestamp,
    MessageType? type,
    String? callId,
    CallStatus? callStatus,
    bool? isSeen,
  }) {
    return MessageEntity(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      imageUrls: imageUrls ?? this.imageUrls,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      callId: callId ?? this.callId,
      callStatus: callStatus ?? this.callStatus,
      isSeen: isSeen ?? this.isSeen,
    );
  }
}

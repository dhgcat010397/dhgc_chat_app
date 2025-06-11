import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_status.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_type.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_entity.dart';
import 'package:dhgc_chat_app/src/core/utils/mappers/entity_convertable.dart';

class MessageModel extends Equatable
    with EntityConvertible<MessageModel, MessageEntity> {
  final String messageId;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String? text;
  final List<String>? imageUrls;
  final DateTime? timestamp;
  final MessageType type;
  final String? callId;
  final CallStatus? callStatus;
  final bool isSeen;

  const MessageModel({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    this.text,
    this.imageUrls,
    required this.timestamp,
    required this.type,
    this.callId,
    this.callStatus,
    this.isSeen = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['messageId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String? ?? "",
      senderAvatar: json['senderAvatar'] as String? ?? "",
      text: json['text'] as String? ?? "",
      imageUrls: (json['imageUrls'] as List<dynamic>?)?.cast<String>(),
      timestamp: (json['timestamp'] as Timestamp?)?.toDate(),
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      callId: json['callId'] as String? ?? "",
      callStatus: CallStatus.values.firstWhere(
        (e) => e.name == json['callStatus'],
        orElse: () => CallStatus.rejected,
      ),
      isSeen: json['isSeen'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'text': text,
      'imageUrls': imageUrls,
      'timestamp': timestamp?.toIso8601String(),
      'type': type.toString().split('.').last,
      'callId': callId,
      'callStatus': callStatus?.toString().split('.').last,
      'isSeen': isSeen,
    };
  }

  @override
  List<Object?> get props => [
    messageId,
    senderId,
    senderName,
    senderAvatar,
    text,
    imageUrls,
    timestamp,
    type,
    callId,
    callStatus,
    isSeen,
  ];

  @override
  MessageEntity toEntity() {
    return MessageEntity(
      messageId: messageId,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      text: text,
      imageUrls: imageUrls,
      timestamp: timestamp,
      type: type,
      callId: callId,
      callStatus: callStatus,
      isSeen: isSeen,
    );
  }

  MessageModel copyWith({
    String? messageId,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? text,
    List<String>? imageUrls,
    DateTime? timestamp,
    MessageType? type,
    String? callId,
    CallStatus? callStatus,
    bool? isSeen,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
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

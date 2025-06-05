import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dhgc_chat_app/src/features/chat/domain/entities/chatroom_type.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_type.dart';
import 'package:dhgc_chat_app/src/features/chat/data/models/call_model.dart';
import 'package:dhgc_chat_app/src/features/chat/data/models/message_model.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/chatroom_entity.dart';
import 'package:dhgc_chat_app/src/core/utils/mappers/entity_convertable.dart';

class ChatroomModel extends Equatable
    with EntityConvertible<ChatroomModel, ChatroomEntity> {
  final String chatroomId;
  final List<String> participants;
  final String? lastMessage;
  final String? lastMessageSenderId;
  final DateTime? lastMessageTime;
  final Map<String, DateTime>? lastReadTime;
  final MessageType? lastMessageType;

  /// if a group
  final String? adminId;
  final String chatroomName;

  /// 1-1, group
  final ChatroomType chatroomType;

  final CallModel? ongoingCall;

  final List<MessageModel> messages;

  const ChatroomModel({
    required this.chatroomId,
    required this.participants,
    this.lastMessage,
    this.lastMessageSenderId,
    this.lastMessageTime,
    this.lastReadTime,
    this.lastMessageType,
    this.adminId,
    this.chatroomName = "",
    this.chatroomType = ChatroomType.private,
    this.ongoingCall,
    this.messages = const [],
  });

  factory ChatroomModel.fromJson(Map<String, dynamic> json) {
    return ChatroomModel(
      chatroomId: json['chatroomId'] as String,
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['lastMessage'] as String?,
      lastMessageSenderId: json['lastMessageSenderId'] as String?,
      lastMessageTime:
          json['lastMessageTime'] != null
              ? (json['lastMessageTime'] is Timestamp
                  ? (json['lastMessageTime'] as Timestamp).toDate()
                  : DateTime.parse(json['lastMessageTime']))
              : null,
      lastReadTime:
          json['lastReadTime'] != null
              ? (json['lastReadTime'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(
                  key,
                  value is Timestamp ? value.toDate() : DateTime.parse(value),
                ),
              )
              : null,
      lastMessageType:
          json['lastMessageType'] != null
              ? MessageType.values.firstWhere(
                (e) => e.toString() == 'MessageType.${json['lastMessageType']}',
              )
              : null,
      adminId: json['adminId'] as String?,
      chatroomName: json['chatroomName'] as String? ?? "",
      chatroomType:
          json['chatroomType'] != null
              ? ChatroomType.values.firstWhere(
                (e) => e.toString() == 'ChatroomType.${json['chatroomType']}',
              )
              : ChatroomType.private,
      ongoingCall:
          json['ongoingCall'] != null
              ? CallModel.fromJson(json['ongoingCall'] as Map<String, dynamic>)
              : null,
      messages:
          json['messages'] != null
              ? (json['messages'] as List)
                  .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatroomId': chatroomId,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'lastReadTime': lastReadTime?.map(
        (key, value) => MapEntry(key, value.toIso8601String()),
      ),
      'lastMessageType': lastMessageType?.toString().split('.').last,
      'adminId': adminId,
      'chatroomName': chatroomName,
      'chatroomType': chatroomType.toString().split('.').last,
      'ongoingCall': ongoingCall?.toJson(),
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    chatroomId,
    participants,
    lastMessage,
    lastMessageSenderId,
    lastMessageTime,
    lastReadTime,
    lastMessageType,
    adminId,
    chatroomName,
    chatroomType,
    ongoingCall,
    messages,
  ];

  @override
  ChatroomEntity toEntity() {
    return ChatroomEntity(
      chatroomId: chatroomId,
      participants: participants,
      lastMessage: lastMessage,
      lastMessageSenderId: lastMessageSenderId,
      lastMessageTime: lastMessageTime,
      lastReadTime: lastReadTime,
      lastMessageType: lastMessageType,
      adminId: adminId,
      chatroomName: chatroomName,
      chatroomType: chatroomType,
      ongoingCall: ongoingCall?.toEntity(),
      messages: messages.map((e) => e.toEntity()).toList(),
    );
  }

  ChatroomModel copyWith({
    String? chatroomId,
    List<String>? participants,
    String? lastMessage,
    String? lastMessageSenderId,
    DateTime? lastMessageTime,
    Map<String, DateTime>? lastReadTime,
    MessageType? lastMessageType,
    String? adminId,
    String? chatroomName,
    ChatroomType? chatroomType,
    CallModel? ongoingCall,
    List<MessageModel>? messages,
  }) {
    return ChatroomModel(
      chatroomId: chatroomId ?? this.chatroomId,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastReadTime: lastReadTime ?? this.lastReadTime,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      adminId: adminId ?? this.adminId,
      chatroomName: chatroomName ?? this.chatroomName,
      chatroomType: chatroomType ?? this.chatroomType,
      ongoingCall: ongoingCall ?? this.ongoingCall,
      messages: messages ?? this.messages,
    );
  }
}

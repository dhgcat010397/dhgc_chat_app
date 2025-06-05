import 'package:equatable/equatable.dart';

import 'package:dhgc_chat_app/src/features/chat/domain/entities/chatroom_type.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_type.dart';
import 'package:dhgc_chat_app/src/features/chat/data/models/chatroom_model.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_entity.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_entity.dart';
import 'package:dhgc_chat_app/src/core/utils/mappers/model_convertable.dart';

class ChatroomEntity extends Equatable
    with ModelConvertible<ChatroomEntity, ChatroomModel> {
  final String chatroomId;
  final List<String> participants;
  final String? lastMessage;
  final String? lastMessageSenderId;
  final DateTime? lastMessageTime;
  final Map<String, DateTime>? lastReadTime;
  final MessageType? lastMessageType;
  final String? adminId;
  final String chatroomName;
  final ChatroomType chatroomType;
  final CallEntity? ongoingCall;
  final List<MessageEntity> messages;

  const ChatroomEntity({
    required this.chatroomId,
    required this.participants,
    this.lastMessage,
    this.lastMessageSenderId,
    this.lastMessageTime,
    this.lastReadTime,
    this.lastMessageType,
    this.adminId,
    required this.chatroomName,
    required this.chatroomType,
    this.ongoingCall,
    required this.messages,
  });

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
  ChatroomModel toModel() {
    return ChatroomModel(
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
      ongoingCall: ongoingCall?.toModel(),
      messages: messages.map((e) => e.toModel()).toList(),
    );
  }

  ChatroomEntity copyWith({
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
    CallEntity? ongoingCall,
    List<MessageEntity>? messages,
  }) {
    return ChatroomEntity(
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

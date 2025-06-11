import 'package:equatable/equatable.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/group_users_entity.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_type.dart';

class ConversationEntity extends Equatable {
  final String id; // chatroomId
  final String? uid; // if chat 1-1, name = receiver's id
  final String? name; // if chat 1-1, name = receiver's name
  final String? avatar; // if chat 1-1, avatar = receiver's avatar
  final DateTime createdAt;
  final bool isOnline;
  final String lastMessage;
  final DateTime lastMessageAt;
  final MessageType lastMessageType;
  final bool isGroup;
  final List<String> participants;
  final GroupUsersEntity? groupInfo;

  const ConversationEntity({
    required this.id,
    this.uid,
    this.name,
    this.avatar,
    required this.createdAt,
    this.isOnline = true,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.lastMessageType,
    this.isGroup = false,
    required this.participants,
    required this.groupInfo,
  });

  @override
  List<Object?> get props => [
    id,
    uid,
    name,
    avatar,
    createdAt,
    isOnline,
    lastMessage,
    lastMessageAt,
    lastMessageType,
    isGroup,
    participants,
  ];

  ConversationEntity copyWith({
    String? id,
    String? uid,
    String? name,
    String? avatar,
    DateTime? createdAt,
    bool? isOnline,
    String? lastMessage,
    DateTime? lastMessageAt,
    MessageType? lastMessageType,
    bool? isGroup,
    List<String>? participants,
    GroupUsersEntity? groupInfo,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      isOnline: isOnline ?? this.isOnline,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      isGroup: isGroup ?? this.isGroup,
      participants: participants ?? this.participants,
      groupInfo: groupInfo ?? this.groupInfo,
    );
  }
}

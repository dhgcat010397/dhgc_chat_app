import 'package:equatable/equatable.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/group_users_entity.dart';

class ConversationEntity extends Equatable {
  final String id;  // chatroomId
  final String? uid; // if chat 1-1, name = receiver's id
  final String? name; // if chat 1-1, name = receiver's name
  final String? avatar; // if chat 1-1, avatar = receiver's avatar
  final DateTime createdAt;
  final bool isOnline;
  final String lastMessage;
  final DateTime lastMessageAt;
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
      isGroup: isGroup ?? this.isGroup,
      participants: participants ?? this.participants,
      groupInfo: groupInfo ?? this.groupInfo,
    );
  }
}

import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String id; // The ID of the conversation, which is a unique identifier
  final DateTime createdAt;
  final String
  ownerId; // The ID of the user who owns the conversation. In this case, the current user
  final String
  receiverId; // The ID of the user with whom the conversation is held
  final String receiverName;
  final String receiverAvatar;
  final bool isOnline;
  final String lastMessage;
  final DateTime lastMessageAt;

  const ConversationEntity({
    required this.id,
    required this.createdAt,
    required this.ownerId,
    required this.receiverId,
    required this.receiverName,
    required this.receiverAvatar,
    this.isOnline = true,
    required this.lastMessage,
    required this.lastMessageAt,
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    ownerId,
    receiverId,
    receiverName,
    receiverAvatar,
    isOnline,
    lastMessage,
    lastMessageAt,
  ];

  ConversationEntity copyWith({
    String? id,
    DateTime? createdAt,
    String? ownerId,
    String? receiverId,
    String? receiverName,
    String? receiverAvatar,
    bool? isOnline,
    String? lastMessage,
    DateTime? lastMessageAt,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      ownerId: ownerId ?? this.ownerId,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverAvatar: receiverAvatar ?? this.receiverAvatar,
      isOnline: isOnline ?? this.isOnline,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }
}

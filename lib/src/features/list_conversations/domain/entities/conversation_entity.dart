import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String id; // The ID of the conversation, which is a unique identifier
  final DateTime createdAt;
  final String ownerId; // The ID of the user who owns the conversation. In this case, the current user
  final String receiverId; // The ID of the user with whom the conversation is held
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

  @override
  bool get stringify => true;
}

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/conversation_entity.dart';

class PaginatedConversations extends Equatable {
  final List<ConversationEntity> conversations;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  const PaginatedConversations({
    required this.conversations,
    this.lastDocument,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [conversations, lastDocument, hasMore];

  PaginatedConversations copyWith({
    List<ConversationEntity>? conversations,
    DocumentSnapshot? lastDocument,
    bool? hasMore,
  }) {
    return PaginatedConversations(
      conversations: conversations ?? this.conversations,
      lastDocument: lastDocument ?? this.lastDocument,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

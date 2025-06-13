import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/conversation_entity.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/paginated_conversations.dart';

abstract class ConversationRepo {
  Future<PaginatedConversations> getConversations({
    required String uid,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  });
  Future<ConversationEntity> createConversation({
    required String uid,
    required List<String> participants,
    String? groupName,
  });
  Future<void> deleteConversation(String chatroomId);
  Future<void> markAsRead(String chatroomId);
  Future<void> markAsUnread(String chatroomId);
  Future<PaginatedConversations> searchConversationByName({
    required String uid,
    required String query,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  });
}

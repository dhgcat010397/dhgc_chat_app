import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhgc_chat_app/src/core/utils/enums/search_type.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/conversation_entity.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/paginated_conversations.dart';

abstract class ConversationRepo {
  Future<PaginatedConversations> getConversations({
    required String uid,
    int limit = 30,
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
  Future<List<ConversationEntity>> searchConversations({
    required SearchType searchType,
    String? id,
    String? username,
    String? displayName,
    String? phone,
    String? email,
  });
}

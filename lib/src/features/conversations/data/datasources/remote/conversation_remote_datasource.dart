import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/conversation_entity.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/paginated_conversations.dart';

abstract class ConversationRemoteDatasource {
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

// Document Structure - "conversations"
// {
//   "id": "group_123",
//   "participants": ["user1", "user2", "user3"],
//   "createdAt": "2023-07-20T10:00:00Z",
//   "lastMessage": "Group created",
//   "lastMessageTime": "2023-07-20T10:00:00Z",
//   "lastMessageType": "system",
//   "participantData": {
//     "user1": {"hasUnread": false, "lastSeen": "2023-07-20T10:00:00Z"},
//     "user2": {"hasUnread": true, "lastSeen": null},
//     "user3": {"hasUnread": true, "lastSeen": null}
//   },
//   "isGroup": true,
//   "groupName": "Friends Group",
//   "groupAvatar": ["https://..."],
//   "createdBy": "user1",
//   "admins": ["user1"]
// }

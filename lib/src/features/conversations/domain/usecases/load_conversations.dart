import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/paginated_conversations.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/repo/conversation_repo.dart';

class LoadConversations {
  final ConversationRepo _repo;

  LoadConversations(this._repo);

  Future<PaginatedConversations> call({
    required String uid,
    int limit = 30,
    DocumentSnapshot? lastDocument,
  }) async {
    return _repo.getConversations(
      uid: uid,
      limit: limit,
      lastDocument: lastDocument,
    );
  }
}

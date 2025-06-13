import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/paginated_conversations.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/repo/conversation_repo.dart';

class SearchConversations {
  final ConversationRepo _repo;

  SearchConversations(this._repo);

  Future<PaginatedConversations> call({
    required String uid,
    required String query,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    return _repo.searchConversationByName(
      uid: uid,
      query: query,
      limit: limit,
      lastDocument: lastDocument,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhgc_chat_app/src/core/utils/enums/search_type.dart';
import 'package:dhgc_chat_app/src/features/conversations/data/datasources/remote/conversation_remote_datasource.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/conversation_entity.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/paginated_conversations.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/repo/conversation_repo.dart';

class ConversationRepoImpl implements ConversationRepo {
  final ConversationRemoteDatasource remoteDatasource;

  ConversationRepoImpl({required this.remoteDatasource});

  @override
  Future<PaginatedConversations> getConversations({
    required String uid,
    int limit = 30,
    DocumentSnapshot? lastDocument,
  }) async {
    return await remoteDatasource.getConversations(
      uid: uid,
      limit: limit,
      lastDocument: lastDocument,
    );
  }

  @override
  Future<ConversationEntity> createConversation({
    required String uid,
    required List<String> participants,
    String? groupName,
  }) async {
    return await remoteDatasource.createConversation(
      uid: uid,
      participants: participants,
    );
  }

  @override
  Future<void> deleteConversation(String chatroomId) async {
    await remoteDatasource.deleteConversation(chatroomId);
  }

  @override
  Future<void> markAsRead(String chatroomId) async {
    await remoteDatasource.markAsRead(chatroomId);
  }

  @override
  Future<void> markAsUnread(String chatroomId) async {
    await remoteDatasource.markAsUnread(chatroomId);
  }

  @override
  Future<List<ConversationEntity>> searchConversations({
    required SearchType searchType,
    String? id,
    String? username,
    String? displayName,
    String? phone,
    String? email,
  }) async {
    return await remoteDatasource.searchConversations(
      searchType: searchType,
      id: id,
      username: username,
      displayName: displayName,
      phone: phone,
      email: email,
    );
  }
}

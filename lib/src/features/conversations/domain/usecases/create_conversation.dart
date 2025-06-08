import 'package:dhgc_chat_app/src/features/conversations/domain/entities/conversation_entity.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/repo/conversation_repo.dart';

class CreateConversation {
  final ConversationRepo _repo;

  CreateConversation(this._repo);

  Future<ConversationEntity> call({
    required String uid,
    required List<String> participants,
    String? groupName,
  }) async {
    return await _repo.createConversation(
      uid: uid,
      participants: participants,
      groupName: groupName,
    );
  }
}

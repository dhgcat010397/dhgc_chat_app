import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_entity.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/repo/chat_repo.dart';

class LoadMoreMessages {
  final ChatRepo _repo;

  LoadMoreMessages(this._repo);

  Future<List<MessageEntity>> call({
    required String chatroomId,
    required DateTime beforeTimestamp,
    int limit = 20,
  }) {
    return _repo.getMoreMessages(
      chatroomId: chatroomId,
      beforeTimestamp: beforeTimestamp,
      limit: limit,
    );
  }
}

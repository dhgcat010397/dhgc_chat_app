import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_entity.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/repo/chat_repo.dart';

class LoadMessages {
  final ChatRepo _repo;

  LoadMessages(this._repo);

  Stream<List<MessageEntity>> call(String chatroomId, [int limit = 20]) {
    return _repo.getMessages(chatroomId, limit);
  }
}

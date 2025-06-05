import 'package:dhgc_chat_app/src/features/chat/domain/repo/chat_repo.dart';

class DeleteConversation {
  final ChatRepo _repo;

  DeleteConversation(this._repo);

  Future<void> call(String chatroomId) async {
    return _repo.deleteChatroom(chatroomId);
  }
}

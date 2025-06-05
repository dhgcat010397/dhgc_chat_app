import 'package:dhgc_chat_app/src/features/chat/domain/repo/chat_repo.dart';

class SendTextMessage {
  final ChatRepo _repo;

  SendTextMessage(this._repo);

  Future<void> call({
    required String chatroomId,
    required String senderId,
    required String text,
  }) async {
    return _repo.sendTextMessage(
      chatroomId: chatroomId,
      senderId: senderId,
      text: text,
    );
  }
}

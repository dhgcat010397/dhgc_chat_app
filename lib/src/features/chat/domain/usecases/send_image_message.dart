import 'package:dhgc_chat_app/src/features/chat/domain/repo/chat_repo.dart';

class SendImageMessage {
  final ChatRepo _repo;

  SendImageMessage(this._repo);

  Future<void> call({
    required String chatroomId,
    required String senderId,
    required List<String> imagePaths,
  }) async {
    return _repo.sendImageMessage(
      chatroomId: chatroomId,
      senderId: senderId,
      imagePaths: imagePaths,
    );
  }
}

import 'package:dhgc_chat_app/src/features/chat/domain/repo/chat_repo.dart';

class SendImageMessage {
  final ChatRepo _repo;

  SendImageMessage(this._repo);

  Future<void> call({
    required String chatroomId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required List<String> imagePaths,
  }) async {
    return _repo.sendImageMessage(
      chatroomId: chatroomId,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      imagePaths: imagePaths,
    );
  }
}

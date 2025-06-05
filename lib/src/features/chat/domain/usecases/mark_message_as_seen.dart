import 'package:dhgc_chat_app/src/features/chat/domain/repo/chat_repo.dart';

class MarkMessageAsSeen {
  final ChatRepo _repo;

  MarkMessageAsSeen(this._repo);

  Future<void> call(String messageId) async {
    return _repo.markMessageAsSeen(messageId);
  }
}

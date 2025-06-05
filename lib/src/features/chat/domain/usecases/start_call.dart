import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_type.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/repo/chat_repo.dart';

class StartCall {
  final ChatRepo _repo;

  StartCall(this._repo);

  Future<void> call({
    required String chatroomId,
    required String callerId,
    required CallType callType,
    required List<String> participants,
  }) async {
    return _repo.startCall(
      chatroomId: chatroomId,
      callerId: callerId,
      callType: callType,
      participants: participants,
    );
  }
}

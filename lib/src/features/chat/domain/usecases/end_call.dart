import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_status.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/repo/chat_repo.dart';

class EndCall {
  final ChatRepo _repo;

  EndCall(this._repo);

  Future<void> call({
    required String chatroomId,
    required String callId,
    required CallStatus callStatus,
  }
  ) async {
    return _repo.endCall(
      chatroomId: chatroomId,
      callId: callId,
      status: callStatus,
    );
  }
}

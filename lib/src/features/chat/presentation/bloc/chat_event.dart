part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  // Message Events
  const factory ChatEvent.loadMessages(String chatroomId) = _LoadMessages;
  const factory ChatEvent.loadMoreMessages(String chatroomId) =
      _LoadMoreMessages;
  const factory ChatEvent.messageReceived(MessageEntity message) =
      _MessageReceived;
  const factory ChatEvent.sendTextMessage({
    required String chatroomId,
    required String senderId,
    required String text,
  }) = _SendTextMessage;
  const factory ChatEvent.sendImageMessage({
    required String chatroomId,
    required String senderId,
    required List<String> imagePaths,
  }) = _SendImageMessage;

  // Call Events
  const factory ChatEvent.startCall({
    required String chatroomId,
    required CallType callType,
  }) = _StartCall;
  const factory ChatEvent.endCall({
    required String chatroomId,
    required String callId,
    required CallStatus callStatus,
  }) = _EndCall;

  // Status Events
  const factory ChatEvent.messageSeen(String messageId) = _MessageSeen;
  const factory ChatEvent.typingStarted(String chatroomId) = _TypingStarted;
  const factory ChatEvent.typingEnded(String chatroomId) = _TypingEnded;
}

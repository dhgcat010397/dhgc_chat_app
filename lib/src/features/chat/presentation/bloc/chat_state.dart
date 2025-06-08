part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = _Initial;
  const factory ChatState.loading() = _Loading;
  const factory ChatState.loaded({
    required List<MessageEntity> messages,
    @Default(false) bool isTyping,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMoreMessages,
    CallEntity? ongoingCall,
    String? errorMessage, // For general errors
    String? loadMoreError, // Specific to pagination errors
  }) = _Loaded;
  const factory ChatState.error({
    String? code,
    String? message,
    StackTrace? stackTrace,
  }) = _Error;

  // Call-specific states
  const factory ChatState.callInProgress(CallEntity call) = _CallInProgress;
  const factory ChatState.callEnded(CallEntity call) = _CallEnded;
}

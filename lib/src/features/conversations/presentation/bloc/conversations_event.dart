part of "conversations_bloc.dart";

@freezed
abstract class ConversationsEvent with _$ConversationsEvent {
  const factory ConversationsEvent.loadConversations(String uid) =
      _LoadConversations;
  const factory ConversationsEvent.loadMoreConversations(String uid) =
      _LoadMoreConversations;
  const factory ConversationsEvent.searchConversations({
    required String uid,
    required String query,
  }) = _SearchConversations;
  const factory ConversationsEvent.loadingMoreSearchConversations({
    required String uid,
    required String query,
  }) = _LoadMoreSearchConversations;
  const factory ConversationsEvent.createNewConversation({
    required String uid,
    required List<String> participants,
  }) = _CreateNewConversation;
  const factory ConversationsEvent.updateConversation(
    ConversationEntity conversation,
  ) = _UpdateConversation;
  const factory ConversationsEvent.deleteConversation(String conversationId) =
      _DeleteConversation;
  const factory ConversationsEvent.resetSearch() = _ResetSearch;
}

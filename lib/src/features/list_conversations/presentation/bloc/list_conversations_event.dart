part of "list_conversations_bloc.dart";

@freezed
abstract class ListConversationsEvent with _$ListConversationsEvent {
  const factory ListConversationsEvent.loadConversations(String uid) =
      LoadConversations;
  const factory ListConversationsEvent.loadMoreConversations(String uid) =
      LoadMoreConversations;
  const factory ListConversationsEvent.searchConversations(String query) =
      SearchConversations;
  const factory ListConversationsEvent.createNewConversation({
    required UserEntity currentUser,
    required String receiverUsername,
  }) = CreateNewConversation;
  const factory ListConversationsEvent.deleteConversation({
    required String conversationId,
    required UserEntity currentUser,
  }) = DeleteConversation;
}

part of "list_conversations_bloc.dart";

@freezed
abstract class ListConversationsEvent with _$ListConversationsEvent {
  const factory ListConversationsEvent.fetchData() = _FetchData;
  const factory ListConversationsEvent.detail(int conversationId) = _ConversationDetail;
  const factory ListConversationsEvent.filterByReceiverName(String query) =
      _FilterByReceiverName;
  const factory ListConversationsEvent.create({
    required String ownerId,
    required String receiverUid,
  }) = _CreateConversation;
  const factory ListConversationsEvent.delete(int conversationId) = _DeleteConversation;
}

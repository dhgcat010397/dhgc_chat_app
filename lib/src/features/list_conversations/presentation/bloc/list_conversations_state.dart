part of "list_conversations_bloc.dart";

@freezed
abstract class ListConversationsState with _$ListConversationsState {
  const factory ListConversationsState.initial() = _Initial;
  const factory ListConversationsState.loading() = _Loading;
  const factory ListConversationsState.loaded({
    required List<ConversationEntity> conversations,
    required bool hasReachedMax,
  }) = _Loaded;
  const factory ListConversationsState.loadingMore({
    required List<ConversationEntity> conversations,
    required bool hasReachedMax,
  }) = _LoadingMore;
  const factory ListConversationsState.searchResults(
    List<ConversationEntity> conversations,
  ) = _SearchResults;
  const factory ListConversationsState.conversationCreated(
    ConversationEntity conversation,
  ) = _ConversationCreated;
  const factory ListConversationsState.conversationDeleted({
    required String conversationId,
    required List<ConversationEntity> conversations,
  }) = _ConversationDeleted;
  const factory ListConversationsState.error({
    required int code,
    required String message,
  }) = _Error;
}

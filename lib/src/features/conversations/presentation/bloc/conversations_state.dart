part of "conversations_bloc.dart";

@freezed
abstract class ConversationsState with _$ConversationsState {
  const factory ConversationsState.initial() = _Initial;
  const factory ConversationsState.loading() = _Loading;
  const factory ConversationsState.loaded({
    required List<ConversationEntity> conversations,
    required bool hasReachedMax,
    required DocumentSnapshot? lastDocument,
  }) = _Loaded;
  const factory ConversationsState.loadingMore({
    required List<ConversationEntity> conversations,
    required bool hasReachedMax,
    required DocumentSnapshot? lastDocument,
  }) = _LoadingMore;
  const factory ConversationsState.searchResults({
    required List<ConversationEntity> conversations,
    required bool hasReachedMax,
    DocumentSnapshot? lastDocument,
  }) = _SearchResults;
  const factory ConversationsState.conversationCreated(
    ConversationEntity conversation,
  ) = _ConversationCreated;
  const factory ConversationsState.conversationDeleted({
    required String conversationId,
    required List<ConversationEntity> conversations,
  }) = _ConversationDeleted;
  const factory ConversationsState.error({
    String? code,
    String? message,
    StackTrace? stackTrace,
  }) = _Error;
}

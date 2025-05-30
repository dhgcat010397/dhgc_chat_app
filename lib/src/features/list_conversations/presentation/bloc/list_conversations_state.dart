part of "list_conversations_bloc.dart";

@freezed
abstract class ListConversationsState with _$ListConversationsState {
  const factory ListConversationsState.initial() = _Initial;
  const factory ListConversationsState.loading() = _Loading;
  const factory ListConversationsState.loaded({
    @Default([]) List<ConversationEntity> conversationsList,
    @Default(null) ConversationEntity? conversationDetail,
    @Default(false) bool isCreated,
    @Default(false) bool isDeleted,
  }) = _Loaded;
  const factory ListConversationsState.error({
    required int errorCode,
    required String errorMessage,
  }) = _Error;
}

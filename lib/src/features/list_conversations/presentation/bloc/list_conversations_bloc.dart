import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:dhgc_chat_app/src/features/list_conversations/domain/entities/conversation_entity.dart';

part "list_conversations_state.dart";
part "list_conversations_event.dart";

part 'list_conversations_bloc.freezed.dart'; // run: flutter pub run build_runner build --delete-conflicting-outputs

class ListConversationsBloc extends Bloc<ListConversationsEvent, ListConversationsState> {
  // final GetConversationsListUsecase getConversationsListUseCase;
  // final GetConversationDetailUsecase getConversationDetailUseCase;
  // final FilterConversationsByReceiverNameUsecase filterConversationsByReceiverNameUseCase;
  // final CreateConversationUsecase createConversationUseCase;
  // final DeleteConversationUsecase deleteConversationUseCase;

  List<ConversationEntity> _conversationsList = [];
  String _cleanedQuery = "";

  ListConversationsBloc(
    // {
    // required this.getConversationsListUseCase,
    // required this.getConversationDetailUseCase,
    // required this.filterConversationsByReceiverNameUseCase,
    // required this.createConversationUseCase,
    // required this.deleteConversationUseCase,
    //}
  ) : super(const _Initial()) {
    // on<ListConversationsEvent>(
    //   (event, emit) => event.map(
        // fetchData: (event) => _onFetchData(emit),
        // detail: (event) => _onGetConversationDetail(event.conversationId, emit),
        // filterByReceiverName: (event) => _onFilterByReceiverName(event.query, emit),
        // create: (event) => _onCreateConversation(event.uid, event.receiverUid, emit),
        // delete: (event) => _onDeleteConversation(event.conversationId, emit),
    //   ),
    // );
  }
}
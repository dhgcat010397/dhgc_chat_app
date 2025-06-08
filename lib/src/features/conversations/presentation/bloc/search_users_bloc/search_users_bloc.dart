import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dhgc_chat_app/src/core/utils/enums/search_type.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';

part "search_users_state.dart";
part "search_users_event.dart";

part 'search_users_bloc.freezed.dart'; // run: flutter pub run build_runner build --delete-conflicting-outputs

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  // final GetConversationsListUsecase getConversationsListUseCase;
  // final GetConversationDetailUsecase getConversationDetailUseCase;
  // final FilterConversationsByReceiverNameUsecase filterConversationsByReceiverNameUseCase;
  // final CreateConversationUsecase createConversationUseCase;
  // final DeleteConversationUsecase deleteConversationUseCase;

  List<UserEntity> _users = [];
  String _cleanedQuery = "";

  SearchUsersBloc(
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

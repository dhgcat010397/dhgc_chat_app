import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/conversation_entity.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/usecases/create_conversation.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/usecases/load_conversations.dart';

part "conversations_state.dart";
part "conversations_event.dart";

part 'conversations_bloc.freezed.dart'; // run: flutter pub run build_runner build --delete-conflicting-outputs

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final LoadConversations _loadConversations;
  final CreateConversation _createConversation;
  final int _limit = 30; // Number of conversations to load per batch
  DocumentSnapshot? _lastDocument;
  bool _hasReachedMax = false;
  List<ConversationEntity> _allConversations = [];

  ConversationsBloc({
    required LoadConversations loadConversations,
    required CreateConversation createConversation,
  }) : _loadConversations = loadConversations,
       _createConversation = createConversation,
       super(const _Initial()) {
    on<ConversationsEvent>(
      (event, emit) => event.map(
        loadConversations: (event) => _onLoadConversations(event, emit),
        loadMoreConversations: (event) => _onLoadMoreConversations(event, emit),
        searchConversations: (event) => _onSearchConversations(event, emit),
        createNewConversation: (event) => _onCreateNewConversation(event, emit),
        deleteConversation: (event) => _onDeleteConversation(event, emit),
        resetSearch: (event) => _onResetSearch(event, emit),
      ),
    );
  }

  Future<void> _onLoadConversations(
    _LoadConversations event,
    Emitter<ConversationsState> emit,
  ) async {
    try {
      emit(const ConversationsState.loading());
      _lastDocument = null;
      _hasReachedMax = false;

      final result = await _loadConversations.call(
        uid: event.uid,
        limit: _limit,
        lastDocument: _lastDocument,
      );

      _allConversations = result.conversations;
      _lastDocument = result.lastDocument;
      _hasReachedMax = !result.hasMore;

      emit(
        ConversationsState.loaded(
          conversations: _allConversations,
          hasReachedMax: _hasReachedMax,
          lastDocument: _lastDocument,
        ),
      );
    } catch (e, stackTrace) {
      emit(
        ConversationsState.error(
          code: 500.toString(),
          message: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<void> _onLoadMoreConversations(
    _LoadMoreConversations event,
    Emitter<ConversationsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! _Loaded || _hasReachedMax) return;

    emit(
      ConversationsState.loadingMore(
        conversations: _allConversations,
        hasReachedMax: _hasReachedMax,
        lastDocument: _lastDocument,
      ),
    );

    try {
      final result = await _loadConversations.call(
        uid: event.uid,
        limit: _limit,
        lastDocument: _lastDocument,
      );

      if (result.conversations.isEmpty) {
        _hasReachedMax = true;
      } else {
        _allConversations.addAll(result.conversations);
        _lastDocument = result.lastDocument;
        _hasReachedMax = !result.hasMore;
      }

      emit(
        ConversationsState.loaded(
          conversations: _allConversations,
          hasReachedMax: _hasReachedMax,
          lastDocument: _lastDocument,
        ),
      );
    } catch (e, stackTrace) {
      emit(
        ConversationsState.error(
          code: 500.toString(),
          message: e.toString(),
          stackTrace: stackTrace,
        ),
      );
      emit(currentState); // Revert to previous state
    }
  }

  Future<void> _onSearchConversations(
    _SearchConversations event,
    Emitter<ConversationsState> emit,
  ) async {
    //   if (event.query.isEmpty) {
    //     add(const _ResetSearch());
    //     return;
    //   }

    //   try {
    //     final currentState = state;
    //     if (currentState is! _Loaded && currentState is! _LoadingMore) return;

    //     final results = await _useCases.searchConversations(query: event.query);
    //     emit(ConversationsState.searchResults(results));
    //   } catch (e, stackTrace) {
    //     emit(
    //       ConversationsState.error(
    //         code: 500.toString(),
    //         message: e.toString(),
    //         stackTrace: stackTrace,
    //       ),
    //     );
    //   }
  }

  Future<void> _onCreateNewConversation(
    _CreateNewConversation event,
    Emitter<ConversationsState> emit,
  ) async {
    //   try {
    //     final currentState = state;
    //     if (currentState is! _Loaded && currentState is! _LoadingMore) return;

    //     emit(const ConversationsState.loading());

    //     final newConversation = await _useCases.createConversation(
    //       currentUser: event.currentUser,
    //       receiverUsername: event.receiverUsername,
    //     );

    //     emit(ConversationsState.conversationCreated(newConversation));

    //     // Reload conversations to include the new one
    //     add(_LoadConversations(event.currentUser.id));
    //   } catch (e, stackTrace) {
    //     emit(
    //       ConversationsState.error(
    //         code: 500.toString(),
    //         message: e.toString(),
    //         stackTrace: stackTrace,
    //       ),
    //     );
    //   }
  }

  Future<void> _onDeleteConversation(
    _DeleteConversation event,
    Emitter<ConversationsState> emit,
  ) async {
    // try {
    //   final currentState = state;
    //   if (currentState is! _Loaded && currentState is! _LoadingMore) return;

    //   await _useCases.deleteConversation(event.conversationId);

    //   final updatedConversations =
    //       _allConversations
    //           .where((conv) => conv.id != event.conversationId)
    //           .toList();

    //   _allConversations = updatedConversations;

    //   emit(
    //     ConversationsState.conversationDeleted(
    //       conversationId: event.conversationId,
    //       conversations: updatedConversations,
    //     ),
    //   );
    // } catch (e, stackTrace) {
    //   emit(
    //     ConversationsState.error(
    //       code: 500.toString(),
    //       message: e.toString(),
    //       stackTrace: stackTrace,
    //     ),
    //   );
    // }
  }

  Future<void> _onResetSearch(
    _ResetSearch event,
    Emitter<ConversationsState> emit,
  ) async {
    // if (_allConversations.isNotEmpty) {
    //   emit(
    //     ConversationsState.loaded(
    //       conversations: _allConversations,
    //       hasReachedMax: _hasReachedMax,
    //       lastDocument: _lastDocument,
    //     ),
    //   );
    // } else {
    //   add(_LoadConversations(widget.user.id));
    // }
  }
}

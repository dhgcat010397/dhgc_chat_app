import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:dhgc_chat_app/src/shared/domain/usecases/search_users_by_name.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';

part 'search_users_event.dart';
part 'search_users_state.dart';
part 'search_users_bloc.freezed.dart';

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  final SearchUsersByName _searchUsersByName;
  String _currentQuery = '';
  DocumentSnapshot? _lastDocument;
  List<UserEntity> _currentUsers = [];

  SearchUsersBloc({required SearchUsersByName searchUsersByName})
    : _searchUsersByName = searchUsersByName,
      super(const SearchUsersState.initial()) {
    on<SearchUsersEvent>(
      (event, emit) => event.map(
        search: (event) => _onSearch(event, emit),
        loadMore: (event) => _onLoadMore(event, emit),
        clear: (event) => _onClear(event, emit),
      ),
    );
  }

  Future<void> _onSearch(_Search event, Emitter<SearchUsersState> emit) async {
    _currentQuery = event.query.trim();
    _lastDocument = null;
    _currentUsers = [];

    // Don't search if query is empty
    if (_currentQuery.isEmpty) {
      emit(const SearchUsersState.initial());
      return;
    }

    emit(const SearchUsersState.loading());

    try {
      final result = await _searchUsersByName.call(_currentQuery);
      _currentUsers = result.users;
      _lastDocument = result.lastDocument;

      if (_currentUsers.isEmpty) {
        emit(const SearchUsersState.empty());
      } else {
        emit(
          SearchUsersState.success(
            users: _currentUsers,
            hasReachedMax: result.hasReachedMax,
          ),
        );
      }
    } catch (e) {
      emit(
        SearchUsersState.error(
          message: e.toString(),
          currentUsers: _currentUsers,
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    _LoadMoreResults event,
    Emitter<SearchUsersState> emit,
  ) async {
    final currentState = state;

    if (currentState is! _Success || currentState.hasReachedMax) {
      // Don't load more if we're not in success state or already reached max
      return;
    }

    emit(SearchUsersState.loadMore(users: _currentUsers));

    try {
      final result = await _searchUsersByName.call(
        _currentQuery,
        lastDocument: _lastDocument,
      );

      _currentUsers.addAll(result.users);
      _lastDocument = result.lastDocument;

      if (result.users.isEmpty) {
        emit(
          SearchUsersState.success(users: _currentUsers, hasReachedMax: true),
        );
      } else {
        emit(
          SearchUsersState.success(
            users: _currentUsers,
            hasReachedMax: result.hasReachedMax,
          ),
        );
      }
    } catch (e) {
      emit(
        SearchUsersState.error(
          message: e.toString(),
          currentUsers: _currentUsers,
        ),
      );
    }
  }

  void _onClear(_Clear event, Emitter<SearchUsersState> emit) {
    _currentQuery = '';
    _lastDocument = null;
    _currentUsers = [];
    emit(const SearchUsersState.initial());
  }
}

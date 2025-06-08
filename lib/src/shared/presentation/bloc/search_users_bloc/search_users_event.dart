part of 'search_users_bloc.dart';

@freezed
class SearchUsersEvent with _$SearchUsersEvent {
  const factory SearchUsersEvent.search(String query) = _Search;
  const factory SearchUsersEvent.loadMore() = _LoadMoreResults;
  const factory SearchUsersEvent.clear() = _Clear;
}

part of "search_users_bloc.dart";

@freezed
abstract class SearchUsersEvent with _$SearchUsersEvent {
  const factory SearchUsersEvent.search({
    required SearchType searchType,
    @Default("") String query,
  }) = _Search;
}

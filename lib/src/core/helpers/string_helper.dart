String cleanedQuery(String query) {
  return query.trim().replaceAll(RegExp(r'\s+'), ' ');
}

abstract class AppRoutes {
  static const String home = '/home';
  static const String noteDetail = '/note/detail';

  // Helper method to pass params
  static String getNoteDetailPath(int id) => '/note/$id';
}

abstract class AppRoutes {
  static const String auth = '/auth';
  static const String home = '/home';
  static const String chat = '/conversation/detail';

  // Helper method to pass params
  static String getConversationDetailPath(int id) => '/conversation/$id';
}

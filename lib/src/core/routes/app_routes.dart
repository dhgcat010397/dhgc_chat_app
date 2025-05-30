abstract class AppRoutes {
  static const String home = '/home';
  static const String conversationDetail = '/conversation/detail';

  // Helper method to pass params
  static String getConversationDetailPath(int id) => '/conversation/$id';
}

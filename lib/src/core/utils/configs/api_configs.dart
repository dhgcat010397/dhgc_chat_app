class ApiConfigs {
  ApiConfigs._(); // Private constructor to prevent instantiation

  /// Base URL for the API
  static late final String baseUrl;
  static late final String apiKey;
  static late final String imageBaseUrl;
  static late final String apiVersion;

  /// Google API Keys
  static late final String fcmServerKey;
  static final String fcm = 'https://fcm.googleapis.com/fcm/send';
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dhgc_chat_app/src/core/utils/configs/api_configs.dart';

class PushNotificationHelper {
  final String serverKey;

  PushNotificationHelper({required this.serverKey});

  Future<void> sendPushNotification({
    required String toToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final url = Uri.parse(ApiConfigs.fcm);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final payload = {
      'to': toToken,
      'notification': {'title': title, 'body': body},
      if (data != null) 'data': data,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send push notification: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error sending push notification: $e');
    }
  }
}

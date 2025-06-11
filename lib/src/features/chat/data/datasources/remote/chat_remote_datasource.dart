import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_status.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_type.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_entity.dart';

abstract class ChatRemoteDatasource {
  // Messages
  Stream<List<MessageEntity>> getMessages(String chatroomId, [int limit = 30]);
  Future<List<MessageEntity>> getMoreMessages({
    required String chatroomId,
    required DateTime beforeTimestamp,
    int limit = 20, // Optional pagination limit
  });
  Future<void> sendTextMessage({
    required String chatroomId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String text,
  });
  Future<void> sendImageMessage({
    required String chatroomId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required List<String> imagePaths,
  });
  Future<void> markMessageAsSeen(String messageId);

  // Calls
  Future<void> startCall({
    required String chatroomId,
    required String callerId,
    required CallType callType,
    required List<String> participants,
  });
  Future<void> endCall({
    required String chatroomId,
    required String callId,
    required CallStatus status,
  });

  // Chatrooms
  Future<void> deleteChatroom(String chatroomId);
}

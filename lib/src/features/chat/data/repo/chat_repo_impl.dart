import 'package:dhgc_chat_app/src/features/chat/data/datasources/remote/chat_remote_datasource.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_status.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_type.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_entity.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/repo/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  final ChatRemoteDatasource remoteDatasource;

  ChatRepoImpl({required this.remoteDatasource});

  @override
  Stream<List<MessageEntity>> getMessages(String chatroomId, [int limit = 30]) {
    return remoteDatasource.getMessages(chatroomId, limit);
  }

  @override
  Future<List<MessageEntity>> getMoreMessages({
    required String chatroomId,
    required DateTime beforeTimestamp,
    int limit = 20, // Optional pagination limit
  }) async {
    return await remoteDatasource.getMoreMessages(
      chatroomId: chatroomId,
      beforeTimestamp: beforeTimestamp,
      limit: limit,
    );
  }

  @override
  Future<void> sendTextMessage({
    required String chatroomId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String text,
  }) async {
    await remoteDatasource.sendTextMessage(
      chatroomId: chatroomId,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      text: text,
    );
  }

  @override
  Future<void> sendImageMessage({
    required String chatroomId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required List<String> imagePaths,
  }) async {
    await remoteDatasource.sendImageMessage(
      chatroomId: chatroomId,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      imagePaths: imagePaths,
    );
  }

  @override
  Future<void> startCall({
    required String chatroomId,
    required String callerId,
    required CallType callType,
    required List<String> participants,
  }) async {
    await remoteDatasource.startCall(
      chatroomId: chatroomId,
      callerId: callerId,
      callType: callType,
      participants: participants,
    );
  }

  @override
  Future<void> endCall({
    required String chatroomId,
    required String callId,
    required CallStatus status,
  }) async {
    await remoteDatasource.endCall(
      chatroomId: chatroomId,
      callId: callId,
      status: status,
    );
  }

  @override
  Future<void> deleteChatroom(String chatroomId) async {
    await remoteDatasource.deleteChatroom(chatroomId);
  }

  @override
  Future<void> markMessageAsSeen(String messageId) async {
    await remoteDatasource.markMessageAsSeen(messageId);
  }
}

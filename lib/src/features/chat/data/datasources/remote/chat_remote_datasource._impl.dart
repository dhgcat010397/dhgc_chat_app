import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dhgc_chat_app/src/core/services/firestore_service.dart';
import 'package:dhgc_chat_app/src/core/services/fstorage_service.dart';
import 'package:dhgc_chat_app/src/core/utils/constants/firestore_constants.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_status.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_type.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_type.dart';
import 'package:dhgc_chat_app/src/features/chat/data/models/message_model.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_entity.dart';
import 'package:dhgc_chat_app/src/features/chat/data/datasources/remote/chat_remote_datasource.dart';

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final FirestoreService _firestoreService;
  final FStorageService _storageService;
  final Uuid _uuid;

  ChatRemoteDatasourceImpl({
    required FirestoreService firestoreService,
    required FStorageService storageService,
    Uuid? uuid,
  }) : _firestoreService = firestoreService,
       _storageService = storageService,
       _uuid = uuid ?? const Uuid();

  @override
  Stream<List<MessageEntity>> getMessages(String chatroomId, [int limit = 30]) {
    try {
      return _firestoreService
          .streamSubcollection(
            collection: FirestoreConstants.conversations,
            docId: chatroomId,
            subcollection: FirestoreConstants.messages,
            queryBuilder:
                (query) =>
                    query.orderBy('timestamp', descending: true).limit(30),
          )
          .map(
            (snapshot) =>
                snapshot.docs
                    .map(
                      (doc) =>
                          MessageModel.fromJson(
                            doc.data() as Map<String, dynamic>,
                          ).toEntity(),
                    )
                    .toList(),
          );
    } on FirestoreFailure catch (e, stack) {
      return Stream.error(e, stack);
    } catch (e, stack) {
      return Stream.error(e, stack);
    }
  }

  @override
  Future<List<MessageEntity>> getMoreMessages({
    required String chatroomId,
    required DateTime beforeTimestamp,
    int limit = 20,
  }) async {
    try {
      final snapshot = await _firestoreService.getSubcollection(
        collection: FirestoreConstants.conversations,
        docId: chatroomId,
        subcollection: FirestoreConstants.messages,
        queryBuilder:
            (query) => query
                .orderBy('timestamp', descending: true)
                .where('timestamp', isLessThan: beforeTimestamp)
                .limit(limit),
      );
      return snapshot.docs
          .map(
            (doc) =>
                MessageModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                ).toEntity(),
          )
          .toList();
    } on FirestoreFailure catch (e, stackTrace) {
      throw ChatRemoteDatasourceException(
        code: 'MESSAGE_CREATION_FAILED',
        message: 'Failed to create message: ${e.message}',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> sendTextMessage({
    required String chatroomId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String text,
  }) async {
    try {
      final messageId = _uuid.v4();
      await _firestoreService.updateDocument(
        collection: FirestoreConstants.conversations,
        docId: chatroomId,
        updates: {
          'lastMessage': text,
          'lastMessageTime': FieldValue.serverTimestamp(),
          'lastMessageType': MessageType.text.name,
        },
      );
      
      await _firestoreService.addSubcollectionDocument(
        collection: FirestoreConstants.conversations,
        docId: chatroomId,
        subcollection: FirestoreConstants.messages,
        data: {
          'messageId': messageId,
          'senderId': senderId,
          'senderName': senderName,
          'senderAvatar': senderAvatar,
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
          'type': MessageType.text.name,
          'isSeen': false,
        },
      );
    } on FirestoreFailure catch (e, stackTrace) {
      throw ChatRemoteDatasourceException(
        code: 'MESSAGE_CREATION_FAILED',
        message: 'Failed to create message: ${e.message}',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> sendImageMessage({
    required String chatroomId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required List<String> imagePaths,
  }) async {
    final messageId = _uuid.v4();
    final List<String> imageUrls = [];
    List<String> uploadedUrls = []; // Track successfully uploaded files

    try {
      // ===== 1. Upload Images to Storage =====
      for (final path in imagePaths) {
        try {
          final url = await _storageService.uploadFile(
            path: 'chat_images/$chatroomId/$messageId/${path.split('/').last}',
            file: File(path),
          );
          imageUrls.add(url);
          uploadedUrls.add(url); // Track successful uploads
        } on StorageFailure catch (e, trackTrace) {
          throw ChatRemoteDatasourceException(
            code: 'IMAGE_UPLOAD_FAILED',
            message: 'Failed to upload image: ${e.message}',
            stackTrace: trackTrace,
          );
        }
      }

      await _firestoreService.setDocument(
        collection: FirestoreConstants.conversations,
        docId: chatroomId,
        data: {
          'lastMessage': '📷 ${imageUrls.length} image(s)',
          'lastMessageTime': FieldValue.serverTimestamp(),
          'lastMessageType': MessageType.image.name,
        },
      );
      await _firestoreService.addSubcollectionDocument(
        collection: FirestoreConstants.conversations,
        docId: chatroomId,
        subcollection: FirestoreConstants.messages,
        data: {
          'messageId': messageId,
          'senderId': senderId,
          'senderName': senderName,
          'senderAvatar': senderAvatar,
          'imageUrls': imageUrls,
          'timestamp': FieldValue.serverTimestamp(),
          'type': MessageType.image.name,
          'isSeen': false,
        },
      );
    } on FirestoreFailure catch (e, stackTrace) {
      // Rollback: Delete uploaded images if Firestore fails
      if (uploadedUrls.isNotEmpty) {
        await _storageService.deleteFiles(uploadedUrls).catchError((_) {});
      }
      throw ChatRemoteDatasourceException(
        code: 'MESSAGE_CREATION_FAILED',
        message: 'Failed to create message: ${e.message}',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> startCall({
    required String chatroomId,
    required String callerId,
    required CallType callType,
    required List<String> participants,
  }) async {
    try {
      // ===== 1. Create Call Document =====
      final callId = _uuid.v4();
      final callData = {
        'callId': callId,
        'callerId': callerId,
        'callType': callType.name,
        'participants': participants,
        'startTime': FieldValue.serverTimestamp(),
        'status': CallStatus.calling.name,
      };

      await _firestoreService.setDocument(
        collection: 'calls',
        docId: callId,
        data: callData,
      );

      // ===== 2. Update Chatroom with Ongoing Call =====
      await _firestoreService.updateDocument(
        collection: FirestoreConstants.conversations,
        docId: chatroomId,
        updates: {'ongoingCall': callData},
      );

      // ===== 3. Add System Message =====
      await _firestoreService.addSubcollectionDocument(
        collection: FirestoreConstants.conversations,
        docId: chatroomId,
        subcollection: FirestoreConstants.messages,
        data: {
          'messageId': _uuid.v4(),
          'senderId': 'system',
          'text':
              '${callType == CallType.voice ? 'Voice' : 'Video'} call started',
          'timestamp': FieldValue.serverTimestamp(),
          'type': MessageType.system.name,
          'isSeen': true,
          'callId': callId,
        },
      );
    } on FirestoreFailure catch (e, stackTrace) {
      throw ChatRemoteDatasourceException(
        code: 'CALL_START_FAILED',
        message: 'Failed to start call: ${e.message}',
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw ChatRemoteDatasourceException(
        code: 'UNKNOWN_ERROR',
        message: 'Unexpected error starting call: ${e.toString()}',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> endCall({
    required String chatroomId,
    required String callId,
    required CallStatus status,
  }) async {
    try {
      // ===== 1. Update Call Document =====
      await _firestoreService.updateDocument(
        collection: 'calls',
        docId: callId,
        updates: {
          'endTime': FieldValue.serverTimestamp(),
          'status': status.name,
          'duration': FieldValue.increment(
            DateTime.now().millisecondsSinceEpoch,
          ),
        },
      );

      // ===== 2. Clear Ongoing Call in Chatroom =====
      await _firestoreService.updateDocument(
        collection: FirestoreConstants.conversations,
        docId: chatroomId,
        updates: {'ongoingCall': FieldValue.delete()},
      );

      // ===== 3. Add System Message =====
      final statusText =
          status == CallStatus.missed
              ? 'Missed call'
              : status == CallStatus.rejected
              ? 'Call rejected'
              : 'Call ended';

      await _firestoreService.addSubcollectionDocument(
        collection: FirestoreConstants.conversations,
        docId: chatroomId,
        subcollection: FirestoreConstants.messages,
        data: {
          'messageId': _uuid.v4(),
          'senderId': 'system',
          'text': statusText,
          'timestamp': FieldValue.serverTimestamp(),
          'type': MessageType.system.name,
          'isSeen': true,
          'callId': callId,
        },
      );
    } on FirestoreFailure catch (e, stackTrace) {
      throw ChatRemoteDatasourceException(
        code: 'CALL_END_FAILED',
        message: 'Failed to end call: ${e.message}',
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw ChatRemoteDatasourceException(
        code: 'UNKNOWN_ERROR',
        message: 'Unexpected error ending call: ${e.toString()}',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> deleteChatroom(String chatroomId) async {
    try {
      // Delete all messages in the subcollection
      final messagesSnapshot = await _firestoreService.getSubcollection(
        collection: FirestoreConstants.conversations,
        docId: chatroomId,
        subcollection: FirestoreConstants.messages,
      );
      for (final doc in messagesSnapshot.docs) {
        await _firestoreService.deleteSubcollectionDocument(
          collection: FirestoreConstants.conversations,
          docId: chatroomId,
          subcollection: FirestoreConstants.messages,
          subDocId: doc.id,
        );
      }

      // Delete the chatroom document itself
      await _firestoreService.deleteDocument(
        collection: FirestoreConstants.conversations,
        docId: chatroomId,
      );

      // Optionally: delete any associated storage (e.g., images)
      await _storageService.deleteFolder('chat_images/$chatroomId');
    } on FirestoreFailure catch (e, stackTrace) {
      throw ChatRemoteDatasourceException(
        code: 'CHATROOM_DELETE_FAILED',
        message: 'Failed to delete chatroom: ${e.message}',
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw ChatRemoteDatasourceException(
        code: 'UNKNOWN_ERROR',
        message: 'Unexpected error deleting chatroom: ${e.toString()}',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> markMessageAsSeen(String messageId) async {
    try {
      // Find the chatroom containing the message
      final chatrooms = await _firestoreService.getCollection(
        path: FirestoreConstants.conversations,
      );
      for (final chatroom in chatrooms.docs) {
        final chatroomId = chatroom.id;
        final messages = await _firestoreService.getSubcollection(
          collection: FirestoreConstants.conversations,
          docId: chatroomId,
          subcollection: FirestoreConstants.messages,
        );
        for (final message in messages.docs) {
          if (message['messageId'] == messageId) {
            await _firestoreService.updateSubcollectionDocument(
              collection: FirestoreConstants.conversations,
              docId: chatroomId,
              subcollection: FirestoreConstants.messages,
              subDocId: message.id,
              updates: {'isSeen': true},
            );
            return;
          }
        }
      }
      throw ChatRemoteDatasourceException(
        code: 'MESSAGE_NOT_FOUND',
        message: 'Message with ID $messageId not found.',
        stackTrace: StackTrace.current,
      );
    } on FirestoreFailure catch (e, stackTrace) {
      throw ChatRemoteDatasourceException(
        code: 'MARK_SEEN_FAILED',
        message: 'Failed to mark message as seen: ${e.message}',
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw ChatRemoteDatasourceException(
        code: 'UNKNOWN_ERROR',
        message: 'Unexpected error marking message as seen: ${e.toString()}',
        stackTrace: stackTrace,
      );
    }
  }
}

class ChatRemoteDatasourceException implements Exception {
  final String code;
  final String message;
  final StackTrace stackTrace;

  ChatRemoteDatasourceException({
    required this.code,
    required this.message,
    required this.stackTrace,
  });

  @override
  String toString() => '[$code] $message';
}

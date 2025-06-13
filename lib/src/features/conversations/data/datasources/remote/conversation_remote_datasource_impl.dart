import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_type.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dhgc_chat_app/src/core/services/firestore_service.dart';
import 'package:dhgc_chat_app/src/core/utils/constants/firestore_constants.dart';
import 'package:dhgc_chat_app/src/core/utils/enums/search_type.dart';
import 'package:dhgc_chat_app/src/features/chat/data/datasources/remote/chat_remote_datasource.dart';
import 'package:dhgc_chat_app/src/features/conversations/data/datasources/remote/conversation_remote_datasource.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/conversation_entity.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/paginated_conversations.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/remote/user_remote_datasource.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/group_users_entity.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_status.dart';

class ConversationRemoteDatasourceImpl implements ConversationRemoteDatasource {
  final FirestoreService _firestoreService;
  final ChatRemoteDatasource _chatRemoteDatasource;
  final UserRemoteDatasource _userRemoteDatasource;

  ConversationRemoteDatasourceImpl({
    required FirestoreService firestoreService,
    required ChatRemoteDatasource chatRemoteDatasource,
    required UserRemoteDatasource userRemoteDatasource,
  }) : _firestoreService = firestoreService,
       _chatRemoteDatasource = chatRemoteDatasource,
       _userRemoteDatasource = userRemoteDatasource;

  @override
  Future<PaginatedConversations> getConversations({
    required String uid,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      final querySnapshot = await _firestoreService.getCollection(
        path: FirestoreConstants.conversations,
        queryBuilder: (Query query) {
          query = query
              .where('participants', arrayContains: uid)
              .orderBy('lastMessageTime', descending: true)
              .limit(limit);

          if (lastDocument != null) {
            query = query.startAfterDocument(lastDocument);
          }
          return query;
        },
      );

      // If there is no conversations yet
      if (querySnapshot.docs.isEmpty) {
        return PaginatedConversations(
          conversations: [],
          lastDocument: null,
          hasMore: false,
        );
      }

      // Process documents
      final conversations =
          querySnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final isGroup = data['isGroup'] ?? false;
            return ConversationEntity(
              id: doc.id,
              uid: isGroup ? null : data['uid'],
              name: isGroup ? null : data['name'],
              avatar: isGroup ? null : data['avatar'],
              participants: List<String>.from(data['participants'] ?? []),
              lastMessage: data['lastMessage'] ?? '',
              lastMessageAt: (data['lastMessageTime'] as Timestamp).toDate(),
              lastMessageType: MessageType.values.firstWhere(
                (e) => e.name == data['type'],
                orElse: () => MessageType.text,
              ),
              createdAt: (data['createdAt'] as Timestamp).toDate(),
              groupInfo:
                  isGroup
                      ? GroupUsersEntity(
                        id: doc.id,
                        name: data['groupName'] ?? 'Group Chat',
                        avatar: data['groupAvatar'],
                        admins: List<String>.from(data['admins'] ?? []),
                        createdAt: (data['createdAt'] as Timestamp).toDate(),
                        createdBy: data['createdBy'] ?? '',
                      )
                      : null,
              // Add other conversation fields as needed
            );
          }).toList();

      return PaginatedConversations(
        conversations: conversations,
        lastDocument:
            querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
        hasMore: querySnapshot.docs.length == limit,
      );
    } on FirebaseException catch (e, stackTrace) {
      debugPrint("${e.code}\n${e.message}\n$stackTrace");
      throw ConversationRemoteDatasourceException(
        code: e.code,
        message: e.message ?? 'Firestore operation failed',
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      debugPrint("UNKNOWN_ERROR\n${e.toString()}\n$stackTrace");
      throw ConversationRemoteDatasourceException(
        code: 'UNKNOWN_ERROR',
        message: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<ConversationEntity> createConversation({
    required String uid,
    required List<String> participants,
    String? groupName,
  }) async {
    try {
      // Validate input - now allows 2+ participants
      if (participants.length < 2) {
        throw ConversationRemoteDatasourceException(
          code: 'INVALID_PARTICIPANTS',
          message: 'Conversation must have at least 2 participants',
          stackTrace: StackTrace.current,
        );
      }

      if (!participants.contains(uid)) {
        throw ConversationRemoteDatasourceException(
          code: 'USER_NOT_INCLUDED',
          message: 'Current user must be a participant',
          stackTrace: StackTrace.current,
        );
      }

      // For groups (3+ participants), skip existing conversation check
      final bool isGroup = participants.length > 2;
      ConversationEntity? existingConversation;
      if (!isGroup) {
        existingConversation = await _findExistingConversation(participants);
        if (existingConversation != null) {
          return existingConversation;
        }
      }

      // Get participants details
      final otherParticipants = participants.where((id) => id != uid).toList();
      final participantsInfo = await Future.wait(
        otherParticipants.map((id) => _userRemoteDatasource.getUserInfo(id)),
      );

      if (participantsInfo.any((user) => user == null)) {
        throw ConversationRemoteDatasourceException(
          code: 'USER_NOT_FOUND',
          message: 'One or more participants not found',
          stackTrace: StackTrace.current,
        );
      }

      // Create conversation document
      final conversationId = _firestoreService.getDocId(
        FirestoreConstants.conversations,
      );
      final now = DateTime.now();

      // Build participant data map
      final participantData = <String, dynamic>{};
      for (final participant in participants) {
        participantData[participant] = {
          'hasUnread': participant == uid ? false : true,
          'lastSeen': participant == uid ? Timestamp.fromDate(now) : null,
        };
      }

      final conversationData = {
        'id': conversationId,
        if (!isGroup) ...{
          'uid': participantsInfo.first!.uid,
          'name':
              participantsInfo.first!.displayName ??
              participantsInfo.first!.username,
          'avatar': participantsInfo.first!.imgUrl ?? "",
        },
        'participants': participants,
        'createdAt': Timestamp.fromDate(now),
        'lastMessage': isGroup ? 'Group created' : 'Conversation started',
        'lastMessageTime': Timestamp.fromDate(now),
        'lastMessageType': MessageType.system.name,
        'participantData': participantData,
        'isGroup': isGroup,
        if (isGroup) ...{
          'groupName':
              groupName ??
              getGroupName(participantsInfo.whereType<UserEntity>().toList()),
          'groupAvatar': getGroupAvatar(
            participantsInfo.whereType<UserEntity>().toList(),
          ),
          'createdBy': uid,
          'admins': [uid], // Creator is the first admin
        },
      };

      // Create the conversation document
      await _firestoreService.setDocument(
        collection: FirestoreConstants.conversations,
        docId: conversationId,
        data: conversationData,
      );

      // Add system message
      // await _chatRemoteDatasource.sendTextMessage(
      //   chatroomId: conversationId,
      //   senderId: 'system',
      //   text:
      //       isGroup
      //           ? 'Group created by ${(await _userRemoteDatasource.getUserInfo(uid))?.displayName ?? 'User'}'
      //           : 'Conversation started',
      // );

      // Return the conversation entity
      return ConversationEntity(
        id: conversationId,
        createdAt: now,
        isOnline:
            !isGroup
                ? await _userRemoteDatasource.getStatus(
                      otherParticipants.first,
                    ) ==
                    UserStatus.online
                : false,
        lastMessage: isGroup ? 'Group created' : 'Conversation started',
        lastMessageAt: now,
        lastMessageType: MessageType.system,
        isGroup: isGroup,
        participants: participants,
        groupInfo:
            isGroup
                ? GroupUsersEntity(
                  id: conversationId,
                  name:
                      groupName ??
                      getGroupName(
                        participantsInfo.whereType<UserEntity>().toList(),
                      ),
                  avatar: getGroupAvatar(
                    participantsInfo.whereType<UserEntity>().toList(),
                  ),
                  admins: [uid],
                  createdAt: now,
                  createdBy: uid,
                )
                : null,
      );
    } on FirebaseException catch (e, stackTrace) {
      throw ConversationRemoteDatasourceException(
        code: e.code,
        message: e.message ?? 'Firestore operation failed',
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw ConversationRemoteDatasourceException(
        code: 'UNKNOWN_ERROR',
        message: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> deleteConversation(String chatroomId) {
    throw Exception();
  }

  @override
  Future<void> markAsRead(String chatroomId) {
    throw Exception();
  }

  @override
  Future<void> markAsUnread(String chatroomId) {
    throw Exception();
  }

  /// Search 1:1 conversations by other user's displayName with lazy loading support.
  /// [uid] - current user id
  /// [query] - search string for displayName
  /// [limit] - max results per page
  /// [lastDocument] - last fetched document for pagination
  @override
  Future<PaginatedConversations> searchConversationByName({
    required String uid,
    required String query,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      // 1. Query conversations where current user is a participant
      final querySnapshot = await _firestoreService.getCollection(
        path: FirestoreConstants.conversations,
        queryBuilder: (Query q) {
          q = q
              .where('participants', arrayContains: uid)
              .orderBy('lastMessageTime', descending: true)
              .limit(limit);
          if (lastDocument != null) {
            q = q.startAfterDocument(lastDocument);
          }
          return q;
        },
      );

      final List<ConversationEntity> results = [];
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final isGroup = data['isGroup'] ?? false;

        if (!isGroup) {
          final otherUserId = (data['participants'] as List)
              .cast<String>()
              .firstWhere((id) => id != uid, orElse: () => '');
          if (otherUserId.isEmpty) continue;

          final otherUser = await _userRemoteDatasource.getUserInfo(
            otherUserId,
          );
          final displayName =
              otherUser?.displayName ?? otherUser?.username ?? '';
          if (displayName.toLowerCase().contains(query.toLowerCase())) {
            results.add(
              ConversationEntity(
                id: doc.id,
                uid: otherUserId,
                name: displayName,
                avatar: otherUser?.imgUrl ?? "",
                participants: List<String>.from(data['participants'] ?? []),
                lastMessage: data['lastMessage'] ?? '',
                lastMessageAt: (data['lastMessageTime'] as Timestamp).toDate(),
                lastMessageType: MessageType.values.firstWhere(
                  (e) => e.name == data['type'],
                  orElse: () => MessageType.text,
                ),
                createdAt: (data['createdAt'] as Timestamp).toDate(),
                isGroup: false,
                groupInfo: null,
              ),
            );
          }
        }
        // Optionally, add group search logic here if needed
      }

      return PaginatedConversations(
        conversations: results,
        lastDocument:
            querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
        hasMore: querySnapshot.docs.length == limit,
      );
    } catch (e, stackTrace) {
      debugPrint("SEARCH_ERROR\n${e.toString()}\n$stackTrace");
      throw ConversationRemoteDatasourceException(
        code: 'SEARCH_ERROR',
        message: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  Future<ConversationEntity?> _findExistingConversation(
    List<String> participants,
  ) async {
    try {
      // For performance, check the smallest participant list first
      final sortedParticipants = List<String>.from(participants)..sort();
      final participantHash = sortedParticipants.join('_');

      // First try to find by exact participant match (optimized for 1:1 chats)
      final querySnapshot = await _firestoreService.getCollection(
        path: FirestoreConstants.conversations,
        queryBuilder: (Query query) {
          return query
              .where('participantHash', isEqualTo: participantHash)
              .limit(1);
        },
      );

      if (querySnapshot.docs.isNotEmpty) {
        return _convertDocToEntity(querySnapshot.docs.first, participants);
      }

      // Fallback for cases where participantHash isn't indexed or for groups
      // This is more expensive but ensures we don't miss any conversations
      final fallbackQuery = await _firestoreService.getCollection(
        path: FirestoreConstants.conversations,
        queryBuilder: (Query query) {
          return query.where('participants', arrayContains: participants.first);
        },
      );

      for (final doc in fallbackQuery.docs) {
        final docParticipants = List<String>.from(doc['participants'] ?? []);
        if (docParticipants.length == participants.length &&
            Set.from(docParticipants).containsAll(participants)) {
          return _convertDocToEntity(doc, participants);
        }
      }

      return null;
    } catch (e) {
      // Fail silently - we'll just create a new conversation
      debugPrint('Error finding existing conversation: $e');
      return null;
    }
  }

  Future<ConversationEntity?> _convertDocToEntity(
    DocumentSnapshot doc,
    List<String> participants,
  ) async {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return null;

    final isGroup = data['isGroup'] == true;
    final currentUserId = participants.firstWhere(
      (id) => data['participants'].contains(id),
      orElse: () => participants.first,
    );

    // For groups, we need different handling
    if (isGroup) {
      return ConversationEntity(
        id: doc.id,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        isOnline: false,
        lastMessage: data['lastMessage'] ?? '',
        lastMessageAt: (data['lastMessageTime'] as Timestamp).toDate(),
        lastMessageType: MessageType.values.firstWhere(
          (e) => e.name == data['type'],
          orElse: () => MessageType.text,
        ),
        isGroup: true,
        participants: List<String>.from(data['participants'] ?? []),
        groupInfo: GroupUsersEntity(
          id: doc.id,
          name: data['groupName'] ?? 'Group Chat',
          avatar: data['groupAvatar'],
          admins: List<String>.from(data['admins'] ?? []),
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          createdBy: data['createdBy'] ?? currentUserId,
        ),
      );
    }

    // Handle 1:1 conversation
    final otherUserId = participants.firstWhere((id) => id != currentUserId);
    final otherUser = await _userRemoteDatasource.getUserInfo(otherUserId);

    if (otherUser == null) return null;

    return ConversationEntity(
      id: doc.id,
      uid: otherUserId,
      name: otherUser.displayName ?? otherUser.username,
      avatar: otherUser.imgUrl ?? "",
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isOnline:
          await _userRemoteDatasource.getStatus(otherUserId) ==
          UserStatus.online,
      lastMessage: data['lastMessage'] ?? '',
      lastMessageAt: (data['lastMessageTime'] as Timestamp).toDate(),
      lastMessageType: MessageType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => MessageType.text,
      ),
      isGroup: false,
      participants: List<String>.from(data['participants'] ?? []),
      groupInfo: null,
    );
  }

  List<String> getGroupAvatar(List<UserEntity> participantsInfo) {
    // 1. Check total participant count (excluding me)
    final totalParticipants = participantsInfo.length;

    // 2. Return empty list if more than 3 other participants
    // (since participantsInfo doesn't include me, >3 others means >4 total)
    if (totalParticipants > 3) {
      return [];
    }

    // 3. Sort participants by ID for consistent ordering
    participantsInfo.sort((a, b) => a.uid.compareTo(b.uid));

    // 4. Determine how many avatars to return based on group size
    final int avatarsToReturn;
    if (totalParticipants == 2) {
      // Me + 2 others = 3 total
      avatarsToReturn = 2;
    } else if (totalParticipants == 3) {
      // Me + 3 others = 4 total
      avatarsToReturn = 3;
    } else {
      // For groups smaller than 2 others (total < 3)
      return [];
    }

    // 5. Take the first N avatars from sorted list
    return participantsInfo
        .take(avatarsToReturn)
        .map((user) => user.imgUrl ?? '') // Handle null photoUrl
        .where((avatarUrl) => avatarUrl.isNotEmpty) // Filter empty URLs
        .toList();
  }

  String getGroupName(List<UserEntity> participantsInfo) {
    // Sort participants by ID for consistent ordering
    participantsInfo.sort((a, b) => a.uid.compareTo(b.uid));

    return participantsInfo
        .map((user) => user.displayName ?? '') // Handle null displayName
        .where(
          (displayName) => displayName.isNotEmpty,
        ) // Filter empty displayName
        .toList()
        .join(", ");
  }
}

class ConversationRemoteDatasourceException implements Exception {
  final String code;
  final String message;
  final StackTrace stackTrace;
  final Map<String, dynamic>? additionalInfo;

  ConversationRemoteDatasourceException({
    required this.code,
    required this.message,
    required this.stackTrace,
    this.additionalInfo,
  });

  @override
  String toString() {
    return 'ConversationRemoteDatasourceException: $code - $message\n$stackTrace';
  }

  // Common error codes as static constants
  static const invalidParticipantsCode = 'INVALID_PARTICIPANTS';
  static const userNotIncludedCode = 'USER_NOT_INCLUDED';
  static const userNotFound = 'USER_NOT_FOUND';
  static const permissionDenied = 'PERMISSION_DENIED';
  static const groupOperationFailed = 'GROUP_OPERATION_FAILED';
  static const firestoreError = 'FIRESTORE_ERROR';
  static const unknownError = 'UNKNOWN_ERROR';

  // Factory constructors for common error types
  factory ConversationRemoteDatasourceException.invalidParticipants({
    required StackTrace stackTrace,
    String message = 'Invalid participants configuration',
    int? expected,
    int? actual,
  }) {
    return ConversationRemoteDatasourceException(
      code: invalidParticipantsCode,
      message: message,
      stackTrace: stackTrace,
      additionalInfo: {
        if (expected != null) 'expectedParticipants': expected,
        if (actual != null) 'actualParticipants': actual,
      },
    );
  }

  factory ConversationRemoteDatasourceException.userNotIncluded({
    required StackTrace stackTrace,
    String? currentUserId,
  }) {
    return ConversationRemoteDatasourceException(
      code: userNotIncludedCode,
      message: 'Current user must be included in conversation participants',
      stackTrace: stackTrace,
      additionalInfo: {
        if (currentUserId != null) 'currentUserId': currentUserId,
      },
    );
  }

  factory ConversationRemoteDatasourceException.fromFirebase(
    FirebaseException firebaseException,
    StackTrace stackTrace,
  ) {
    return ConversationRemoteDatasourceException(
      code: firebaseException.code,
      message: firebaseException.message ?? 'Firebase operation failed',
      stackTrace: stackTrace,
      additionalInfo: {'firebaseCode': firebaseException.code},
    );
  }

  factory ConversationRemoteDatasourceException.groupOperationNotAllowed({
    required StackTrace stackTrace,
    required String operation,
    String? conversationId,
  }) {
    return ConversationRemoteDatasourceException(
      code: permissionDenied,
      message: 'Operation "$operation" not allowed for this group',
      stackTrace: stackTrace,
      additionalInfo: {
        'operation': operation,
        if (conversationId != null) 'conversationId': conversationId,
      },
    );
  }

  // Convert to a simple map for logging or sending to error tracking services
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'stackTrace': stackTrace.toString(),
      if (additionalInfo != null) 'additionalInfo': additionalInfo,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

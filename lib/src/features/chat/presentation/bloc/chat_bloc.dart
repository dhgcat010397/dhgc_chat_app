import 'dart:async';

import 'package:dhgc_chat_app/src/features/chat/domain/usecases/load_more_messages.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/mark_message_as_seen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_entity.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_status.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_type.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_entity.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/delete_conversation.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/end_call.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/load_messages.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/send_image_message.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/send_text_message.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/start_call.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendTextMessage _sendTextMessage;
  final SendImageMessage _sendImageMessage;
  final StartCall _startCall;
  final EndCall _endCall;
  final LoadMessages _loadMessages;
  final LoadMoreMessages _loadMoreMessages;
  final DeleteConversation _deleteConversation;
  final MarkMessageAsSeen _markMessagesAsSeen;
  // final StreamMessages _streamMessages;
  // final TypingStatusUpdate _typingStatusUpdate;

  StreamSubscription<List<MessageEntity>>? _messagesSubscription;
  StreamSubscription<CallEntity?>? _callSubscription;
  // Timer? _typingTimer;
  final int _initialBatchSize = 30, _paginationBatchSize = 20;

  ChatBloc({
    required SendTextMessage sendTextMessage,
    required SendImageMessage sendImageMessage,
    required StartCall startCall,
    required EndCall endCall,
    required LoadMessages loadMessages,
    required LoadMoreMessages loadMoreMessages,
    required DeleteConversation deleteConversation,
    required MarkMessageAsSeen markMessagesAsSeen,
  }) : _sendTextMessage = sendTextMessage,
       _sendImageMessage = sendImageMessage,
       _startCall = startCall,
       _endCall = endCall,
       _loadMessages = loadMessages,
       _loadMoreMessages = loadMoreMessages,
       _deleteConversation = deleteConversation,
       _markMessagesAsSeen = markMessagesAsSeen,
       super(const ChatState.initial()) {
    on<ChatEvent>(
      (event, emit) => event.map(
        loadMessages: (event) => _onLoadMessages(event, emit),
        loadMoreMessages: (event) => _onLoadMoreMessages(event, emit),
        messageReceived: (event) => _onMessageReceived(event, emit),
        // messagesUpdated: (event) => _onMessagesUpdated(event, emit),
        sendTextMessage: (event) => _onSendTextMessage(event, emit),
        sendImageMessage: (event) => _onSendImageMessage(event, emit),
        messageSeen: (event) => _onMessageSeen(event, emit),
        typingStarted: (event) => _onTypingStarted(event, emit),
        typingEnded: (event) => _onTypingEnded(event, emit),
        startCall: (event) => _onStartCall(event, emit),
        endCall: (event) => _onEndCall(event, emit),
      ),
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _callSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadMessages(
    _LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatState.loading());
    try {
      _messagesSubscription?.cancel();
      _messagesSubscription = _loadMessages
          .call(event.chatroomId, _initialBatchSize)
          .listen((messages) {
            final currentState = state;
            if (currentState is _Loaded) {
              // Find new messages not already in the state
              final existingIds =
                  currentState.messages.map((m) => m.messageId).toSet();
              final newMessages =
                  messages
                      .where((m) => !existingIds.contains(m.messageId))
                      .toList();

              if (newMessages.isNotEmpty) {
                // Add only new messages to the state
                add(ChatEvent.messageReceived(newMessages));
              }
            } else {
              // For initial load or if state is not loaded, just replace
              add(ChatEvent.messageReceived(messages));
            }
          });

      // Initial load
      final messages = await _loadMessages.call(event.chatroomId).first;
      emit(ChatState.loaded(messages: messages));
    } catch (e) {
      emit(ChatState.error(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreMessages(
    _LoadMoreMessages event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;

    if (currentState is _Loaded) {
      try {
        // 1. Emit a loading state (optional - you could add isLoadingMore flag to your state)
        emit(currentState.copyWith(isLoadingMore: true));

        // 2. Get the oldest message timestamp for pagination
        final oldestMessage =
            currentState.messages.isNotEmpty
                ? currentState.messages.last.timestamp
                : DateTime.now();

        // 3. Fetch older messages from repository
        final olderMessages = await _loadMoreMessages.call(
          chatroomId: event.chatroomId,
          beforeTimestamp: oldestMessage!,
          limit: _paginationBatchSize,
        );

        // 4. Combine with existing messages (new messages come first)
        final allMessages = [...currentState.messages, ...olderMessages];

        // 5. Emit new state
        emit(
          currentState.copyWith(
            messages: allMessages,
            isLoadingMore: false,
            hasMoreMessages:
                olderMessages.isNotEmpty, // Add this flag to your state
          ),
        );
      } catch (e) {
        // 6. Handle error and revert to previous state
        emit(
          currentState.copyWith(
            isLoadingMore: false,
            loadMoreError: e.toString(), // Add this field to your state
          ),
        );

        // Clear error after timeout
        await Future.delayed(const Duration(seconds: 3));
        if (state is _Loaded && (state as _Loaded).loadMoreError != null) {
          emit(currentState.copyWith(loadMoreError: null));
        }
        debugPrint('Error loading more messages: $e');
      }
    }
  }

  Future<void> _onMessageReceived(
    _MessageReceived event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is _Loaded) {
      // Combine current messages with new ones, avoiding duplicates
      final existingIds = currentState.messages.map((m) => m.messageId).toSet();
      final updatedMessages = [
        ...event.messages.where((m) => !existingIds.contains(m.messageId)),
        ...currentState.messages,
      ];
      emit(currentState.copyWith(messages: updatedMessages));
    } else {
      emit(ChatState.loaded(messages: event.messages));
    }
  }

  // Future<void> _onMessagesUpdated(
  //   _MessagesUpdated event,
  //   Emitter<ChatState> emit,
  // ) async {
  //   final currentState = state;
  //   if (currentState is _Loaded) {
  //     emit(currentState.copyWith(messages: event.messages));
  //   }
  // }

  Future<void> _onSendTextMessage(
    _SendTextMessage event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is _Loaded) {
      try {
        // In a real app, you'd get the senderId from auth or user repository
        await _sendTextMessage.call(
          chatroomId: event.chatroomId,
          senderId: event.senderId,
          senderName: event.senderName,
          senderAvatar: event.senderAvatar,
          text: event.text,
        );
      } catch (e) {
        emit(ChatState.error(message: e.toString()));
      }
    }
  }

  Future<void> _onSendImageMessage(
    _SendImageMessage event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is _Loaded) {
      try {
        // In a real app, you'd get the senderId from auth or user repository
        await _sendImageMessage.call(
          chatroomId: event.chatroomId,
          senderId: event.senderId,
          senderName: event.senderName,
          senderAvatar: event.senderAvatar,
          imagePaths: event.imagePaths,
        );
      } catch (e) {
        emit(ChatState.error(message: e.toString()));
      }
    }
  }

  Future<void> _onStartCall(_StartCall event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is _Loaded) {
      try {
        // In a real app, you'd get the callerId from auth or user repository
        final callerId = event.callerId; // Replace with actual user ID
        // You'd also need to get participants from somewhere
        const participants = ['participant1_id', 'participant2_id'];

        await _startCall.call(
          chatroomId: event.chatroomId,
          callerId: callerId,
          callType: event.callType,
          participants: participants,
        );

        // In a real app, you'd listen for call updates
        // _callSubscription = _chatRepo.getCallStream(event.chatroomId).listen((call) {
        //   add(ChatEvent.callUpdated(call));
        // });

        // For demo purposes, we'll just emit a call in progress state
        final call = CallEntity(
          callId: 'call_id_${DateTime.now().millisecondsSinceEpoch}',
          // chatroomId: event.chatroomId,
          callerId: callerId,
          callType: event.callType,
          participants: participants,
          status: CallStatus.calling,
          startTime: DateTime.now(),
        );
        emit(ChatState.callInProgress(call));
      } catch (e) {
        emit(ChatState.error(message: e.toString()));
      }
    }
  }

  Future<void> _onEndCall(_EndCall event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is _CallInProgress || currentState is _Loaded) {
      try {
        await _endCall.call(
          chatroomId: event.chatroomId,
          callId: event.callId,
          callStatus: event.callStatus,
        );

        // For demo purposes, we'll just emit a call ended state
        final call = CallEntity(
          callId: event.callId,
          // chatroomId: event.chatroomId,
          callerId: event.callerId, // Replace with actual user ID
          callType: CallType.voice, // This should come from the ongoing call
          participants: const [], // This should come from the ongoing call
          status: event.callStatus,
          startTime: DateTime.now(),
          endTime: DateTime.now(),
        );
        emit(ChatState.callEnded(call));

        // After call ended, return to loaded state
        if (currentState is _Loaded) {
          emit(currentState.copyWith(ongoingCall: null));
        } else if (currentState is _CallInProgress) {
          emit(const ChatState.loaded(messages: []));
        }
      } catch (e) {
        emit(ChatState.error(message: e.toString()));
      }
    }
  }

  Future<void> _onMessageSeen(
    _MessageSeen event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;

    if (currentState is _Loaded) {
      try {
        // Find the index of the message to update
        final messageIndex = currentState.messages.indexWhere(
          (message) => message.messageId == event.messageId,
        );

        if (messageIndex != -1) {
          // Create a new list with the updated message
          final updatedMessages = List<MessageEntity>.from(
              currentState.messages,
            )
            ..[messageIndex] = currentState.messages[messageIndex].copyWith(
              isSeen: true,
            );

          // Update the repository if needed
          await _markMessagesAsSeen.call(event.messageId);

          // Emit the new state with updated messages
          emit(currentState.copyWith(messages: updatedMessages));
        }
      } catch (e) {
        // Handle error (log or show to user)
        debugPrint('Error marking message as seen: $e');
        // Optionally emit an error state:
        // emit(currentState.copyWith(errorMessage: 'Failed to mark message as seen'));
      }
    }
  }

  Future<void> _onTypingStarted(
    _TypingStarted event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is _Loaded) {
      emit(currentState.copyWith(isTyping: true));
    }
  }

  Future<void> _onTypingEnded(
    _TypingEnded event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is _Loaded) {
      emit(currentState.copyWith(isTyping: false));
    }
  }
}

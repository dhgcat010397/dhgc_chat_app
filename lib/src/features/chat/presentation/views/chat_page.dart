import 'package:dhgc_chat_app/src/features/conversations/domain/entities/conversation_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dhgc_chat_app/src/core/utils/constants/app_colors.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart' as di;
import 'package:dhgc_chat_app/src/shared/presentation/widgets/circle_avatar.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_status.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_type.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/message_entity.dart';
import 'package:dhgc_chat_app/src/features/chat/presentation/widgets/bubble_chat.dart';
import 'package:dhgc_chat_app/src/features/chat/presentation/widgets/message_textfield.dart';
import 'package:dhgc_chat_app/src/shared/presentation/widgets/mini_profile.dart';
import 'package:dhgc_chat_app/src/features/chat/presentation/bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.conversation, required this.user});

  final ConversationEntity conversation;
  final UserEntity user;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ScrollController _scrollController;
  late UserEntity _user;
  bool _showScrollButton = false;
  late ConversationEntity _conversation;
  late MessageEntity _lastMessage;

  @override
  void initState() {
    super.initState();

    _conversation = widget.conversation;
    _user = widget.user;

    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollButtonVisibility);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollButtonVisibility);
    _scrollController.dispose();

    super.dispose();
  }

  void _updateScrollButtonVisibility() {
    final isAtBottom =
        _scrollController.offset >=
        _scrollController.position.maxScrollExtent - 100;

    if (_showScrollButton == isAtBottom) {
      setState(() {
        _showScrollButton = !isAtBottom;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController
            .animateTo(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            )
            .then((_) {
              if (mounted) {
                setState(() => _showScrollButton = false);
              }
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final updatedConversation = _conversation.copyWith(
            lastMessage: _lastMessage.text,
            lastMessageAt: _lastMessage.timestamp,
            lastMessageType: _lastMessage.type,
          );

          // If the pop is not handled by the system, handle it here
          Navigator.pop(context, updatedConversation);
        }
      },
      child: BlocProvider(
        create:
            (context) =>
                di.sl<ChatBloc>()
                  ..add(ChatEvent.loadMessages(_conversation.id)),
        child: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            state.whenOrNull(
              error: (code, message, _) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message ?? 'An error occurred')),
                );
              },
              loaded: (messages, _, _, _, _, _, _) {
                _lastMessage = messages.first;
              },
              callInProgress: (call) {
                // Handle call in progress
                debugPrint('Call in progress: ${call.callId}');
              },
              callEnded: (call) {
                // Handle call ended
                debugPrint('Call ended: ${call.callId}');
              },
            );
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: MiniProfile(
                  userId: _conversation.uid!,
                  userName: _conversation.name!,
                  userAvatar: _conversation.avatar!,
                  avatarSize: 40.0,
                ),
                backgroundColor: AppColors.primaryColor,
                elevation: 0.0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  tooltip: 'Back',
                  onPressed: () {
                    final updatedConversation = _conversation.copyWith(
                      lastMessage: _lastMessage.text,
                      lastMessageAt: _lastMessage.timestamp,
                      lastMessageType: _lastMessage.type,
                    );

                    // If the pop is not handled by the system, handle it here
                    Navigator.pop(context, updatedConversation);
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.call, color: Colors.white),
                    tooltip: 'Start a voice call',
                    onPressed: () {
                      context.read<ChatBloc>().add(
                        ChatEvent.startCall(
                          chatroomId: _conversation.id,
                          callerId: _user.uid,
                          callType: CallType.voice,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.video_call, color: Colors.white),
                    tooltip: 'Start a video call',
                    onPressed: () {
                      context.read<ChatBloc>().add(
                        ChatEvent.startCall(
                          chatroomId: _conversation.id,
                          callerId: _user.uid,
                          callType: CallType.video,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    tooltip: 'More options',
                    onPressed: () {
                      // Handle more options
                      debugPrint('More options pressed');
                    },
                  ),
                ],
              ),
              backgroundColor: AppColors.primaryColor,
              body: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 30.0),
                        Expanded(
                          child: state.when(
                            initial:
                                () =>
                                    Center(child: CircularProgressIndicator()),
                            loading:
                                () =>
                                    Center(child: CircularProgressIndicator()),
                            loaded: (
                              messages,
                              isTyping,
                              isLoadingMore,
                              hasMoreMessages,
                              ongoingCall,
                              errorMessage,
                              loadMoreError,
                            ) {
                              return RefreshIndicator(
                                onRefresh: () async {
                                  context.read<ChatBloc>().add(
                                    ChatEvent.loadMessages(_conversation.id),
                                  );
                                },
                                child: ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  reverse: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final message = messages[index];
                                    return _buildMessageItem(
                                      messageId: message.messageId,
                                      messageContent: message.text,
                                      isMe: message.senderId == _user.uid,
                                      timestamp: message.timestamp,
                                      senderAvatar: message.senderAvatar ?? "",
                                    );
                                  },
                                ),
                              );
                            },
                            error:
                                (code, message, _) => Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(message ?? 'An error occurred'),
                                      ElevatedButton(
                                        onPressed: () {
                                          context.read<ChatBloc>().add(
                                            ChatEvent.loadMessages(
                                              _conversation.id,
                                            ),
                                          );
                                        },
                                        child: Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ),
                            callInProgress:
                                (call) => Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Call in progress: ${call.callType}',
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          context.read<ChatBloc>().add(
                                            ChatEvent.endCall(
                                              chatroomId: _conversation.id,
                                              callId: call.callId,
                                              callerId: _user.uid,
                                              callStatus: CallStatus.ended,
                                            ),
                                          );
                                        },
                                        child: Text('End Call'),
                                      ),
                                    ],
                                  ),
                                ),
                            callEnded:
                                (call) => Center(
                                  child: Text('Call ended: ${call.callType}'),
                                ),
                          ),
                        ),
                        MessageTextfield(
                          onSendMessage: (message) {
                            if (message.isNotEmpty) {
                              context.read<ChatBloc>().add(
                                ChatEvent.sendTextMessage(
                                  chatroomId: _conversation.id,
                                  senderId: _user.uid,
                                  senderName:
                                      _user.displayName!.isEmpty
                                          ? _user.username
                                          : _user.displayName!,
                                  senderAvatar: _user.imgUrl ?? "",
                                  text: message,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),

                    // Scroll to bottom button
                    if (_showScrollButton)
                      Positioned(
                        bottom: 80,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: FloatingActionButton(
                            mini: true,
                            tooltip: 'Scroll to bottom',
                            shape: CircleBorder(),
                            backgroundColor: AppColors.primaryColor,
                            onPressed: _scrollToBottom,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageItem({
    required String messageId,
    required String? messageContent,
    required bool isMe,
    required DateTime? timestamp,
    String senderAvatar = "",
    double senderAvatarSize = 40.0,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatarWidget(imageUrl: senderAvatar, size: senderAvatarSize),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                BubbleChat(
                  message: messageContent ?? "",
                  isMe: isMe,
                  senderBubbleColor: AppColors.primaryColor,
                  receiverBubbleColor: Colors.grey[200]!,
                  senderTextColor: Colors.black,
                  receiverTextColor: Colors.white,
                  onTap: () {
                    // Mark message as seen when tapped
                    context.read<ChatBloc>().add(
                      ChatEvent.messageSeen(messageId),
                    );
                  },
                ),
                SizedBox(height: 4),
                if (timestamp != null)
                  Text(
                    _formatTime(timestamp),
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
              ],
            ),
          ),
          if (isMe) SizedBox(width: 8),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

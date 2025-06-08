import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dhgc_chat_app/src/core/utils/constants/app_colors.dart';
import 'package:dhgc_chat_app/src/shared/presentation/widgets/circle_avatar.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_status.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/entities/call_type.dart';
import 'package:dhgc_chat_app/src/features/chat/presentation/widgets/bubble_chat.dart';
import 'package:dhgc_chat_app/src/features/chat/presentation/widgets/message_textfield.dart';
import 'package:dhgc_chat_app/src/shared/presentation/widgets/mini_profile.dart';
import 'package:dhgc_chat_app/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.conversationId,
    required this.receiverId,
    required this.user,
  });

  final String conversationId;
  final String receiverId;
  final UserEntity user;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ScrollController _scrollController;
  late TextEditingController _messageController;
  late FocusNode _messageFocusNode;
  // String _searchQuery = "";
  bool _showScrollButton = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _messageController = TextEditingController();
    _messageFocusNode = FocusNode();

    _scrollController.addListener(_updateScrollButtonVisibility);

    // Initialize chat by loading messages
    context.read<ChatBloc>().add(ChatEvent.loadMessages(widget.conversationId));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollButtonVisibility);
    _scrollController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
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
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (code, message, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message ?? 'An error occurred')),
            );
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
              userId: widget.receiverId,
              userName: "User ${widget.receiverId}",
              userAvatar: 'https://example.com/avatar.png',
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
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.call, color: Colors.white),
                tooltip: 'Start a voice call',
                onPressed: () {
                  context.read<ChatBloc>().add(
                    ChatEvent.startCall(
                      chatroomId: widget.conversationId,
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
                      chatroomId: widget.conversationId,
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
                            () => Center(child: CircularProgressIndicator()),
                        loading:
                            () => Center(child: CircularProgressIndicator()),
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
                                ChatEvent.loadMessages(widget.conversationId),
                              );
                            },
                            child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              reverse: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                return _buildMessageItem(
                                  messageId: message.messageId,
                                  messageContent: message.text!,
                                  isMe: message.senderId == widget.user.uid,
                                  timestamp: message.timestamp,
                                  senderAvatar:
                                      'https://example.com/avatar.png',
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
                                          widget.conversationId,
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
                                  Text('Call in progress: ${call.callType}'),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<ChatBloc>().add(
                                        ChatEvent.endCall(
                                          chatroomId: widget.conversationId,
                                          callId: call.callId,
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
                        context.read<ChatBloc>().add(
                          ChatEvent.sendTextMessage(
                            chatroomId: widget.conversationId,
                            senderId: widget.user.uid,
                            text: message,
                          ),
                        );
                        _messageController.clear();
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
    );
  }

  Widget _buildMessageItem({
    required String messageId,
    required String messageContent,
    required bool isMe,
    required DateTime timestamp,
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
                  message: messageContent,
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

import 'package:flutter/material.dart';

import 'package:dhgc_chat_app/src/core/utils/constants/app_colors.dart';
import 'package:dhgc_chat_app/src/core/utils/widgets/avatar.dart';
import 'package:dhgc_chat_app/src/features/chat/presentation/widgets/bubble_chat.dart';
import 'package:dhgc_chat_app/src/features/chat/presentation/widgets/message_textfield.dart';
import 'package:dhgc_chat_app/src/features/chat/presentation/widgets/mini_profile.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.conversationId,
    required this.receiverId,
  });

  final String conversationId;
  final String receiverId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ScrollController _scrollController;
  late TextEditingController _messageController;
  late FocusNode _messageFocusNode;
  // late TextEditingController _searchController;
  String _searchQuery = "";
  bool _showScrollButton = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _messageController = TextEditingController();
    // _searchController = TextEditingController();
    _messageFocusNode = FocusNode();

    _scrollController.addListener(_updateScrollButtonVisibility);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollButtonVisibility);

    _scrollController.dispose();
    _messageController.dispose();
    // _searchController.dispose();
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
    return Scaffold(
      appBar: AppBar(
        title: MiniProfile(
          userId: widget.receiverId,
          userName: "User ${widget.receiverId}",
          userAvatar: 'https://example.com/avatar.png',
          isOnline: true,
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
              // Handle more options
              debugPrint('Voice call pressed');
            },
          ),
          IconButton(
            icon: const Icon(Icons.video_call, color: Colors.white),
            tooltip: 'Start a video call',
            onPressed: () {
              // Handle more options
              debugPrint('Video call pressed');
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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      // Handle refresh logic here
                      debugPrint('Refresh triggered');
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      reverse: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: 50, // Replace with your actual data count
                      itemBuilder: (context, index) {
                        return _buildMessageItem(
                          messageId: 'msg_$index',
                          messageContent: 'Message content $index',
                          isMe: index % 2 == 0, // Simulate alternating sender
                          timestamp: DateTime.now().subtract(
                            Duration(minutes: index),
                          ),
                          isOnline: index % 3 == 0, // Simulate online status
                          senderAvatar: 'https://example.com/avatar.png',
                        );
                      },
                    ),
                  ),
                ),
                MessageTextfield(
                  onSendMessage: (message) => _sendMessage(message),
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
                    child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem({
    required String messageId,
    required String messageContent,
    required bool isMe,
    required DateTime timestamp,
    required bool isOnline,
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
            CircleAvatarWidget(
              imageUrl: senderAvatar,
              size: senderAvatarSize,
              isOnline: isOnline,
            ),
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
                    // Handle bubble tap
                    debugPrint('Tapped on message bubble: $messageId');
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

  void _sendMessage(String message) {
    debugPrint('Sending message: $message');
    // Optionally scroll to the bottom after sending a message
    _scrollToBottom();
  }
}

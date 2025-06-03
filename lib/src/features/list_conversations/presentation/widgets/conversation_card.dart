import 'package:flutter/material.dart';

import 'package:dhgc_chat_app/src/core/utils/widgets/avatar.dart';

class ConversationCard extends StatelessWidget {
  const ConversationCard({
    super.key,
    required this.conversationId,
    required this.receiverId,
    required this.receiverName,
    required this.receiverAvatar,
    required this.lastMessage,
    required this.lastMessageAt,
    this.isOnline = true,
    this.onTap,
  });

  final String conversationId;
  final String receiverId;
  final String receiverName;
  final String receiverAvatar;
  final String lastMessage;
  final DateTime lastMessageAt;
  final bool isOnline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Material(
        elevation: 3.0,
        // borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(10.0),
          ),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatarWidget(
                imageUrl: 'https://example.com/avatar.png',
                size: 60.0,
                isOnline: isOnline,
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      receiverName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      lastMessage,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                        color: Color.fromARGB(151, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '${lastMessageAt.hour}:${lastMessageAt.minute.toString().padLeft(2, '0')}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(151, 0, 0, 0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

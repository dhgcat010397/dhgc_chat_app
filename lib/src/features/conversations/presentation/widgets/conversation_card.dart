import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:dhgc_chat_app/src/shared/presentation/widgets/circle_avatar.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/conversation_entity.dart';

class ConversationCard extends StatelessWidget {
  const ConversationCard({
    super.key,
    required this.conversation,
    required this.uid,
    this.isOnline = true,
    this.onTap,
  });

  final ConversationEntity conversation;
  final String uid;
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
                imageUrl:
                    conversation.avatar ?? 'https://example.com/avatar.png',
                size: 60.0,
                uid: conversation.uid,
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      conversation.isGroup
                          ? (conversation.groupInfo?.name ?? "")
                          : (conversation.name ?? ""),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      conversation.lastMessage,
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
                  DateFormat('HH:mm').format(conversation.lastMessageAt),
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

import 'package:flutter/material.dart';

import 'package:dhgc_chat_app/src/core/helpers/painter_helper.dart';

class BubbleChat extends StatelessWidget {
  const BubbleChat({
    super.key,
    required this.message,
    required this.isMe,
    required this.senderBubbleColor,
    required this.receiverBubbleColor,
    required this.senderTextColor,
    required this.receiverTextColor,
    this.onTap,
  });

  final String message;
  final bool isMe;
  final Color senderBubbleColor;
  final Color receiverBubbleColor;
  final Color senderTextColor;
  final Color receiverTextColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // If the message is sent by the receiver, draw the triangle on the left side
          // This triangle points towards the sender's bubble
          if (!isMe)
            CustomPaint(
              painter: TrianglePainter(
                color: receiverBubbleColor,
                isLeft: true,
              ),
              size: Size(12, 16),
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? senderBubbleColor : receiverBubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft:
                    isMe ? const Radius.circular(16) : const Radius.circular(0),
                bottomRight:
                    isMe ? const Radius.circular(0) : const Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                message,
                style: TextStyle(
                  color: isMe ? receiverTextColor : senderTextColor,
                ),
              ),
            ),
          ),
          // If the message is sent by the user, draw the triangle on the right side
          // This triangle points towards the receiver's bubble
          if (isMe)
            CustomPaint(
              painter: TrianglePainter(color: senderBubbleColor, isLeft: false),
              size: Size(12, 16),
            ),
        ],
      ),
    );
  }
}

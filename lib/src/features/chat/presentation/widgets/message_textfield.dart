import 'package:dhgc_chat_app/src/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MessageTextfield extends StatefulWidget {
  const MessageTextfield({super.key, required this.onSendMessage});

  final Function(String)? onSendMessage;

  @override
  State<MessageTextfield> createState() => _MessageTextfieldState();
}

class _MessageTextfieldState extends State<MessageTextfield> {
  late TextEditingController _messageController;
  bool _expandTextField = false, _isSend = false;

  @override
  void initState() {
    super.initState();

    _messageController = TextEditingController();
    _messageController.addListener(_toggleSendButton);
  }

  @override
  void dispose() {
    _messageController.removeListener(_toggleSendButton);
    _messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!_expandTextField) ...[
            IconButton(
              icon: Icon(
                Icons.add_circle_rounded,
                color: AppColors.primaryColor,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.photo_library, color: AppColors.primaryColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.mic, color: AppColors.primaryColor),
              onPressed: () {},
            ),
          ] else ...[
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.primaryColor,
              ),
              onPressed: () => _toggleExpandTextField(false),
            ),
          ],
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (_) => _toggleExpandTextField(true),
              onTap: () => _toggleExpandTextField(true),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          Opacity(
            opacity: !_isSend ? 0.5 : 1.0,
            child: IconButton(
              icon: Icon(Icons.send, color: AppColors.primaryColor),
              tooltip: 'Send Message',
              onPressed: _isSend ? _sendMessage : null,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleExpandTextField(bool expand) {
    if (mounted && _expandTextField != expand) {
      // Only update the state if the value has changed
      setState(() {
        _expandTextField = expand;
      });
    }
  }

  void _toggleSendButton() {
    // Check if the text field is empty or not
    final isEmpty = _messageController.text.trim().isEmpty;
    if (mounted && _isSend == isEmpty) {
      // Only update the state if the value has changed
      setState(() {
        _isSend = !isEmpty;
      });
    }
  }

  void _sendMessage() {
    widget.onSendMessage?.call(_messageController.text.trim());
    _messageController.clear();
    if (mounted) {
      setState(() {
        _expandTextField = false;
        _isSend = false;
      });
    }
  }
}

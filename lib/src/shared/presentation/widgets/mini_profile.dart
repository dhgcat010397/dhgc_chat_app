import 'package:flutter/material.dart';
import 'package:dhgc_chat_app/src/shared/presentation/widgets/circle_avatar.dart';
import 'package:dhgc_chat_app/src/core/utils/constants/app_colors.dart';

class MiniProfile extends StatelessWidget {
  const MiniProfile({
    super.key,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.isOnline,
    this.backgroundColor = AppColors.primaryColor,
    this.avatarSize = 40.0,
    this.nameSize = 16.0,
    this.statusSize = 12.0,
    this.nameColor = Colors.white,
    this.statusColor = Colors.white,
    this.onTap,
  });

  final String userId;
  final String userName;
  final String userAvatar;
  final bool isOnline;
  final Color backgroundColor;
  final double? nameSize;
  final double? statusSize;
  final Color? nameColor;
  final Color? statusColor;
  final double avatarSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Material(
        child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(color: backgroundColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatarWidget(
                imageUrl: userAvatar,
                size: avatarSize,
                uid: userId,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: nameSize,
                        fontWeight: FontWeight.w500,
                        color: nameColor,
                      ),
                    ),
                    Text(
                      _receiverStatus,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: statusSize,
                        fontWeight: FontWeight.w300,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _receiverStatus {
    // Logic to display online/offline status
    return isOnline ? 'Online' : 'Offline';
  }
}

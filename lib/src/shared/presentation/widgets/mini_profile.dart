import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhgc_chat_app/src/core/utils/constants/app_colors.dart';
import 'package:dhgc_chat_app/src/core/utils/extensions/string_extension.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_status.dart';
import 'package:dhgc_chat_app/src/shared/presentation/bloc/user_status_bloc/user_status_bloc.dart';
import 'package:dhgc_chat_app/src/shared/presentation/widgets/circle_avatar.dart';

class MiniProfile extends StatelessWidget {
  const MiniProfile({
    super.key,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    this.backgroundColor = AppColors.primaryColor,
    this.avatarSize = 40.0,
    this.nameSize = 16.0,
    this.statusSize = 12.0,
    this.nameColor = Colors.white,
    this.statusColor = Colors.white,
  });

  final String userId;
  final String userName;
  final String userAvatar;
  final Color backgroundColor;
  final double? nameSize;
  final double? statusSize;
  final Color? nameColor;
  final Color? statusColor;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    context.read<UserStatusBloc>().add(UserStatusEvent.subscribe(userId));
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatarWidget(
            imageUrl: userAvatar,
            size: avatarSize,
            uid: userId,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                BlocBuilder<UserStatusBloc, UserStatusState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      updated: (status) => _buildStatusText(status),
                      orElse: () => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText(UserStatus status) {
    // Logic to display status
    return Text(
      status.name.capitalize(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: statusSize,
        fontWeight: FontWeight.w300,
        color: _getStatusColor(status),
      ),
    );
  }

  Color _getStatusColor(UserStatus status) {
    final Color color;

    switch (status) {
      case UserStatus.online:
        color = Colors.green;
      case UserStatus.offline:
        color = Colors.grey[500]!;
      case UserStatus.away:
        color = Colors.blueAccent;
      case UserStatus.invisible:
        color = Colors.grey[200]!;
      case UserStatus.doNotDisturb:
        color = Colors.red;
    }

    return color;
  }
}

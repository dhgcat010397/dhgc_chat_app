import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart' as di;
import 'package:dhgc_chat_app/src/core/utils/widgets/avatar.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_status.dart';
import 'package:dhgc_chat_app/src/shared/presentation/bloc/user_status_bloc/user_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CircleAvatarWidget extends StatelessWidget {
  const CircleAvatarWidget({
    super.key,
    required this.imageUrl,
    this.initials,
    this.size = 40,
    this.uid,
  });

  final String imageUrl;
  final String? initials;
  final double size;
  final String? uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          NetworkAvatar(
            imageUrl: imageUrl,
            size: size,
            backgroundColor: Colors.grey[200]!,
            textColor: Colors.black,
            initials: initials,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child:
                uid == null
                    ? const SizedBox.shrink()
                    : BlocProvider(
                      create:
                          (context) =>
                              di.sl<UserStatusBloc>()
                                ..add(UserStatusEvent.subscribe(uid!)),
                      child: BlocBuilder<UserStatusBloc, UserStatusState>(
                        builder: (context, state) {
                          return state.when(
                            initial: () => const SizedBox(),
                            loading: () => const SizedBox(),
                            updated:
                                (status) => _buildOnlineStatus(context, status),
                            error: (_, __, ___) => const SizedBox(),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineStatus(BuildContext context, UserStatus status) {
    return status == UserStatus.online
        ? Container(
          width: size * 0.25,
          height: size * 0.25,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: size / 30,
            ),
          ),
        )
        : const SizedBox.shrink();
  }
}

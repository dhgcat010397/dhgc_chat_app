import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dhgc_chat_app/src/core/utils/extensions/string_extension.dart';
import 'package:dhgc_chat_app/src/core/utils/widgets/search_bar.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/shared/presentation/widgets/mini_profile.dart';
import 'package:dhgc_chat_app/src/shared/presentation/bloc/search_users_bloc/search_users_bloc.dart';

class SearchUsersWidget extends StatelessWidget {
  const SearchUsersWidget({
    super.key,
    this.onTapSelectedUser,
    this.scrollController,
  });

  final Function(UserEntity)? onTapSelectedUser;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SearchUsersBloc>(),
      child: Column(
        children: [
          _SearchBar(),
          const SizedBox(height: 16),
          Expanded(
            child: _SearchResults(
              scrollController: scrollController,
              onTapSelectedUser: (userInfo) {
                onTapSelectedUser?.call(userInfo);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffececf8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ChatAppSearchBar(
        onSearch: (query) {
          // Handle search logic here
          final String searchQuery = query.cleanedQuery;
          debugPrint('Search query (cleaned): "$searchQuery"');
          context.read<SearchUsersBloc>().add(
            SearchUsersEvent.search(searchQuery),
          );
        },
        onClear: () {
          context.read<SearchUsersBloc>().add(const SearchUsersEvent.clear());
        },
        hintText: 'Search by Receiver\'s Name',
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final Function(UserEntity)? onTapSelectedUser;
  final ScrollController? scrollController;

  const _SearchResults({this.scrollController, this.onTapSelectedUser});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchUsersBloc, SearchUsersState>(
      listener: (context, state) {
        state.maybeWhen(
          error: (_, __, message, ____) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message!)));
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return state.when(
          initial:
              () => const Center(child: Text('Start typing to search users')),
          loading: () => const Center(child: CircularProgressIndicator()),
          loadMore: (users) => _buildUserList(users, false),
          success:
              (users, hasReachedMax) => _buildUserList(users, !hasReachedMax),
          error:
              (currentUsers, __, ___, ____) =>
                  _buildUserList(currentUsers, false),
          empty: () => const Center(child: Text('No users found')),
        );
      },
    );
  }

  Widget _buildUserList(List<UserEntity> users, bool canLoadMore) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (canLoadMore &&
            notification.metrics.pixels ==
                notification.metrics.maxScrollExtent) {
          final context = notification.context; // Get context from notification
          if (context != null) {
            context.read<SearchUsersBloc>().add(
              const SearchUsersEvent.loadMore(),
            );
          }
        }
        return false;
      },
      child: ListView.builder(
        controller: scrollController,
        itemCount: canLoadMore ? users.length + 1 : users.length,
        itemBuilder: (context, index) {
          if (index >= users.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return _UserCard(
            user: users[index],
            onTap: (userInfo) {
              onTapSelectedUser?.call(userInfo);
            },
          );
        },
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserEntity user;
  final Function(UserEntity)? onTap;

  const _UserCard({required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call(user);
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300, // Border color
                width: 1.0, // Border width
              ),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          child: MiniProfile(
            userId: user.uid,
            userAvatar: user.imgUrl ?? "",
            userName: _displayName(),
            backgroundColor: Colors.white,
            avatarSize: 60.0,
            nameColor: Colors.black,
            nameSize: 18.0,
            statusSize: 14.0,
            statusColor: Colors.white,
          ),
        ),
      ),
    );
  }

  String _displayName() {
    if (user.displayName == null || user.displayName!.isEmpty) {
      return user.username;
    }

    return user.displayName!;
  }
}

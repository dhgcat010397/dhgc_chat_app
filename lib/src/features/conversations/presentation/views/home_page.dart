import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhgc_chat_app/src/core/routes/app_routes.dart';
import 'package:dhgc_chat_app/src/core/utils/constants/app_colors.dart';
import 'package:dhgc_chat_app/src/core/utils/constants/app_images.dart';
import 'package:dhgc_chat_app/src/core/utils/extensions/string_extension.dart';
import 'package:dhgc_chat_app/src/core/utils/widgets/search_bar.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart' as di;
import 'package:dhgc_chat_app/src/features/conversations/domain/entities/conversation_entity.dart';
import 'package:dhgc_chat_app/src/features/conversations/presentation/bloc/conversations_bloc.dart';
import 'package:dhgc_chat_app/src/features/conversations/presentation/widgets/conversation_card.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/shared/presentation/widgets/circle_avatar.dart';
import 'package:dhgc_chat_app/src/shared/presentation/widgets/search_users.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});

  final UserEntity user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  String _searchQuery = "";

  late UserEntity user;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    user = widget.user;
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final backgroundColor = AppColors.primaryColor;
    // final backgroundColor = theme.colorScheme.background;

    return BlocProvider(
      create:
          (context) =>
              di.sl<ConversationsBloc>()
                ..add(ConversationsEvent.loadConversations(user.uid)),
      child: BlocListener<ConversationsBloc, ConversationsState>(
        listener: _handleStateChanges,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Action to perform when the button is pressed
              _showUserSearchSheet(context);
            },
            tooltip: 'New Conversation',
            backgroundColor: backgroundColor,
            shape: CircleBorder(side: BorderSide.none),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.greeting,
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: Text(
                          '${user.displayName!.isEmpty ? user.username : user.displayName}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      CircleAvatarWidget(
                        imageUrl: user.imgUrl!,
                        size: 60.0,
                        uid: user.uid,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Chat App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30.0),
                        _buildSearchBar(),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: BlocBuilder<
                            ConversationsBloc,
                            ConversationsState
                          >(
                            builder: (context, state) {
                              return _buildContent(state);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ConversationsState state) {
    state.whenOrNull(
      conversationCreated: (conversation) {
        // Navigate to chat page when conversation is created
        Navigator.pushNamed(
          context,
          AppRoutes.chat,
          arguments: {
            'conversationId': conversation.id,
            'receiverId': conversation.uid,
            'user': user,
          },
        );
      },
      error: (code, message, _) {
        // Show error message if creation fails
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message!)));
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffececf8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ChatAppSearchBar(
        onSearch: (query) {
          // Handle search logic here
          _searchQuery = query.cleanedQuery;
          debugPrint('Search query (cleaned): "$_searchQuery"');
          context.read<ConversationsBloc>().add(
            ConversationsEvent.searchConversations(_searchQuery),
          );
        },
        hintText: 'Search by Receiver\'s Name',
      ),
    );
  }

  Widget _buildContent(ConversationsState state) {
    return state.when(
      initial: () => const Center(child: CircularProgressIndicator()),
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded:
          (conversations, hasReachedMax, _) =>
              _buildConversationList(conversations, hasReachedMax),
      loadingMore:
          (conversations, hasReachedMax, _) => _buildConversationList(
            conversations,
            hasReachedMax,
            isLoadingMore: true,
          ),
      searchResults:
          (conversations) => _buildConversationList(conversations, true),
      conversationCreated:
          (conversation) => _buildConversationList([conversation], true),
      conversationDeleted:
          (conversationId, conversations) =>
              _buildConversationList(conversations, true),
      error:
          (code, message, trackStrace) =>
              Center(child: Text('Error: $message')),
    );
  }

  Widget _buildConversationList(
    List<ConversationEntity> conversations,
    bool hasReachedMax, {
    bool isLoadingMore = false,
  }) {
    if (conversations.isEmpty) {
      return const Center(child: Text("No conversations yet"));
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Handle refresh logic here
        debugPrint('Refresh triggered');
        context.read<ConversationsBloc>().add(
          ConversationsEvent.loadConversations(user.uid),
        );
      },
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
            conversations.length +
            (isLoadingMore ? 1 : 0) +
            (hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= conversations.length) {
            if (isLoadingMore) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const SizedBox.shrink(); // Empty space for "load more" trigger
          }

          final conversation = conversations[index];
          return ConversationCard(
            conversation: conversation,
            onTap: () => _openChat(conversation),
            uid: conversation.uid!,
          );
        },
      ),
    );
  }

  void _openChat(ConversationEntity conversation) {
    Navigator.pushNamed(
      context,
      AppRoutes.chat,
      arguments: {
        'conversationId': conversation.id,
        'receiverId': conversation.uid,
        'user': user,
      },
    );
  }

  void _showUserSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Draggable handle
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header with close button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Conversation',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              // Search widget
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: SearchUsersWidget(
                    onTapSelectedUser: (userInfo) {
                      Navigator.pop(context);
                      context.read<ConversationsBloc>().add(
                        ConversationsEvent.createNewConversation(
                          uid: user.uid,
                          participants: [userInfo.uid],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

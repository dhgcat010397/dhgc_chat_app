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
  bool _hasMoreConversations = false, _isLoadingMore = false;
  late UserEntity _user;

  @override
  void initState() {
    super.initState();
    //_debugProviderHierarchy();

    _scrollController = ScrollController();
    _scrollController.addListener(_handleLoadMore);

    _user = widget.user;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleLoadMore);
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
                ..add(ConversationsEvent.loadConversations(_user.uid)),
      child: BlocListener<ConversationsBloc, ConversationsState>(
        listener: _handleStateChanges,
        child: Scaffold(
          floatingActionButton: Builder(
            builder:
                (fabContext) => FloatingActionButton(
                  onPressed: () {
                    _showUserSearchSheet(fabContext);
                  },
                  tooltip: 'New Conversation',
                  backgroundColor: backgroundColor,
                  shape: CircleBorder(side: BorderSide.none),
                  child: const Icon(
                    Icons.add_comment_rounded,
                    color: Colors.white,
                  ),
                ),
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
                          '${_user.displayName!.isEmpty ? _user.username : _user.displayName}',
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
                        imageUrl: _user.imgUrl ?? "",
                        initials: _user.displayName!.characters.first,
                        size: 60.0,
                        uid: _user.uid,
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
                        Builder(
                          builder:
                              (innerContext) => _buildSearchBar(innerContext),
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: BlocBuilder<
                            ConversationsBloc,
                            ConversationsState
                          >(
                            builder: (context, state) {
                              return _buildContent(context, state);
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
      loaded: (conversations, hasReachedMax, _) {
        _hasMoreConversations = !hasReachedMax;
        _isLoadingMore = false;
      },
      loadingMore: (conversations, hasReachedMax, _) {
        _hasMoreConversations = !hasReachedMax;
        _isLoadingMore = true;
      },
      searchResults: (conversations, hasReachedMax, _) {
        _hasMoreConversations = !hasReachedMax;
        _isLoadingMore = false;
      },
      conversationCreated: (conversation) async {
        final bloc = context.read<ConversationsBloc>();
        // Navigate to chat page when conversation is created
        final newConversation = await Navigator.pushNamed(
          context,
          AppRoutes.chat,
          arguments: {'conversation': conversation, 'user': _user},
        );

        // Reload conversations to include the new one
        if (!mounted) return;
        if (newConversation is ConversationEntity) {
          if (_searchQuery.isEmpty) {
            bloc.add(ConversationsEvent.loadConversations(_user.uid));
          } else {
            bloc.add(
              ConversationsEvent.searchConversations(
                uid: _user.uid,
                query: _searchQuery,
              ),
            );
          }
        }
      },
      error: (code, message, _) {
        // Show error message if creation fails
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message!)));
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        decoration: BoxDecoration(color: Color(0xffececf8)),
        child: ChatAppSearchBar(
          onSearch: (query) {
            // Handle search logic here
            _searchQuery = query.cleanedQuery;
            debugPrint('Search query (cleaned): "$_searchQuery"');
            context.read<ConversationsBloc>().add(
              ConversationsEvent.searchConversations(
                uid: _user.uid,
                query: _searchQuery,
              ),
            );
          },
          hintText: 'Search by Receiver\'s Name',
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ConversationsState state) {
    return state.when(
      initial: () => const Center(child: CircularProgressIndicator()),
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded:
          (conversations, hasReachedMax, _) => Builder(
            builder: (innerContext) {
              return _buildConversationList(
                innerContext,
                conversations,
                hasReachedMax,
              );
            },
          ),
      loadingMore:
          (conversations, hasReachedMax, _) => Builder(
            builder: (innerContext) {
              return _buildConversationList(
                innerContext,
                conversations,
                hasReachedMax,
                isLoadingMore: true,
              );
            },
          ),
      searchResults:
          (conversations, hasReachedMax, lastDocument) => Builder(
            builder: (innerContext) {
              return _buildConversationList(
                innerContext,
                conversations,
                hasReachedMax,
              );
            },
          ),
      conversationCreated:
          (conversation) => Builder(
            builder: (innerContext) {
              return _buildConversationList(innerContext, [conversation], true);
            },
          ),
      conversationDeleted:
          (conversationId, conversations) => Builder(
            builder: (innerContext) {
              return _buildConversationList(innerContext, conversations, true);
            },
          ),
      error:
          (code, message, trackStrace) =>
              Center(child: Text('Error: $message')),
    );
  }

  Widget _buildConversationList(
    BuildContext context,
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
        if (_searchQuery.isEmpty) {
          context.read<ConversationsBloc>().add(
            ConversationsEvent.loadConversations(_user.uid),
          );
        } else {
          context.read<ConversationsBloc>().add(
            ConversationsEvent.searchConversations(
              uid: _user.uid,
              query: _searchQuery,
            ),
          );
        }
      },
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
            conversations.length +
            (isLoadingMore ? 1 : 0) +
            (hasReachedMax ? 0 : 1),
        itemBuilder: (itemContext, index) {
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
            onTap: () => _openChat(itemContext, conversation),
          );
        },
      ),
    );
  }

  void _openChat(BuildContext context, ConversationEntity conversation) async {
    final bloc = context.read<ConversationsBloc>();
    final updatedConversation = await Navigator.pushNamed(
      context,
      AppRoutes.chat,
      arguments: {'conversation': conversation, 'user': _user},
    );

    // If ChatPage returns an updated conversation, update the list
    if (!mounted) return;
    if (updatedConversation is ConversationEntity) {
      bloc.add(ConversationsEvent.updateConversation(updatedConversation));
    }
  }

  void _showUserSearchSheet(BuildContext context) {
    // Get the blocs from the parent context
    // final searchUsersBloc = context.read<SearchUsersBloc>();
    final conversationsBloc = context.read<ConversationsBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: conversationsBloc,
          child: Container(
            height: MediaQuery.of(sheetContext).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Draggable handle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Header with close button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Conversation',
                        style: Theme.of(sheetContext).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey[700]),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1),
                ),
                // Search widget
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Builder(
                      builder:
                          (innerContext) => SearchUsersWidget(
                            onTapSelectedUser: (userInfo) {
                              innerContext.read<ConversationsBloc>().add(
                                ConversationsEvent.createNewConversation(
                                  uid: _user.uid,
                                  participants: [userInfo.uid],
                                ),
                              );
                              Navigator.pop(innerContext);
                            },
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleLoadMore() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      // User is near the top (since reverse: true)
      if (_hasMoreConversations && !_isLoadingMore) {
        if (_searchQuery.isEmpty) {
          context.read<ConversationsBloc>().add(
            ConversationsEvent.loadMoreConversations(_user.uid),
          );
        }
      } else {
        context.read<ConversationsBloc>().add(
          ConversationsEvent.loadingMoreSearchConversations(
            uid: _user.uid,
            query: _searchQuery,
          ),
        );
      }
    }
  }

  // Track Widget Tree, use when debug
  // void _debugProviderHierarchy() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     debugPrint(
  //       WidgetsBinding.instance.rootElement?.toStringDeep() ?? "No widget tree",
  //     );
  //   });
  // }
}

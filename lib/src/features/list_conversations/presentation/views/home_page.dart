import 'package:dhgc_chat_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

import 'package:dhgc_chat_app/src/core/routes/app_routes.dart';
import 'package:dhgc_chat_app/src/core/utils/constants/app_colors.dart';
import 'package:dhgc_chat_app/src/core/utils/constants/app_images.dart';
import 'package:dhgc_chat_app/src/core/utils/extensions/string_extension.dart';
import 'package:dhgc_chat_app/src/core/utils/widgets/avatar.dart';
import 'package:dhgc_chat_app/src/features/list_conversations/presentation/widgets/search_bar.dart';
import 'package:dhgc_chat_app/src/features/list_conversations/presentation/widgets/conversation_card.dart';

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

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home Page'),
      //   backgroundColor: backgroundColor,
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to perform when the button is pressed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floating Action Button Pressed')),
          );
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
                  CircleAvatarWidget(imageUrl: user.imgUrl!, size: 60.0),
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
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffececf8),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ChatAppSearchBar(
                        onSearch: (query) {
                          // Handle search logic here
                          _searchQuery = query.cleanedQuery;
                          debugPrint('Search query: "$_searchQuery"');
                        },
                        hintText: 'Search by Receiver\'s Name',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          // Handle refresh logic here
                          debugPrint('Refresh triggered');
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: 10, // Replace with your actual data count
                          itemBuilder: (context, index) {
                            return ConversationCard(
                              conversationId: "${index + 1}",
                              receiverId: "${index + 11}",
                              receiverName: "User ${index + 11}",
                              receiverAvatar: "https://example.com/avatar.png",
                              lastMessage: "Hello, how are you?",
                              lastMessageAt: DateTime.now().subtract(
                                Duration(minutes: index * 5),
                              ),
                              isOnline:
                                  index % 2 ==
                                  0, // Example condition for online status
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.chat,
                                  arguments: {
                                    'conversationId': "${index + 1}",
                                    'receiverId': "${index + 11}",
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

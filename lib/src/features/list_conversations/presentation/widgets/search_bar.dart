import 'dart:async';

import 'package:flutter/material.dart';

class ChatAppSearchBar extends StatefulWidget {
  const ChatAppSearchBar({
    super.key,
    required this.onSearch,
    this.hintText = "",
  });

  final Function(String query)? onSearch;
  final String hintText;

  @override
  State<ChatAppSearchBar> createState() => _ChatAppSearchBarState();
}

class _ChatAppSearchBarState extends State<ChatAppSearchBar> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  Timer? _debounce;
  final int _debounceDuration = 1500; // milliseconds
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _debounce?.cancel();

    _searchController.dispose();
    _searchFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        // Handle search logic
        _onSearchChanged(value);
      },
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(Duration(milliseconds: _debounceDuration), () {
      if (query.toLowerCase() == _searchQuery.toLowerCase()) {
        debugPrint('No change in search query: "$query"');
        return; // No change in query, do nothing
      } else {
        _searchQuery = query;
        widget.onSearch?.call(_searchQuery);
      }
    });
  }
}

import 'package:animation_test/ChatDetail/ChatListItem.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatelessWidget {
  final Function(int) onChatTap;
  final double animationProgress;

  ChatsView({
    super.key,
    required this.onChatTap,
    required this.animationProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Opacity(
          opacity: 1 - animationProgress,
          child: AppBar(
            leading: IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Chats',
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black, fontSize: 42),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            color: Colors.blue,
            height: 50,
            margin: EdgeInsets.only(
              left: 8,
              right: 8 + animationProgress * MediaQuery.of(context).size.width,
            ),
          ),

          const SizedBox(height: 16),

          ChatItemList(onChatTap: _onChatTap),
        ],
      ),
    );
  }

  void _onChatTap(int index) {
    onChatTap(index);
  }
}

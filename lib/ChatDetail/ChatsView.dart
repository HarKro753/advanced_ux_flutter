import 'package:animation_test/ChatDetail/ChatItem.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key, required this.onChatTap});

  final Function(int) onChatTap;

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
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
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),

          const SizedBox(height: 16),

          ChatItemList(onChatTap: _onChatTap),
        ],
      ),
    );
  }

  void _onChatTap(int index) {
    widget.onChatTap(index);
  }
}

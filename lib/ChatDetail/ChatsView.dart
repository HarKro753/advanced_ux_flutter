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
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Opacity(
              opacity: (1 - animationProgress * 2).clamp(0, 1),
              child: Transform.translate(
                offset: Offset(animationProgress * 10, animationProgress * -50),
                child: Transform.scale(
                  scale: 1 - animationProgress * 0.2,
                  child: Text(
                    'Chats',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black, fontSize: 42),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            color: Colors.blue,
            height: 50,
            margin: EdgeInsets.only(
              left: 8,
              right:
                  8 +
                  animationProgress * MediaQuery.of(context).size.width * 0.95,
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

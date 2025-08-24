import 'package:flutter/material.dart';

class ChatItemList extends StatelessWidget {
  final Function(int)? onChatTap;

  const ChatItemList({super.key, this.onChatTap});

  @override
  Widget build(BuildContext context) {
    return buildChatList();
  }

  Widget buildChatList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          6 * 2 - 1,
          (i) => i.isEven
              ? buildChatItem(
                  color: Colors.primaries[(i ~/ 2) % Colors.primaries.length],
                  onTap: () => onChatTap?.call(i ~/ 2),
                )
              : const SizedBox(height: 12),
        ),
      ),
    );
  }

  Widget buildChatItem({required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: const Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.arrow_forward_ios, size: 20),
        ),
      ),
    );
  }
}

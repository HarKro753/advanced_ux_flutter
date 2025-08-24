import 'package:flutter/material.dart';

class ChatDetail extends StatelessWidget {
  final int index;
  final double animationProgress;
  final Function() onBack;

  ChatDetail({
    super.key,
    required this.index,
    required this.onBack,
    required this.animationProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Opacity(
          opacity: animationProgress,
          child: AppBar(
            title: Text('Chat Detail $index'),
            leading: IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back_ios_new),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.call)),
              IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Container(color: Colors.grey.shade200, height: 1),
            ),
          ),
        ),
      ),
      body: Center(child: Text('Chat Detail $index')),
    );
  }
}

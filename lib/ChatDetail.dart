import 'package:flutter/material.dart';

class ChatDetail extends StatelessWidget {
  final int index;
  final Function() onBack;

  const ChatDetail({super.key, required this.index, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Detail'),
        leading: IconButton(
          onPressed: onBack,
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
        ],
      ),
      body: Center(child: Text('Chat Detail $index')),
    );
  }
}

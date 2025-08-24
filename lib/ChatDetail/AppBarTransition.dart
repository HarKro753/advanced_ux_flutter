import 'package:animation_test/ChatDetail/ChatDetail.dart';
import 'package:animation_test/ChatDetail/ChatsView.dart';
import 'package:flutter/material.dart';

class AppBarTransition extends StatefulWidget {
  AppBarTransition({super.key});

  @override
  State<AppBarTransition> createState() => _AppBarTransitionState();
}

class _AppBarTransitionState extends State<AppBarTransition> {
  int? index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        ChatsView(
          onChatTap: (index) {
            setState(() {
              this.index = index;
            });
          },
        ),
        if (index != null)
          ChatDetail(
            index: index!,
            onBack: () {
              setState(() {
                this.index = null;
              });
            },
          ),
      ],
    );
  }
}

import 'package:animation_test/ChatDetail/ChatDetail.dart';
import 'package:animation_test/ChatDetail/ChatsView.dart';
import 'package:flutter/material.dart';

class AppBarTransition extends StatefulWidget {
  const AppBarTransition({super.key});

  @override
  State<AppBarTransition> createState() => _AppBarTransitionState();
}

class _AppBarTransitionState extends State<AppBarTransition>
    with TickerProviderStateMixin {
  int? index;

  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            _controller.forward();
          },
        ),
        if (index != null)
          AnimatedBuilder(
            animation: _offsetAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  _offsetAnimation.value * MediaQuery.of(context).size.width,
                  0,
                ),
                child: ChatDetail(
                  index: index!,
                  onBack: () {
                    _controller.reverse().then((_) {
                      setState(() {
                        index = null;
                      });
                    });
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}

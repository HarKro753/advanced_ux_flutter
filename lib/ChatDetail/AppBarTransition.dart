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
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Vereinfachte Animation: 0.0 = geschlossen, 1.0 = offen
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (index == null) return;

    final delta = details.delta.dx;
    final screenWidth = MediaQuery.of(context).size.width;
    final deltaPercent = delta / screenWidth;

    final newValue = (_controller.value - deltaPercent).clamp(0.0, 1.0);

    _controller.value = newValue;
  }

  void _onPanEnd(DragEndDetails details) {
    if (index == null) return;

    // Wenn weniger als 50% sichtbar, dann schließen
    bool shouldClose = _controller.value < 0.5;

    if (shouldClose) {
      _controller.animateTo(0.0, curve: Curves.easeOut).then((_) {
        setState(() {
          index = null;
        });
      });
    } else {
      // Zurück zur vollständig geöffneten Position
      _controller.animateTo(1.0, curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            Transform.translate(
              offset: Offset(
                -MediaQuery.of(context).size.width *
                    _slideAnimation.value *
                    0.1,
                0,
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(_slideAnimation.value * 0.3),
                  BlendMode.darken,
                ),
                child: ChatsView(
                  onChatTap: (index) {
                    setState(() {
                      this.index = index;
                    });
                    // Von 0.0 (geschlossen) zu 1.0 (offen)
                    _controller.forward();
                  },
                  animationProgress: _slideAnimation.value,
                ),
              ),
            ),

            if (index != null)
              GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: Transform.translate(
                  offset: Offset(
                    // 0.0 = komplett rechts (geschlossen), 1.0 = Position 0 (offen)
                    MediaQuery.of(context).size.width *
                        (1.0 - _slideAnimation.value),
                    0,
                  ),
                  child: ChatDetail(
                    index: index!,
                    animationProgress: _slideAnimation.value,
                    onBack: () {
                      _controller.reverse().then((_) {
                        setState(() {
                          index = null;
                        });
                      });
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

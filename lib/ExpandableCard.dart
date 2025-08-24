import 'package:flutter/material.dart';

class ExpandableCard extends StatefulWidget {
  const ExpandableCard({super.key});

  @override
  ExpandableCardState createState() => ExpandableCardState();
}

class ExpandableCardState extends State<ExpandableCard>
    with TickerProviderStateMixin {
  int? expandedIndex;
  Offset dragOffset = Offset.zero;
  bool isPanning = false;

  // Globale Keys um die Position und Größe der Karten zu tracken
  final Map<int, GlobalKey> cardKeys = {};

  // Animation Controller
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  // Gespeicherte Positionen für die Animation
  Rect? startRect;
  Rect? endRect;

  @override
  void initState() {
    super.initState();

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  // Berechnet die Position eines Widgets relativ zum Screen
  Rect? _getWidgetRect(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
  }

  void _expandCard(int cardIndex) {
    final key = cardKeys[cardIndex];
    if (key == null) return;

    setState(() {
      startRect = _getWidgetRect(key);
      endRect = Rect.fromLTWH(
        0,
        0,
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      );
      expandedIndex = cardIndex;
    });

    _expandController.forward();
  }

  void _collapseCard() {
    _expandController.reverse().then((_) {
      setState(() {
        expandedIndex = null;
        dragOffset = Offset.zero;
        isPanning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Liste mit Karten
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: 10,
            itemBuilder: (context, index) {
              // Erstelle einen Key für jede Karte
              cardKeys[index] ??= GlobalKey();

              return GestureDetector(
                onTap: () => _expandCard(index),
                child: AnimatedBuilder(
                  animation: _expandController,
                  builder: (context, child) {
                    final opacity = expandedIndex == index
                        ? (1.0 - _expandAnimation.value)
                        : 1.0;
                    return Opacity(
                      opacity: opacity,
                      child: Container(
                        key: cardKeys[index],
                        height: 120,
                        decoration: BoxDecoration(
                          color: _getCardColor(index),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Karte $index",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Expandierte Karte mit Animation
          if (expandedIndex != null && startRect != null && endRect != null)
            AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                final dragDistance = dragOffset.distance;
                final baseScale = (1 - dragDistance * 0.0015).clamp(0.7, 1.0);
                final dragScale =
                    baseScale + (1 - baseScale) * (1 - _expandAnimation.value);

                final rect = Rect.lerp(
                  startRect!,
                  endRect!,
                  _expandAnimation.value,
                )!;

                final borderRadius = BorderRadius.circular(
                  20 * (1 - _expandAnimation.value) +
                      (dragDistance * 0.05).clamp(0, 20),
                );

                print("DragScale: $dragScale");

                return Positioned(
                  left: rect.left + dragOffset.dx * _expandAnimation.value,
                  top: rect.top + dragOffset.dy * _expandAnimation.value,
                  width: rect.width,
                  height: rect.height,
                  child: Transform.scale(
                    scale: 1.0,
                    child: GestureDetector(
                      onTap: _expandAnimation.value == 1.0
                          ? _collapseCard
                          : null,
                      onPanStart: (details) {
                        if (_expandAnimation.value == 1.0) {
                          // Nur von der linken Seite aus draggen erlauben
                          if (details.globalPosition.dx <
                              MediaQuery.of(context).size.width * 0.3) {
                            isPanning = true;
                          }
                        }
                      },
                      onPanUpdate: (details) {
                        if (isPanning && _expandAnimation.value == 1.0) {
                          setState(() {
                            dragOffset += details.delta;
                            // Beschränke negative X-Werte
                            if (dragOffset.dx < 0) {
                              dragOffset = Offset(0, dragOffset.dy);
                            }
                          });
                        }
                      },
                      onPanEnd: (details) {
                        if (isPanning) {
                          if (dragOffset.distance > 150) {
                            _collapseCard();
                          } else {
                            setState(() {
                              dragOffset = Offset.zero;
                            });
                          }
                          isPanning = false;
                        }
                      },
                      child: AnimatedContainer(
                        duration: isPanning
                            ? Duration.zero
                            : const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: _getCardColor(expandedIndex!),
                          borderRadius: borderRadius,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.3 * _expandAnimation.value * dragScale,
                              ),
                              blurRadius: 20 * _expandAnimation.value,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: borderRadius,
                          child: Stack(
                            children: [
                              // Minimaler Content für kleine Karte
                              if (_expandAnimation.value < 0.5)
                                Center(
                                  child: Text(
                                    "Karte $expandedIndex",
                                    style: TextStyle(
                                      color: _getCardColor(expandedIndex!),
                                      fontSize:
                                          20 * (1 - _expandAnimation.value * 2),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                              // Detaillierter Content für expandierte Karte
                              if (_expandAnimation.value > 0.3)
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: (_expandAnimation.value - 0.3) / 0.7,
                                  child: SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      height: MediaQuery.of(
                                        context,
                                      ).size.height,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Header mit Close Button
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Detailansicht",
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontSize: 16,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                onPressed: _collapseCard,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 40),
                                          // Titel
                                          Text(
                                            "Karte $expandedIndex",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          // Inhalt
                                          Text(
                                            "Dies ist der erweiterte Inhalt für Karte $expandedIndex.\n\n"
                                            "Swipe von links in beliebige Richtung um die Karte zu bewegen. "
                                            "Die Karte wird kleiner je weiter du sie ziehst.\n\n"
                                            "Lasse los um zurückzuspringen oder ziehe weit genug um zu schließen.",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              fontSize: 18,
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              // Drag Indicator (nur wenn expandiert)
                              if (_expandAnimation.value > 0.8)
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity:
                                        (_expandAnimation.value - 0.8) *
                                        5 *
                                        dragScale,
                                    child: Center(
                                      child: Container(
                                        width: 3,
                                        height: 40,
                                        margin: const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(
                                            1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // Helper Funktion für Farben
  Color _getCardColor(int index) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }
}

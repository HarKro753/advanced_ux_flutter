import 'package:animation_test/AppBarTransition.dart';
import 'package:animation_test/ChatsView.dart';
import 'package:animation_test/ExpandableCard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AppBarTransition(),
    );
  }
}

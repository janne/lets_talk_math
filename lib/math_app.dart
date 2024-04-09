import 'package:flutter/material.dart';
import 'package:lets_talk_math/home_page.dart';

class MathApp extends StatelessWidget {
  const MathApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Let's talk math!",
      home: MyHomePage(),
    );
  }
}

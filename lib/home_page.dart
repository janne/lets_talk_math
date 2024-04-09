import 'dart:math';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_talk_math/speech.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? op1;
  int? op2;

  @override
  void initState() {
    OpenAI.apiKey = dotenv.env['OPEN_AI_API_KEY']!;
    generateSpeech("Let's talk math!").then((_) => _generateMath());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (op1 != null && op2 != null) Text('$op1 * $op2 = ?'),
            TextButton(
              onPressed: () => _generateMath(),
              child: const Text("Regenerate"),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ],
        ),
      ),
    );
  }

  Future<void> _generateMath() async {
    setState(() {
      op1 = Random().nextInt(1000);
      op2 = Random().nextInt(8) + 2;
    });
    await generateSpeech("What is $op1 multiplied by $op2?");
  }
}

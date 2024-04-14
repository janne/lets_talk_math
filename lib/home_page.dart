import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_talk_math/math.dart';
import 'package:lets_talk_math/speech.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const count = 10;
const time = 7;

class _MyHomePageState extends State<MyHomePage> {
  late List<int> nums;
  late int? index;
  var counter = Duration.zero;
  Timer? timer;
  var paused = false;

  @override
  void initState() {
    OpenAI.apiKey = dotenv.env['OPEN_AI_API_KEY']!;
    say("Let's talk math!");
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: _restart, icon: const Icon(Icons.restart_alt)),
        title: const Text("Let's talk math!"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: switch (index) {
              null => [
                  ElevatedButton(onPressed: () => _start(), child: const Text("Start")),
                ],
              count => [
                  Text("${_sum()}", style: textTheme.displayLarge),
                  ElevatedButton(
                      onPressed: () {
                        _init();
                        _start();
                      },
                      child: const Text("New")),
                ],
              _ => [
                  Column(
                    children: [
                      Text("${nums[index!]}", style: textTheme.displayLarge),
                      Text(paused ? "Sum: ${nums.take(index!).fold(0, (a, b) => a + b)}" : counter.toString().substring(2, 7),
                          style: textTheme.headlineSmall!.copyWith(color: Colors.grey)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: _restart, child: const Icon(Icons.fast_rewind)),
                      ElevatedButton(onPressed: index == 0 ? null : () => _next(-1), child: const Icon(Icons.arrow_left)),
                      ElevatedButton(onPressed: _pause, child: Icon(paused ? Icons.pause : Icons.play_arrow)),
                      ElevatedButton(onPressed: index == nums.length - 1 ? null : _next, child: const Icon(Icons.arrow_right)),
                      ElevatedButton(onPressed: _init, child: const Icon(Icons.fast_forward)),
                    ],
                  ),
                ]
            }),
      ),
    );
  }

  void _pause() {
    setState(() {
      paused = !paused;
      counter = const Duration(seconds: time);
    });
    if (paused) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _everySecond(Timer timer) {
    if (!paused) {
      setState(() {
        if (counter > Duration.zero) {
          setState(() {
            counter = counter - const Duration(seconds: 1);
          });
        } else {
          _next();
        }
      });
    }
  }

  void _stopTimer() {
    timer?.cancel();
    WakelockPlus.disable();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), _everySecond);
    WakelockPlus.enable();
  }

  void _start() async {
    setState(() {
      index = 0;
      counter = const Duration(seconds: time);
    });
    await sayNumber(nums[index!]);
    _startTimer();
  }

  void _next([int step = 1]) async {
    if (index! == nums.length) return;
    _stopTimer();
    setState(() {
      index = index! + step;
      counter = const Duration(seconds: time);
    });
    if (index! < nums.length) {
      await sayNumber(nums[index!]);
      _startTimer();
    } else {
      say("Done! The sum is ${_sum()}.");
    }
  }

  int _sum() => nums.reduce((a, b) => a + b);

  void _init() {
    _stopTimer();
    setState(() {
      nums = generateNums(count: count);
      index = null;
      counter = Duration.zero;
    });
  }

  void _restart() async {
    setState(() {
      index = 0;
      counter = const Duration(seconds: time);
    });
    _startTimer();
    await sayNumber(nums[index!]);
  }
}

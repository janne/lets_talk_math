import 'package:flutter_tts/flutter_tts.dart';

final flutterTts = FlutterTts();

Future<void> sayNumber(int num) async {
  await flutterTts.speak(num.toString());
  await flutterTts.awaitSpeakCompletion(true);
}

Future<void> say(String text) async {
  await flutterTts.speak(text);
  await flutterTts.awaitSpeakCompletion(true);
}

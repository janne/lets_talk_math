import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dart_openai/dart_openai.dart';

final player = AudioPlayer();
final openAI = OpenAI.instance;

Future<void> generateSpeech(String input) async {
  final file = await openAI.audio.createSpeech(
    model: "tts-1",
    input: input,
    voice: "nova",
    outputDirectory: Directory.systemTemp,
  );

  await player.play(DeviceFileSource(file.path, mimeType: "audio/mp3"));
}

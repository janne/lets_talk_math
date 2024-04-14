import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:path_provider/path_provider.dart';

final player = AudioPlayer();
final openAI = OpenAI.instance;

Future<File> generateSpeech(String input) async {
  final dir = await getApplicationDocumentsDirectory();
  final fileName = input.replaceAll(RegExp(r"[?.!']"), "").replaceAll(" ", "_").toLowerCase();
  final fromCache = File("${dir.path}/$fileName.mpeg");
  if (await fromCache.exists()) {
    return fromCache;
  }

  return await openAI.audio.createSpeech(
    model: "tts-1",
    input: input,
    voice: "nova",
    outputDirectory: dir,
    outputFileName: fileName,
  );
}

Future<void> playFile(File file) async {
  await player.play(DeviceFileSource(file.path, mimeType: "audio/mp3"));
  await player.onPlayerStateChanged.firstWhere((event) => event == PlayerState.completed);
}

Future<void> sayNumber(int num) async {
  final file = await generateSpeech("Add ${num.toString().split("").join(" ")}.");
  await playFile(file);
}

Future<void> say(String text) async {
  final file = await generateSpeech(text);
  await playFile(file);
}

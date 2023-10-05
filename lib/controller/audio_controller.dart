import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  Rx<Duration> duration = const Duration(seconds: 0).obs;
  Rx<Duration> position = const Duration(seconds: 0).obs;

  Rx<bool> isPlaying = false.obs;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    audioPlayer.onPlayerStateChanged.listen((status) {
      isPlaying.value = status == PlayerState.playing;
    });
    audioPlayer.onDurationChanged.listen((event) {
      duration.value = event;
    });
    audioPlayer.onPositionChanged.listen((event) {
      position.value = event;
    });
  }

  void getAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      audioPlayer.setReleaseMode(ReleaseMode.loop);
      audioPlayer.play(
        DeviceFileSource(
          file.path,
        ),
      );
    }
  }

  void sliderChange(double value) async {
    final newPosition = Duration(seconds: value.toInt());
    await audioPlayer.seek(newPosition);
    await audioPlayer.resume();
  }

  void toggle() async {
    if (isPlaying.value) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.resume();
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}

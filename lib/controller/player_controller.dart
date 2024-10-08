import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';

class PlayerController extends GetxController {
  FlutterSoundPlayer? _player;
  var isPlaying = false.obs;
  var currentPath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _player = FlutterSoundPlayer();
    _player!.openPlayer();
  }

  Future<void> playAudio(String path) async {
    if (currentPath.value == path && isPlaying.value) {
      await _player!.pausePlayer();
      isPlaying(false);
    } else {
      currentPath.value = path;
      await _player!.startPlayer(fromURI: path);
      isPlaying(true);
    }
  }

  @override
  void onClose() {
    _player!.closePlayer();
    super.onClose();
  }
}

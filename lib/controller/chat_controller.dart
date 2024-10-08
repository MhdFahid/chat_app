import 'package:get/get.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/message_model.dart';

class ChatController extends GetxController {
  var messages = <ChatMessage>[].obs;
  var isRecording = false.obs;
  var currentAudioPath = ''.obs;
  var selectedStatus = 'All'.obs;

  FlutterSoundRecorder? _audioRecorder;

  @override
  void onInit() {
    super.onInit();
    _audioRecorder = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _audioRecorder!.openRecorder();
    await _audioRecorder!
        .setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    super.onClose();
  }

  void addMessage(ChatMessage message) {
    messages.add(message);
  }

  void toggleRecording() async {
    if (!_audioRecorder!.isRecording) {
      
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        
        Get.snackbar('Permission Denied',
            'Microphone permission is required to record audio.');
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final path =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';

      await _audioRecorder!.startRecorder(
        toFile: path,
        codec: Codec.aacMP4,
      );
      currentAudioPath.value = path;
      isRecording.value = true;
    } else {
      
      await _audioRecorder!.stopRecorder();
      isRecording.value = false;
      sendVoiceMessage(); 
    }
  }

  void sendVoiceMessage() {
    if (currentAudioPath.value.isNotEmpty) {
      final message = ChatMessage(
        content: 'Voice Message',
        status: 'Pending',
        isVoiceMessage: true,
        audioPath: currentAudioPath.value,
      );
      addMessage(message);
      currentAudioPath.value = '';
    }
  }

  void updateStatus(String status) {
    selectedStatus.value = status;
  }
}

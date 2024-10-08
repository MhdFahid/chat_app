class ChatMessage {
  String content;
  String status;
  bool isVoiceMessage;
  String? audioPath;

  ChatMessage({
    required this.content,
    required this.status,
    required this.isVoiceMessage,
    this.audioPath,
  });
}

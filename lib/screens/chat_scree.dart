import 'package:chat_app/consts/app_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';

import '../models/message_model.dart';

class ChatScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final TextEditingController textController = TextEditingController();

  ChatScreen({super.key});

  void sendMessage() {
    if (textController.text.isNotEmpty) {
      final message = ChatMessage(
        content: textController.text,
        status: 'Pending',
        isVoiceMessage: false,
      );
      chatController.addMessage(message);
      textController.clear();
    }
  }

  void attachFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final fileName = result.files.single.name;
      final message = ChatMessage(
        content: 'Attached File: $fileName',
        status: 'Pending',
        isVoiceMessage: false,
      );
      chatController.addMessage(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 203, 203),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColorsConstants.whiteColor,
          leading: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.arrow_back_ios_new),
              ),
              Container(
                height: 45,
                width: 45,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 225, 220, 220),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'Michael Knight',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              )
            ],
          ),
          leadingWidth: size.width * 0.7,
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColorsConstants.whiteColor,
              boxShadow: const [BoxShadow(color: Colors.grey)],
              border: Border.all(color: const Color.fromARGB(6, 210, 210, 210)),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['All', 'Unread', 'Approved', 'Declined', 'Pending']
                      .map((status) {
                    return Obx(() {
                      Color chipColor;
                      Color textColor;

                      switch (status) {
                        case 'Unread':
                          chipColor = const Color.fromARGB(255, 235, 229, 229);
                          textColor = const Color.fromARGB(255, 0, 0, 0);
                          break;
                        case 'Approved':
                          chipColor = const Color.fromARGB(255, 115, 240, 138);
                          textColor = const Color.fromARGB(255, 23, 166, 23);
                          break;
                        case 'Declined':
                          chipColor = const Color.fromARGB(255, 241, 186, 186);
                          textColor = const Color.fromARGB(255, 224, 17, 17);
                          break;
                        case 'Pending':
                          chipColor = const Color.fromARGB(133, 222, 195, 139);
                          textColor = const Color.fromARGB(255, 255, 170, 0);
                          break;
                        default:
                          chipColor = Colors.black;
                          textColor = Colors.white;
                      }

                      bool isSelected =
                          chatController.selectedStatus.value == status;
                      if (isSelected) {
                        chipColor = Colors.blue;
                        textColor = Colors.white;
                      }

                      return GestureDetector(
                        onTap: () {
                          chatController.updateStatus(status);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: chipColor),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 7),
                              child: Text(
                                status,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              var filteredMessages = chatController.messages.where((message) {
                if (chatController.selectedStatus.value == 'All') {
                  return true;
                } else {
                  return message.status == chatController.selectedStatus.value;
                }
              }).toList();

              return ListView.builder(
                itemCount: filteredMessages.length,
                itemBuilder: (context, index) {
                  final message = filteredMessages[index];
                  if (message.isVoiceMessage && message.audioPath != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AudioPlayerWidget(audioPath: message.audioPath!),
                    );
                  } else {
                    return Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(message.content),
                                ),
                              ]),
                        ),
                      ],
                    );
                  }
                },
              );
            }),
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(95, 241, 227, 227),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 17),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Type here...',
                                      border: InputBorder.none,
                                    ),
                                    controller: textController,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.attach_file,
                                      color: Colors.blue),
                                  onPressed: attachFile,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 235, 244, 251),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send,
                              color: Color.fromARGB(255, 71, 67, 67)),
                          onPressed: sendMessage,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          icon: Icon(
                            chatController.isRecording.value
                                ? Icons.stop
                                : Icons.mic,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            chatController.toggleRecording();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AudioPlayerWidget1 extends StatelessWidget {
  final RxBool isPlaying = false.obs;
  final RxBool isExpande = false.obs;

  final String audioPath;
  AudioPlayerWidget1({super.key, required this.audioPath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(left: 60),
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onLongPress: () {},
            onTap: () {
              isExpande.value = !isExpande.value;
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      return IconButton(
                        icon: Icon(
                          isPlaying.value ? Icons.pause : Icons.play_arrow,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          isPlaying.value = !isPlaying.value;
                        },
                      );
                    }),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Slider(
                            value: 0,
                            max: 2,
                            activeColor: Colors.blue,
                            inactiveColor: Colors.grey,
                            onChanged: (value) {
                              value = value;
                            },
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Pending',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.check,
                                  size: 16, color: Colors.black54),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Obx(() => isExpande.value
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpansionTile(
                                title: Text('Transcript'),
                                children: [
                                  Text(
                                      "Wanted to place an order for a few items. Here's what 1 need: First, 50 units of the Classic Leather Wallet inblack. Next,30 units of the Summer Floral Dress")
                                ],
                              ),
                              ExpansionTile(title: Text('Order List')),
                              Text('Order No:2664545'),
                              Text('Approved by Dp on 02:30pm, 15/07/2024')
                            ]),
                      )
                    : const SizedBox())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  const AudioPlayerWidget({super.key, required this.audioPath});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  FlutterSoundPlayer? _audioPlayer;
  bool isPlaying = false;
  double currentPosition = 0.0;
  double maxDuration = 1.0;
  final RxBool isExpande = false.obs;

  @override
  void initState() {
    super.initState();
    _audioPlayer = FlutterSoundPlayer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    await _audioPlayer!.openPlayer();
    _audioPlayer!.onProgress!.listen((event) {
      setState(() {
        currentPosition = event.position.inMilliseconds.toDouble();
        maxDuration = event.duration.inMilliseconds.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer!.closePlayer();
    _audioPlayer = null;
    super.dispose();
  }

  void _playPause() async {
    if (!_audioPlayer!.isPlaying) {
      await _audioPlayer!.startPlayer(
        fromURI: widget.audioPath,
        codec: Codec.aacMP4,
        whenFinished: () {
          setState(() {
            isPlaying = false;
            currentPosition = 0.0;
          });
        },
      );
      setState(() {
        isPlaying = true;
      });
    } else {
      await _audioPlayer!.pausePlayer();
      setState(() {
        isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: InkWell(
        onTap: () {
          isExpande.value = !isExpande.value;
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              ListTile(
                leading: IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _playPause,
                ),
                title: Slider(
                  value: currentPosition,
                  max: maxDuration > 0 ? maxDuration : 1.0,
                  onChanged: (value) async {
                    await _audioPlayer!
                        .seekToPlayer(Duration(milliseconds: value.toInt()));
                  },
                ),
                subtitle: Text(
                  "${(currentPosition / 1000).toStringAsFixed(1)} / ${(maxDuration / 1000).toStringAsFixed(1)} sec",
                ),
              ),
              Obx(() => isExpande.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ExpansionTile(
                              title: Text('Transcript'),
                              children: [
                                Text(
                                    "Wanted to place an order for a few items. Here's what 1 need: First, 50 units of the Classic Leather Wallet inblack. Next,30 units of the Summer Floral Dress")
                              ],
                            ),
                            const ExpansionTile(title: Text('Order List')),
                            const Text('Order No:2664545'),
                            Container(
                              child: const Text(
                                  'Approved by Dp on 02:30pm, 15/07/2024'),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ]),
                    )
                  : const SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}

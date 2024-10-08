import 'package:flutter/material.dart';

import '../consts/app_color_constants.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColorsConstants.backgroundColor,
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
          actions: [
            const Padding(
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
                border: Border.all(color: const Color.fromARGB(6, 0, 0, 0))),
            width: double.infinity,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FilterChip(
                        color: Colors.black,
                        text: 'All',
                        textcolor: Colors.white),
                    FilterChip(
                        color: Color.fromARGB(255, 235, 229, 229),
                        text: 'Unread',
                        textcolor: Color.fromARGB(255, 0, 0, 0)),
                    FilterChip(
                        color: Color.fromARGB(255, 115, 240, 138),
                        text: 'Approved',
                        textcolor: Color.fromARGB(255, 23, 166, 23)),
                    FilterChip(
                        color: Color.fromARGB(255, 241, 186, 186),
                        text: 'Declined',
                        textcolor: Color.fromARGB(255, 224, 17, 17)),
                    FilterChip(
                        color: Color.fromARGB(133, 222, 195, 139),
                        text: 'Pending',
                        textcolor: Color.fromARGB(255, 255, 170, 0)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                LabelDate(
                    color: Color.fromARGB(255, 235, 229, 229),
                    text: 'August',
                    textcolor: Color.fromARGB(255, 0, 0, 0)),
                ChatCard(
                  transcript: 'Transcript',
                  orderList: 'Order No: 15544',
                  status: 'Approved by DP on 02:30pm, 15/07/2024',
                  messageTime: '12:38 pm',
                ),
                SentMessage(message: 'Ok, Got it!', time: '12:38 pm'),
                VoiceMessage(duration: '01:23', time: '12:38 pm'),
              ],
            ),
          ),
          // ChatInput(
          //   controller: TextEditingController(),
          //   attachFileTap: () {},
          //   mainButtonTap: () {},
          //   iconColor: i,
          //   icon: null,
          // ),
        ],
      ),
    );
  }
}

class FilterChip extends StatelessWidget {
  const FilterChip({
    super.key,
    required this.color,
    required this.text,
    required this.textcolor,
  });
  final Color color, textcolor;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            text,
            style: TextStyle(
                color: textcolor, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        )),
      ),
    );
  }
}

class LabelDate extends StatelessWidget {
  const LabelDate({
    super.key,
    required this.color,
    required this.text,
    required this.textcolor,
  });
  final Color color, textcolor;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7.0),
          child: Container(
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                text,
                style: TextStyle(
                  color: textcolor,
                  fontSize: 12,
                ),
              ),
            )),
          ),
        ),
      ],
    );
  }
}

class ChatCard extends StatelessWidget {
  final String transcript;
  final String orderList;
  final String status;
  final String messageTime;

  ChatCard({
    super.key,
    required this.transcript,
    required this.orderList,
    required this.status,
    required this.messageTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.play_circle_fill, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(transcript),
                ],
              ),
              const SizedBox(height: 10),
              Text(orderList),
              const SizedBox(height: 5),
              Text(
                status,
                style: const TextStyle(color: Colors.green),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(messageTime,
                    style: const TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SentMessage extends StatelessWidget {
  final String message;
  final String time;

  SentMessage({super.key, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(message),
            ),
            const SizedBox(height: 5),
            Text(time, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class VoiceMessage extends StatelessWidget {
  final String duration;
  final String time;

  VoiceMessage({super.key, required this.duration, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.play_circle_fill, color: Colors.blue),
                const SizedBox(width: 10),
                Text(duration),
              ],
            ),
            const SizedBox(height: 5),
            Text(time, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  const ChatInput(
      {super.key,
      required this.controller,
      required this.attachFileTap,
      required this.mainButtonTap,
      required this.icon,
      required this.iconColor});
  final TextEditingController controller;
  final void Function() attachFileTap;
  final void Function() mainButtonTap;
  final IconData icon;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                            decoration: InputDecoration(
                              hintText: 'Type here...',
                              border: InputBorder.none,
                            ),
                            controller: controller,
                            onChanged: (v) {
                              controller.text = v;
                            },
                          ),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.attach_file, color: Colors.blue),
                          onPressed: attachFileTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 235, 244, 251)),
                child: IconButton(
                  icon:
                      Icon(Icons.send, color: Color.fromARGB(255, 71, 67, 67)),
                  onPressed: mainButtonTap,
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue),
                child: IconButton(
                  icon: Icon(icon, color: Color.fromARGB(255, 255, 255, 255)),
                  onPressed: mainButtonTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

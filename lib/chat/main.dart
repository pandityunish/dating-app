import 'package:flutter/material.dart';

import 'package:ristey/chat/screens/mobile_layout_screen.dart';

class ChatPageHome extends StatefulWidget {
  const ChatPageHome({Key? key}) : super(key: key);

  @override
  State<ChatPageHome> createState() => _ChatPageHomeState();
}

class _ChatPageHomeState extends State<ChatPageHome> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MobileLayoutScreen(),
    );
  }
}

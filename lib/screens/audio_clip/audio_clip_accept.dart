// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:vibration/vibration.dart';

import 'package:ristey/chat/colors.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/audio_clip/listen_audio_clip.dart';
import 'package:ristey/services/audio_call.dart';
import 'package:ristey/services/call_controller.dart';

class IncomingAudioClipScreen extends StatefulWidget {
  String? audioUrl;
  IncomingAudioClipScreen({
    Key? key,
    this.audioUrl,
  }) : super(key: key);

  @override
  State<IncomingAudioClipScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingAudioClipScreen> {
  @override
  void initState() {
    super.initState();
    _startVibration();
  }

  Future<void> _startVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(
          pattern: [500, 1000, 500, 1000],
          repeat: 2); // Vibrate for 5 seconds (adjustable)
      print('Vibration started for incoming call');
    } else {
      print('Device does not support vibration');
    }
  }

  @override
  void dispose() {
    Vibration.cancel(); // Stop vibration when leaving the screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.2,
                  ),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("images/newlogo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Free Ristehy Wala",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                
                  SizedBox(height: 1),
                  Text("Incoming Audio Clip",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Vibration.cancel();
                         SupprotService().deletesendlink(
                                      email: userSave.email!,
                                      value: "Audio Clip");
                      Get.back();
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Color(0xFFFF4D4D), shape: BoxShape.circle),
                      child: Center(
                          child: Icon(Icons.call_end,
                              color: Colors.white, size: 30)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Vibration.cancel();
                        SupprotService().deletesendlink(
                                      email: userSave.email!,
                                      value: "Audio Clip");
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ListenAudioClip(audioClip:widget. audioUrl??"", callStartTime: DateTime.now()),));
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Color(0xFF33FF00), shape: BoxShape.circle),
                      child: Center(
                          child: Icon(Icons.call_end,
                              color: Colors.white, size: 30)),
                    ),
                  ),
                  // SizedBox(width: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

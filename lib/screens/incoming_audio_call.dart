import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ristey/chat/colors.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/services/audio_call.dart';
import 'package:ristey/services/call_controller.dart';
import 'package:vibration/vibration.dart';

class IncomingAudioCallScreen extends StatefulWidget {
  @override
  State<IncomingAudioCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingAudioCallScreen> {
  @override
  void initState() {
    super.initState();
    _startVibration();
  }

  Future<void> _startVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: 2); // Vibrate for 5 seconds (adjustable)
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
    final AudioNewCallController callController = Get.find();
    final arguments = Get.arguments;
    final callerId = arguments['callerId']??"";
    final profilename = arguments['profilename'];
    final profileid = arguments['calleeId'];
    final profilePic = arguments['profilePic'];
    final uid = arguments['uid'];

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
                                            image: NetworkImage(profilePic),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                     profilename!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                      uid,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                               Text("Incoming Audio Call",
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                               SizedBox(height: 20),
                 ],
               ),
             ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Vibration.cancel();
                        Get.back();
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF4D4D),
                        shape: BoxShape.circle
                      ),
                      child: Center(child: Icon(Icons.call_end, color: Colors.white, size: 30)),
                    ),
                  ),
                   InkWell(
                    onTap: () {
                      Vibration.cancel();
                        log('Renderers initialized');
                        if (callController.peerConnection == null) {
                          // Only init if not already set
                          callController.initWebRTC().then((_) {
                            log('WebRTC initialized on CallScreen');
                          });
                        } else {
                          log('WebRTC already initialized, skipping');
                        }
                
                      setState(() {});
                    
                      callController.startCall(callerId,profilePic,profilename,uid);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF33FF00),
                        shape: BoxShape.circle
                      ),
                      child: Center(child: Icon(Icons.call_end, color: Colors.white, size: 30)),
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

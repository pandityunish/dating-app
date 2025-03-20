// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/services/audio_call.dart';

import '../../models/new_user_modal.dart';

class AudioCall extends StatefulWidget {
  final String profilepic;
  final String profileId;
  final String profileName;
  final String uid;
  final DateTime callStartTime;
  const AudioCall({
    Key? key,
    required this.profilepic, required this.profileId, required this.profileName, required this.uid, required this.callStartTime,
    
  }) : super(key: key);

  @override
  State<AudioCall> createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCall> {
  bool isAudio = false;
  bool isSpeaker = false;
  bool isButton = false;
  late Timer _timer;
  Duration _elapsedTime = Duration.zero;
    final AudioNewCallController callController = Get.find();

  @override
  void initState() {
    super.initState();
      if(callController.inCall.value==false){
 callController.requestCall(widget.profileId,widget.profilepic,widget.profileName,widget.uid);

  
      log('Renderers initialized');
      if (callController.peerConnection == null) {
        // Only init if not already set
        callController.initWebRTC().then((_) {
          log('WebRTC initialized on CallScreen');
          setState(() {}); // Force rebuild to show local video
        });
      } else {
        log('WebRTC already initialized, skipping');
        setState(() {}); // Ensure UI reflects existing state
      }
    }
    _startTimer();
  }

  void _startTimer() {
    _elapsedTime = DateTime.now().difference(widget.callStartTime);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime = DateTime.now().difference(widget.callStartTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    callController.endCall();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF38B9F3),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        backgroundColor: Color(0xFF38B9F3),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(widget.profilepic),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                   widget.profileName,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.uid,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Outgoing Audio Call",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  SizedBox(height: 10,),
                 
            SizedBox(height: 10),
          callController.inCall.value==true?  Text(
              '${_formatDuration(_elapsedTime)}',
              style: TextStyle(fontSize: 18),
            ):Center(),
                ],
              ),
            ),
            isButton
                ? Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isButton = !isButton;
                          });
                          
                        },
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.more_vert),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      InkWell(
                        onTap: () {
                          callController.endCall();
                        },
                        child: Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                          child: Center(
                            child: Icon(
                              Icons.call_end,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: Get.width * 0.5,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isSpeaker=!isSpeaker;
                                  });
                                  callController.toggleSpeaker();
                                },
                                child: Image.asset("images/icons/Speaker.png",color:isSpeaker? mainColor:Colors.black,)),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      isButton = !isButton;
                                    });
                                  },
                                  child: Icon(Icons.more_vert)),
                            isAudio?
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isAudio=!isAudio;
                                });
                                callController.toggleMic();
                              },
                              child: Icon(Icons.mic_off)):
                            InkWell(
                               onTap: () {
                                setState(() {
                                  isAudio=!isAudio;
                                });
                              },
                              child: Icon(Icons.mic))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

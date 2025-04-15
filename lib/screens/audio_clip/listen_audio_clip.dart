// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/audio_clip/model/audio_clip_model.dart';
import 'package:ristey/screens/audio_clip/service/audio_clip_service.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/services/audio_call.dart';

import '../../models/new_user_modal.dart';

class ListenAudioClip extends StatefulWidget {
  final String audioClip;

  final DateTime callStartTime;
  const ListenAudioClip({
    Key? key,
    required this.audioClip, required this.callStartTime,
    
  }) : super(key: key);

  @override
  State<ListenAudioClip> createState() => _AudioCallState();
}

class _AudioCallState extends State<ListenAudioClip> {
  bool isAudio = false;
  bool isSpeaker = false;
  bool isButton = false;
  late Timer _timer;
  Duration _elapsedTime = Duration.zero;
  AudioClipModel ?allClipModel;
final AudioPlayer _audioPlayer = AudioPlayer();
Duration? _audioDuration;
Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    if(widget.audioClip.isEmpty){
      getAudioClip();
    }else{
      _setupAudio(widget.audioClip);
    }
  }
Future<void> _setupAudio(String url) async {
  try {
    await _audioPlayer.setUrl(url); // Load audio
    _audioDuration = _audioPlayer.duration;

    _audioPlayer.play(); // Start playing

    // Track current position
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    // Detect when playback finishes
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Navigate to another screen after audio ends
        _navigateToNextScreen();
      }
    });

  } catch (e) {
    log('Error loading audio: $e');
  }
}
void _navigateToNextScreen() {
  // Replace with your actual navigation logic
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => MainAppContainer(notiPage: false,), // Replace with your target widget
    ),
  );
}

void getAudioClip()async{
PaginatedAudioClip? allclips= await AudioClipService(). fetchAudioClips(userSave.email??"");
allClipModel=allclips?.users[0];
 if (allClipModel != null) {
    await _setupAudio(allClipModel!.audioLink ?? "");
  }
}


  @override
  void dispose() {
    _timer.cancel();
  _audioPlayer.dispose();
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
                         image: AssetImage("images/newlogo.png"),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                   "Free Rishtey Wala",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                 
                 
                 
      
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
                      ),
                       if (_audioDuration != null) 
  Text(
    "${_formatDuration(_audioDuration! - _currentPosition)}",
    style: TextStyle(color: Colors.white, fontSize: 16),
  ),
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

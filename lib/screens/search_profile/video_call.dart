// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:ristey/services/call_controller.dart';

import '../../global_vars.dart';
import '../../models/new_user_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/new_user_modal.dart';

class VideoCall extends StatefulWidget {
  final String profilepic;
  final String? currentProfilePic;
  final String? profileId;
  final String? profileName;
  final String? uid;

  const VideoCall({
    Key? key,
    required this.profilepic,
   this.currentProfilePic, this.profileId, this.profileName, this.uid,
  }) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  bool isAudio = false;
  bool isSpeaker = false;
  bool isButton = false;
  final NewCallController callController = Get.find();

  @override
  void initState() {
    super.initState();
    print('CallScreen initState');
    if(callController.inCall.value==false){
 callController.requestCall(widget.profileId!,widget.currentProfilePic!,widget.profileName!,widget.uid!);

    callController.initRenderers().then((_) {
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
    });
    }
   
  }

  @override
  void dispose() {
    print('CallScreen dispose');
    callController.endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF38B9F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: GetBuilder<NewCallController>(
        builder: (controller) {
          print('Rebuilding CallScreen: inCall=${controller.inCall.value}, '
              'remoteSrc=${controller.remoteRenderer.srcObject != null}');
          return controller.remoteRenderer.srcObject != null
              ? Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          controller.remoteRenderer.srcObject != null
                              ? RTCVideoView(
                                  controller.remoteRenderer,
                                  mirror: false,
                                  objectFit: RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitContain,
                                )
                              : Container(
                                  color: Colors.grey,
                                  child: Center(child: Text('No remote video')),
                                ),
                          Positioned(
                            right: 10,
                            top: 30,
                            width: 100,
                            height: 150,
                            child: controller.localRenderer.srcObject != null
                                ? RTCVideoView(
                                    controller.localRenderer,
                                    mirror: true,
                                    objectFit: RTCVideoViewObjectFit
                                        .RTCVideoViewObjectFitContain,
                                  )
                                : Container(
                                    color: Colors.black,
                                    child:
                                        Center(child: Text('No local video')),
                                  ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: isButton
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
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
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
                                        onTap: controller.inCall.value
                                            ? (){
                                              controller.endCall();
                                              Get.back();
                                            }
                                            : null,
                                        child: Container(
                                          height: 55,
                                          width: 55,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: Center(
                                            child: Icon(Icons.call_end,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        width: Get.width * 0.75,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isSpeaker = !isSpeaker;
                                                    });
                                                    callController.toggleMic();
                                                  },
                                                  child: Image.asset(
                                                    "images/icons/Speaker.png",
                                                    color: isSpeaker
                                                        ? mainColor
                                                        : Colors.black,
                                                  )),
                                              InkWell(
                                                  onTap: () {
                                                    controller.toggleVideo();

                                                  },
                                                  child: Image.asset(
                                                      "images/icons/video.png")),
                                              InkWell(
                                                  onTap: () {
                                                    log("message");

                                                    setState(() {
                                                      isButton = !isButton;
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.more_vert,
                                                    size: 30,
                                                  )),
                                              InkWell(
                                                onTap: () {
                                                    controller.flipCamera();
                                                  
                                                },
                                                child: Image.asset(
                                                    "images/icons/cameraflip.png"),
                                              ),
                                              isAudio
                                                  ? InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          isAudio = !isAudio;
                                                        });
                                                        controller.toggleMic();
                                                      },
                                                      child: Icon(
                                                        Icons.mic_off,
                                                        size: 30,
                                                      ))
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          isAudio = !isAudio;
                                                        });
                                                        controller.toggleMic();

                                                      },
                                                      child: Icon(Icons.mic,
                                                          size: 30))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          )
                        ],
                      ),
                    ),

                 
                  ],
                )
              : Stack(
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: Image.network(
                        widget.currentProfilePic??"",
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Dark overlay for better visibility
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                      image: NetworkImage(widget.profilepic),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  widget.profileName!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  widget.uid!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Outgoing Video Call",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
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
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
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
                                    Container(
                                      height: 55,
                                      width: 55,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: Icon(Icons.call_end,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      width: Get.width * 0.75,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isSpeaker = !isSpeaker;
                                                  });
                                                },
                                                child: Image.asset(
                                                  "images/icons/Speaker.png",
                                                  color: isSpeaker
                                                      ? mainColor
                                                      : Colors.black,
                                                )),
                                            Image.asset(
                                                "images/icons/video.png"),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isButton = !isButton;
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.more_vert,
                                                  size: 30,
                                                )),
                                            Image.asset(
                                                "images/icons/cameraflip.png"),
                                            isAudio
                                                ? InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isAudio = !isAudio;
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.mic_off,
                                                      size: 30,
                                                    ))
                                                : InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isAudio = !isAudio;
                                                      });
                                                    },
                                                    child: Icon(Icons.mic,
                                                        size: 30))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

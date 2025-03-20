// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_vars.dart';
import '../../models/new_user_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/new_user_modal.dart';

class LiveVideoCall extends StatefulWidget {
 final String title;
 final String profilePic;

  const LiveVideoCall({
    Key? key, required this.title, required this.profilePic,
   
  }) : super(key: key);

  @override
  State<LiveVideoCall> createState() => _LiveVideoCallState();
}

class _LiveVideoCallState extends State<LiveVideoCall> {
   bool isAudio = false;
  bool isSpeaker = false;
  bool isButton = false;
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
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
             widget.profilePic,
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
                        height: Get.height*0.2,
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
                       "Free Risthey Wala",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.title,
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
                :     Column(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Center(
                        child: Icon(Icons.call_end, color: Colors.white),
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
                            Image.asset("images/icons/video.png"),
                            InkWell(
                               onTap: () {
                          setState(() {
                            isButton = !isButton;
                          });
                        },
                              child: Icon(Icons.more_vert,size: 30,)),
                            Image.asset("images/icons/cameraflip.png"),

                           isAudio?
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isAudio=!isAudio;
                                });
                              },
                              child: Icon(Icons.mic_off,size: 30,)):
                            InkWell(
                               onTap: () {
                                setState(() {
                                  isAudio=!isAudio;
                                });
                              },
                              child: Icon(Icons.mic,size: 30))
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
      ),
    );
  }
}

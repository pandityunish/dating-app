// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_vars.dart';
import '../../models/new_user_modal.dart';

class LiveAudioCall extends StatefulWidget {

  const LiveAudioCall({
    Key? key,
  
  }) : super(key: key);

  @override
  State<LiveAudioCall> createState() => _LiveAudioCallState();
}

class _LiveAudioCallState extends State<LiveAudioCall> {
    bool isAudio = false;
  bool isSpeaker = false;
  bool isButton = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF38B9F3),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
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
                                      image: AssetImage("images/newlogo.png"),fit: BoxFit.cover)),
                            ),
                            SizedBox(height: 10,),
                            Text("Free Rishtey Wala",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 19),),
                            SizedBox(height: 5,),
                
                                                 Text("live matchmaker",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 12),),
                            SizedBox(height: 20,),
                
                                                 Text("Outgoing Audio Call",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
              ],
            ),
          ),
          Column(
            children: [
Container(
  height: 55,
  width: 55,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.red
  ),
  child: Center(
    child: Icon(Icons.call_end,color: Colors.white,),
  ),
),
SizedBox(height: 5,),
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
                      Container(
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
                      )
                    ],
                  ),
            ],
          ),
          SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}

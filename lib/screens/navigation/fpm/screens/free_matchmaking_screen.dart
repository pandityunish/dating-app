import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ristey/chat/screens/free_chat_screen.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/navigation/fpm/components/matching_component.dart';
import 'package:ristey/screens/navigation/fpm/screens/live_astro_screen.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';

import '../../../notification/Widget_Notification/ads_bar.dart';

class FreeMatchmakingScreen extends StatefulWidget {
  const FreeMatchmakingScreen({super.key});

  @override
  State<FreeMatchmakingScreen> createState() => _FreeMatchmakingScreenState();
}

class _FreeMatchmakingScreenState extends State<FreeMatchmakingScreen> {
  List<AdsModel> matchads = [];
  List<AdsModel> astroads = [];
  void getads() async {
    matchads = await AdsService().getallusers(adsid: "36");
    astroads = await AdsService().getallusers(adsid: "39");
    setState(() {});
  }

  @override
  void initState() {
    getads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100), // Adjust AppBar height
              child: AppBar(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: mainColor,
                    size: 25,
                  ),
                ),
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(
                      top: 10), // Adjust padding for alignment
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      CircleAvatar(
            backgroundColor: mainColor,
            backgroundImage: const AssetImage(
              "images/newlogo.png",
            ),
            radius: 20,
          ),
                        const SizedBox(
                          height: 8,
                        ),
                        DefaultTextStyle(
                          style: TextStyle(
                            color: mainColor,
                            fontFamily: 'Sans-serif',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          child: Text("Free Personalised Matchmaking"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.to(FreeChatScreen(
                          id: "Live Matchmaker",
                        ));
                        if (matchads.isNotEmpty) {
                          showadsbar(context, matchads, () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: MatchingComponents(
                        title: "Live Matchmaker",
                      )),
                  GestureDetector(
                      onTap: () {
                        Get.to(LiveAstroScreen(
                          id: "Live Astrologer",
                        ));
                        if (astroads.isNotEmpty) {
                          showadsbar(context, astroads, () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: MatchingComponents(
                        title: "Live Astrologer",
                      )),
                ],
              ),
            ),
          )),
    );
  }
}

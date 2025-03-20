import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';
import 'package:ristey/assets/send_message.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/admin_modal.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/navigation/service/notification_local_function.dart';
import 'package:ristey/screens/notification.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Congo extends StatefulWidget {
  const Congo({super.key});
  @override
  State<Congo> createState() => _ReligionState();
}

class _ReligionState extends State<Congo> {
  HomeService homeservice = Get.put(HomeService());
  SendMessage sendMessage = SendMessage();


  void sendmessages() async {
    // scheduleNotification();
    NotificationServiceLocal().showNotification(
        body: "", id: 1, payLoad: "", title: "WELCOME TO FREE RISHTEY WALA");
    NotificationService().addtonotification(
        email: userSave.email!, title: "WELCOME TO FREE RISHTEY WALA");
    Timer(const Duration(minutes: 1), () {
      NotificationServiceLocal().showNotification(
          body: "",
          id: 4,
          payLoad: "",
          title: "CONGRATULATIONS PROFILE CREATED SUCCESSFULLY");
      NotificationService().addtonotification(
          email: userSave.email!,
          title: "CONGRATULATIONS PROFILE CREATED SUCCESSFULLY");
    });
    Timer(const Duration(minutes: 2), () {
      NotificationServiceLocal().showNotification(
          body: "", id: 7, payLoad: "4", title: "KNOW HOW TO USE APP");
      NotificationService().addtonotification(
          email: userSave.email!,
          title: "HAVE A GREAT JOURNEY TO FIND YOUR SOULMATE");
    });
    Timer(const Duration(minutes: 4), () {
      // NotificationServiceLocal().showNotification(
      //     body: "",
      //     id: 3,
      //     payLoad: "",
      //     title: "HAVE A GREAT JOURNEY TO FIND YOUR SOULMATE");
      NotificationService().addtonotification(
          email: userSave.email!, title: "KNOW HOW TO USE APP");
    });

    
    //  NotificationService().addtoadminnotification(
    //         userid: userSave.uid!,
    //         subtitle: "Profile Create",
    //         useremail: userSave.email!,
    //         userimage: userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
    //         title:
    //             "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} CREATED PROFILE SUCCESSFULLY ");
    homeservice.getuserdata().whenComplete(() {
      HomeService().createeditprofile(
          userid: userSave.email!,
          isBlur: false,
          editname: "Created by ${userSave.name!}",
          aboutme: userSave.About_Me!,
          mypreference: userSave.Partner_Prefs!,
          imageurls: userSave.imageUrls!);
    });
    List<AdminModel> alladmins = await HomeService().getalladmins();
    for (var i = 0; i < alladmins.length; i++) {
      sendMessage.sendPushMessage(
          "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} CREATED PROFILE SUCCESSFULLY ",
          "Free Rishtey Wala",
          userSave.uid!,
          "Free Rishtey Wala",
          alladmins[i].token);
    }
  }

  List<AdsModel> allads = [];
  List<AdsModel> userallads = [];
  showinfo() {
    showadsbar(context, allads, () {
      Navigator.pop(context);
    });
  }

  showinfo2() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.only(top: 0, right: 10, left: 10, bottom: 20),
          insetPadding: EdgeInsets.only(
              top: 0,
              right: 30,
              left: 30,
              bottom: MediaQuery.of(context).size.height * 0.005),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: ImageIcon(
                    const AssetImage(
                      'images/icons/Close_icon.png',
                    ),
                    // fontWeight:FontWeight.w700,
                    color: mainColor,
                  ),
                ),
              )
            ],
          ),
          content: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/icons/free_ristawala.png'),
                  const SizedBox(
                    height: 10,
                  ),
                  userallads.isNotEmpty
                      ? Center(
                          child: Image.network(userallads[0].image),
                        )
                      : const Column(
                          children: [
                            Text(
                              "जरूरी सूचना ",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "हम आपके महत्वपूर्ण समय और प्रयासों का सम्मान करते हैं। हम बिल्कुल मुफ्त सेवाएं दे रहे हैं और यह पूरी तरह से प्रयास के लायक है।\nनकली से सावधान!",
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Important Information",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "We regard your important time and endeavors. We are offering absolutely free services and it's totally worth the effort.\nBeware with fakes!",
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("By \nSourabh Mehndiratta\n The MatchMaker",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.w500))
                          ],
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void getallads() async {
    userallads = adsuser.where((element) => element.adsid == "7").toList();
    allads = await AdsService().getallusers(adsid: "7");
    setState(() {});
    if (allads.isNotEmpty) {
      Timer.run(() {
        showinfo();
      });
    } else if (userallads.isNotEmpty) {
      Timer.run(() {
        showinfo2();
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getallads();
    homeservice.getuserdata().whenComplete(() {
      NotificationService().addtoadminnotification(
          userid: userSave.uid ?? "93874109283749081",
          useremail: userSave.email!,
          userimage: userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
          title:
              " ${userService.userdata["name"].substring(0, 1)} ${userService.userdata["surname"].toUpperCase()} ${userService.userdata["puid"]} COMPLETE SIGN UP ",
          subtitle: "Complete signup");
    });

    //     .whenComplete(() {})
    //     .whenComplete(() {

    // }).whenComplete(() {

    sendmessages();
    // });
  }

  UserService userService = Get.put(UserService());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(
        const Duration(seconds: 7),
        () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MainAppContainer(
                  notiPage: false,
                );
              },
            ),
            (route) => false,
          );
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1.0)),
            child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Congratulations! ",
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Sans-serif'),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // margin: EdgeInsets.only(left: 50),
                            child: const Text(
                              "Welcome to ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Sans-serif'),
                            ),
                          ),
                          const Text(
                            "Free",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            "RishteyWala",
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                               ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "You have successfully registered",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Sans-serif'),
                          ),
                          Container(
                            // margin: EdgeInsets.only(left: 120),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              textBaseline: TextBaseline.ideographic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                const Text(
                                  "with",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Sans-serif'),
                                ),
                                const Text(
                                  " Free",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "RishteyWala",
                                  style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                     ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                        child: Icon(
                          Icons.check_circle,
                          color: mainColor,
                        ),
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        textBaseline: TextBaseline.ideographic,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          const Text(
                            "Your",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Sans-serif'),
                          ),
                          const Text(
                            " Free",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                          ),
                          Text(
                            "RishteyWala",
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 16,
                                ),
                          ),
                          Text(
                            " ID is ${userService.userdata["puid"] ?? ""}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Sans-serif'),
                          ),
                        ],
                      ),
                      Text(
                        "${userSave.email}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Sans-serif'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

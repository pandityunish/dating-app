import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/assets/g_sign.dart';
import 'package:ristey/assets/notification_pop_up.dart';
import 'package:ristey/assets/tcp_popup.dart';
import 'package:ristey/common/widgets/custom_button.dart';
import 'package:ristey/common/widgets/social_button.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/shared_pref.dart';
// Import removed as it was self-referential
import 'package:ristey/screens/moving_bubbles.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';

String? role;
String? location;
String? pPref;
// ignore: non_constant_identifier_names
String? uid_value;

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<ConnectivityResult> _connectionStatus = [];
  SharedPref sharedPref = SharedPref();
  Future<void> checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _connectionStatus = result;
    });

    if (_connectionStatus == ConnectivityResult.none) {
      showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Icon(
            Icons.error,
            color: mainColor,
          ),
          content: const Text('No Internet Connection'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                if (!mounted) return;
              },
              child: Text(
                'OK',
                style: TextStyle(color: mainColor),
              ),
            )
          ],
        ),
      );
    }
  }

  showsigindialog() {
    Get.dialog(Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: () {
                  signup(context);
                },
                child: const SocialButton(
                    image: "images/google.png", name: "Continue With Google")),
            InkWell(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: SnackBarContent(
                          error_text: "Please Continue With Google",
                          appreciation: "",
                          icon: Icons.error,
                          sec: 2,
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      );
                    });
              },
              child: const SocialButton(
                  image: "images/facebook.png", name: "Continue With Facebook"),
            ),
            InkWell(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: SnackBarContent(
                          error_text: "Please Continue With Google",
                          appreciation: "",
                          icon: Icons.error,
                          sec: 2,
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      );
                    });
              },
              child: const SocialButton(
                  image: "images/instagram.png",
                  name: "Continue With Instagram"),
            ),
            InkWell(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: SnackBarContent(
                          error_text: "Please Continue With Google",
                          appreciation: "",
                          icon: Icons.error,
                          sec: 2,
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      );
                    });
              },
              child: const SocialButton(
                  image: "images/twitter.png", name: "Continue With Twitter"),
            ),
            InkWell(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: SnackBarContent(
                          error_text: "Please Continue With Google",
                          appreciation: "",
                          icon: Icons.error,
                          sec: 2,
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      );
                    });
              },
              child: const SocialButton(
                  image: "images/linkedin.png", name: "Continue With Linkedin"),
            ),
          ],
        ),
      ),
    ));
  }
  showLocationAndNotification() {
    bool showNotificationSection = false;
    
    Get.dialog(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!showNotificationSection) ...[  
                    // Location section
                    Icon(Icons.location_on_outlined, size: 35, color: mainColor),
                    SizedBox(height: 5),
                    Text("Allow Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(height: 15),
                    Text("GPS is Used To Locate \n  You in Relationship To The Parking Spots", 
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                    SizedBox(height: 28),
                    
                    InkWell(
                      onTap: () {
                        // Update the local dialog state to show notification section
                        setDialogState(() {
                          showNotificationSection = true;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: Get.width*0.57,
                        color: mainColor,
                        child: Center(
                          child: Text("Allow Location Service", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ] else ...[  
                    // Notification section
                    Icon(Icons.notifications_none_sharp, size: 35, color: mainColor),
                    SizedBox(height: 5),
                    Text("Allow Notifications", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(height: 15),
                    Text("Would You Like To \n Receive Notifications",textAlign: TextAlign.center, style: TextStyle(fontSize: 12,)),
                    SizedBox(height: 28),
                    
                    InkWell(
                      onTap: () {
                        Get.back();
                        // Add any additional actions after both permissions are granted
                      },
                      child: Container(
                        height: 40,
                        width: Get.width*0.57,
                        color: mainColor,
                        child: Center(
                          child: Text("Allow Notification Service", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      barrierDismissible: false,
    );
  }
  
  // Legacy methods kept for reference
  showNotification() {
    // Now calls the combined method
    showLocationAndNotification();
  }
  
  showLocation() {
    // Now calls the combined method
    showLocationAndNotification();
  }
  List<AdsModel> allads = [];
  List<AdsModel> allads2 = [];

  showinfo() {
    if (allads.isNotEmpty) {
      showadsbar(context, allads, () {
        Navigator.pop(context);
      });
    }
  }

  void getallads() async {
    allads = await AdsService().getallusers(adsid: "1");
    setState(() {});
    Timer.run(() {
      showinfo();
    });
  }

  @override
  void initState() {
    NotificationData().requestNotificationPermission();

    getallads();
    Timer.run(() {
      showLocation();
      checkConnectivity();
    });

    super.initState();
  }

  // ignore: non_constant_identifier_names
  bool color_done = false;

  var error;

  bool term = false;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        body: Stack(
          children: [
            BubbleImage(height: MediaQuery.of(context).size.height * 0.7 / 8),
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Image.asset(
                  'images/icons/free_ristawala1.png',
                  width: MediaQuery.of(context).size.width * 0.95,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        activeColor: mainColor,
                        value: term,
                        onChanged: (term) {
                          setState(() {
                            this.term = term!;
                          });
                        }),
                    const Text(
                      "I agree with Free Rishtey Wala ",
                      style: TextStyle(fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) =>  TCPopup(onClick: (){
                             setState(() {
                         term = !term;
                          });
                            Get.back();
                            
                          },),
                        );
                        FirebaseFirestore.instance
                            .collection('data')
                            .add({'text': 'data added through app'});
                      },
                      child: Text(
                        "Terms & Conditions",
                        style: TextStyle(color: mainColor, fontSize: 12),
                      ),
                    ),
                  ],
                ),
               
                CustomButton(
                  text: "Continue",
                  onPressed: () {
                      setState(() {
                          color_done = true;
                        });

                        // Reset the border color after 2 seconds
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() {
                              color_done = false;
                            });
                          }
                        });
                        
                        if (term == false) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: SnackBarContent(
                                    error_text:
                                        "Please Accept \n Terms & Conditions",
                                    appreciation: "",
                                    icon: Icons.error,
                                    sec: 2,
                                  ),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                );
                              });
                        } else {
                          showsigindialog();
                          setState(() {
                            color_done = false;
                          });
                        }
                  },
                  mainColor: mainColor,
                  colorDone: color_done,
                  width: MediaQuery.of(context).size.width * 0.95,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

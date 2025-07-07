import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ristey/assets/notification_pop_up.dart';
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/screens/audio_clip/audio_clip_accept.dart';
import 'package:ristey/screens/data_collection/mannual_education_udpate.dart';
import 'package:ristey/screens/data_collection/mannual_profession_udpate.dart';
import 'package:ristey/screens/main_screen.dart';
import 'package:ristey/screens/navigation/biodata.dart';
import 'package:ristey/screens/navigation/help_support.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:ristey/screens/navigation/use.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/edit_profile.dart';
import 'package:ristey/screens/profile/maintainence_screen.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/screens/profile/profile_verify.dart';
import 'package:ristey/screens/profile/review_screen.dart';
import 'package:ristey/screens/profile/service/notification_controller.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/screens/profile/verification/contact_verify.dart';
import 'package:ristey/screens/search_pref/saved_pref.dart';
import 'package:ristey/services/add_to_profile_service.dart';
import 'package:ristey/services/socket_service.dart';
import 'package:ristey/small_functions/profile_completion.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../network_connectivity.dart';
import '../../services/ads_services.dart';

class SplashVideo extends StatefulWidget {
  const SplashVideo({super.key});

  @override
  State<SplashVideo> createState() => _SplashVideoState();
}

class _SplashVideoState extends State<SplashVideo> {
  late VideoPlayerController _videoPlayerController;
  late StreamSubscription subscription;

  bool isDeviceConnected = false;
  bool isAlertSet = false;
  List<ConnectivityResult> _connectionStatus = [];
  Future<void> checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _connectionStatus = result;
    });

    // Show alert dialog if there is no internet connection
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
                // setState(() => isAlertSet = false);
                // isDeviceConnected =
                //     await InternetConnectionChecker().hasConnection;
                // if (!isDeviceConnected && isAlertSet == false) {
                //   showDialogBox();
                //   if (!mounted) return;
                //   setState(() => isAlertSet = true);
                // }
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

  var data;
  void getallmaintenance() async {
    data = await NotificationService().getmaintenance();
    setState(() {});
  }

  List<AdsModel> aboutmeads = [];
  List<AdsModel> prefads = [];
  List<AdsModel> saveprefads = [];
  List<AdsModel> videoads = [];
  List<AdsModel> educationads = [];
  List<AdsModel> professionads = [];
  List<AdsModel> ratingads = [];
  List<AdsModel> photoads = [];
  List<AdsModel> bioads = [];
  List<AdsModel> shareads = [];
  List<AdsModel> supportads = [];
  List<AdsModel> useraboutmeads = [];
  List<AdsModel> userprefads = [];
  List<AdsModel> usersaveprefads = [];
  List<AdsModel> uservideoads = [];
  List<AdsModel> usereducationads = [];
  List<AdsModel> userprofessionads = [];
  List<AdsModel> userratingads = [];
  List<AdsModel> userphotoads = [];
  List<AdsModel> userbioads = [];
  List<AdsModel> usershareads = [];
  List<AdsModel> usersupportads = [];
  void getads() async {
    aboutmeads = await AdsService().getallusers(adsid: "72");
    prefads = await AdsService().getallusers(adsid: "73");
    saveprefads = await AdsService().getallusers(adsid: "74");
    videoads = await AdsService().getallusers(adsid: "75");
    educationads = await AdsService().getallusers(adsid: "76");
    professionads = await AdsService().getallusers(adsid: "77");
    ratingads = await AdsService().getallusers(adsid: "78");
    photoads = await AdsService().getallusers(adsid: "79");
    bioads = await AdsService().getallusers(adsid: "80");
    photoads = await AdsService().getallusers(adsid: "81");
    supportads = await AdsService().getallusers(adsid: "82");
    setState(() {});
  }

  void getuseradsdata() {
    useraboutmeads = adsuser.where((element) => element.adsid == "72").toList();
    userprefads = adsuser.where((element) => element.adsid == "73").toList();
    usersaveprefads =
        adsuser.where((element) => element.adsid == "74").toList();
    uservideoads = adsuser.where((element) => element.adsid == "75").toList();
    usereducationads =
        adsuser.where((element) => element.adsid == "76").toList();
    userprofessionads =
        adsuser.where((element) => element.adsid == "77").toList();
    userratingads = adsuser.where((element) => element.adsid == "78").toList();
    userphotoads = adsuser.where((element) => element.adsid == "79").toList();
    userbioads = adsuser.where((element) => element.adsid == "80").toList();
    userphotoads = adsuser.where((element) => element.adsid == "81").toList();
    usersupportads = adsuser.where((element) => element.adsid == "82").toList();
    setState(() {});
  }

  void getpermission() async {
    NotificationData().requestNotificationPermission();
    // var status = Permission.notification.status;
    // print(await status.isPermanentlyDenied);
    // print("Hello12");
    // if (await status.isPermanentlyDenied == true) {
    //   print(await status.isDenied);
    //   print("Hello");
    //   PermissionStatus? statusNotification =
    //       await Permission.notification.request();
    //   print(statusNotification.isDenied);
    //   if (statusNotification.isDenied ||
    //       statusNotification.isPermanentlyDenied) {
    //     SystemNavigator.pop();
    //   } else {}
    // }
  }

  @override
  void initState() {
    super.initState();

    getads();
    final AdsServices myController = Get.put(AdsServices());

    getallmaintenance();
    getpermission();
    Timer.run(() {
      checkConnectivity();
    });
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        "https://res.cloudinary.com/dsqtxanz6/video/upload/v1699771482/rjlkygdfyrxs1shr6eew.mp4"))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _videoPlayerController.play();

    Timer(const Duration(seconds: 6), () async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? useremail = sharedPreferences.getString("email");
      String? userlocation = sharedPreferences.getString("location");
      DateTime date = DateTime.fromMillisecondsSinceEpoch(userSave.dob!);
      DateTime today = DateTime.now();
      bool isBirthday = (date.day == today.day && date.month == today.month);
      if (isBirthday == false) {
        sharedPreferences.setBool("isBirthday", false);
      }
      ProfileCompletion profile = ProfileCompletion();

      int profilepercentage = await profile.profileComplete();
      userProfilePercentage = profilepercentage;
      if (data != null &&
          data.isNotEmpty &&
          data[0] != null &&
          data[0].containsKey("isUnder") &&
          data[0]["isUnder"] == true) {
        Get.offAll(const MeintenanceScreen());
      } else {
        if ((useremail == null && userlocation == null) ||
            (useremail == "" && userlocation == "")) {
          await FirebaseAuth.instance.signOut();
          final GoogleSignIn googleSignIn = GoogleSignIn();
          googleSignIn.signOut();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const FirstScreen(),
              ),
              (route) => false);
        } else {
          HomeService().getuserdata().whenComplete(() {
            getuseradsdata();
            SignallingService.instance.init(
              websocketUrl: "$baseurl/videocall",
              selfCallerID: userSave.uid!,
            );
    Get.put(NotificationController());

            if (userSave.isLogOut == "false") {
              FirebaseAuth.instance.signOut();
              final GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FirstScreen(),
                  ),
                  (route) => false);
            } else {
              HomeService().updatesendlink();
              Get.put<CallController>(CallController(), permanent: true);
              if (sendlinks.isNotEmpty) {
                if (sendlinks.contains("To Improve About Partner Preference")) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()),
                    (route) => false,
                  );
                  if (userprefads.isNotEmpty) {
                    showadsbar(context, userprefads, () {
                      Get.back();
                    });
                  } else {
                    if (prefads.isNotEmpty) {
                      showadsbar(context, prefads, () {
                        Get.back();
                      });
                    }
                  }
                }
                if (sendlinks.contains("To Upload Photo")) {
                  print("hello");
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()),
                    (route) => false,
                  );

                  if (userphotoads.isNotEmpty) {
                    showadsbar(context, userphotoads, () {
                      Get.back();
                    });
                  } else {
                    if (photoads.isNotEmpty) {
                      showadsbar(context, photoads, () {
                        Get.back();
                      });
                    }
                  }
                } else if (sendlinks.contains("To Upload Video")) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Verify()),
                    (route) => false,
                  );
                  if (uservideoads.isNotEmpty) {
                    showadsbar(context, uservideoads, () {
                      Get.back();
                    });
                  } else {
                    if (videoads.isNotEmpty) {
                      showadsbar(context, videoads, () {
                        Get.back();
                      });
                    }
                  }
                } else if (sendlinks.contains("To Improve About Me")) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()),
                    (route) => false,
                  );
                  if (useraboutmeads.isNotEmpty) {
                    showadsbar(context, aboutmeads, () {
                      Get.back();
                    });
                  } else {
                    if (aboutmeads.isNotEmpty) {
                      showadsbar(context, aboutmeads, () {
                        Get.back();
                      });
                    }
                  }
                } else if (sendlinks.contains("To Learn How To Use App")) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Use()),
                    (route) => false,
                  );
                } else if (sendlinks.contains("OTP Verify")) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactVerify()),
                    (route) => false,
                  );
                } else if (sendlinks.contains("To Save Preference")) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchPreferences()),
                    (route) => false,
                  );
                  if (usersaveprefads.isNotEmpty) {
                    showadsbar(context, usersaveprefads, () {
                      Get.back();
                    });
                  } else {
                    if (saveprefads.isNotEmpty) {
                      showadsbar(context, saveprefads, () {
                        Get.back();
                      });
                    }
                  }
                } else if (sendlinks.contains("To Share App")) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyProfile(
                              profilepercentage: profilepercentage,
                            )),
                    (route) => false,
                  );
                  AddToProfileService().updateshare();
                  SupprotService().deletesendlink(
                      email: userSave.email!, value: "To Share App");

                  Share.share(
                      'https://play.google.com/store/apps/details?id=com.freerishtey.android');
                  if (usershareads.isNotEmpty) {
                    showadsbar(context, usershareads, () {
                      Get.back();
                    });
                  } else {
                    if (shareads.isNotEmpty) {
                      showadsbar(context, shareads, () {
                        Get.back();
                      });
                    }
                  }
                } else if (sendlinks.contains("To Download Biodata")) {
                  if (userSave.status == "approved") {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const BioData()),
                      (route) => false,
                    );
                    if (userbioads.isNotEmpty) {
                      showadsbar(context, userbioads, () {
                        Get.back();
                      });
                    } else {
                      if (bioads.isNotEmpty) {
                        showadsbar(context, bioads, () {
                          Get.back();
                        });
                      }
                    }
                  } else {
                    is9Ads = true;

                    userSave.email = useremail;
                    HomeService().getuserdata();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MainAppContainer(notiPage: false),
                        ),
                        (route) => false);
                  }
                } else if (sendlinks.contains("To Show Support Reply")) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpSupport()),
                    (route) => false,
                  );
                  if (usersupportads.isNotEmpty) {
                    showadsbar(context, usersupportads, () {
                      Get.back();
                    });
                  } else {
                    if (supportads.isNotEmpty) {
                      showadsbar(context, supportads, () {
                        Get.back();
                      });
                    }
                  }
                } 
                // else if (sendlinks.contains("To Ask Rating")) {
                //   Get.offAll(const ReviewScreen());
                //   if (userratingads.isNotEmpty) {
                //     showadsbar(context, userratingads, () {
                //       Get.back();
                //     });
                //   } else {
                //     if (ratingads.isNotEmpty) {
                //       showadsbar(context, ratingads, () {
                //         Get.back();
                //       });
                //     }
                //   }
                // }
                else if (sendlinks.contains("To Save Profession Manually")) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MannulProfessionUpdate()),
                    (route) => false,
                  );
                  if (userprofessionads.isNotEmpty) {
                    showadsbar(context, userprofessionads, () {
                      Get.back();
                    });
                  } else {
                    if (professionads.isNotEmpty) {
                      showadsbar(context, professionads, () {
                        Get.back();
                      });
                    }
                  }
                } else if (sendlinks.contains("To Save Education Manually")) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MannualEducationUpdate()),
                    (route) => false,
                  );
                  if (usereducationads.isNotEmpty) {
                    showadsbar(context, usereducationads, () {
                      Get.back();
                    });
                  } else {
                    if (educationads.isNotEmpty) {
                      showadsbar(context, educationads, () {
                        Get.back();
                      });
                    }
                  }
                } else if (sendlinks.contains("Audio Clip")) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IncomingAudioClipScreen()),
                    (route) => false,
                  );
                } else {
                  is9Ads = true;

                  HomeService()
                      .updatelogin(email: userSave.email!, mes: "true");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainAppContainer(notiPage: false),
                      ),
                      (route) => false);
                }
              } else {
                is9Ads = true;
                userSave.email = useremail;
                HomeService().getuserdata();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainAppContainer(notiPage: false),
                    ),
                    (route) => false);
              }
            }
          }).catchError((error, stackTrace) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const FirstScreen(),
                ),
                (route) => false);
            print("outer: $error");
          });
        }
      }

      _videoPlayerController.pause();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _videoPlayerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              )
            : Container(),
      ),
    );
  }
}

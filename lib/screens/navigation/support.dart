import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ristey/common/widgets/circular_bubbles.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/screens/navigation/help_support.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/navigation/use.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';

import '../data_collection/custom_appbar.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _ReligionState();
}

class _ReligionState extends State<Support> {
  int value = 0;
  late PageController _myPage;
  var selectedPage;

  @override
  void initState() {
    super.initState();
    _myPage = PageController(initialPage: 1);
    selectedPage = 1;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
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
            middle:
                Text.rich(TextSpan(style: TextStyle(fontSize: 20), children: [
              TextSpan(
                  text: "Free",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: "Showg")),
              TextSpan(
                  text: "rishteywala",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                      fontFamily: "Showg")),
              // TextSpan(
              //     text: ".in", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Showg")),
            ])),
            previousPageTitle: "",
          ),
          child: PageView(controller: _myPage, children: [
            SupportScreen(),
          ])),
    );
  }
}

class SupportScreen extends StatefulWidget {
  const SupportScreen({
    super.key,
  });
  //  PageController mypage ;

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  var data;
  void getallbubbles() async {
    data = await UserService().getbubbles();
    setState(() {});
  }

  List<AdsModel> helpandsupprotads = [];
  List<AdsModel> userhelpandsupprotads = [];

  void getads() async {
    userhelpandsupprotads =
        adsuser.where((element) => element.adsid == "68").toList();

    helpandsupprotads = await AdsService().getallusers(adsid: "68");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getads();
    getallbubbles();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar:CustomAppBar(
        
          title: "Support", iconImage: 'images/icons/community.png') ,
        //  CupertinoNavigationBar(
        //   leading: GestureDetector(
        //     onTap: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => MyProfile(profilepercentage: 50),
        //           ));
        //     },
        //     child: Icon(
        //       Icons.arrow_back_ios_new,
        //       color: mainColor,
        //       size: 25,
        //     ),
        //   ),
        //   middle: Text.rich(TextSpan(style: TextStyle(fontSize: 20), children: [
        //     TextSpan(
        //         text: "Free",
        //         style: TextStyle(
        //             fontWeight: FontWeight.bold, fontFamily: "Showg")),
        //     TextSpan(
        //         text: "rishteywala",
        //         style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //             color: mainColor,
        //             fontFamily: "Showg")),
        //     // TextSpan(
        //     //     text: ".in", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Showg")),
        //   ])),
        //   previousPageTitle: "",
        // ),
        body: data == null
            ? Center(
                child: CircularProgressIndicator(
                  color: mainColor,
                ),
              )
            : Stack(
                children: [
                  Container(
                  
                    child: SingleChildScrollView(
                        child: Column(children: [
                     
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircularBubles(url: data[0]["image2"])
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: false),
                                    autoPlay: true)
                                // .then()
                                .slideX(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideX(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1500.ms)
                                .then(),
                            CircularBubles(url: data[0]["image3"])
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .slideX(end: 0.1, duration: 1000.ms)
                                .then()
                                .slideY(end: 0.1, duration: 1000.ms)
                                .then()
                                .slideX(end: -0.1, duration: 1000.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1000.ms)
                                .then(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularBubles(url: data[0]["image1"])
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                    autoPlay: true)
                                .slideX(end: -0.1, duration: 1000.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1000.ms)
                                .then()
                                .slideX(end: 0.1, duration: 1000.ms)
                                .then()
                                .slideY(end: 0.1, duration: 1000.ms)
                                .then(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularBubles(url: data[0]["image4"])
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                    autoPlay: true)
                                .slideX(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1000.ms)
                                .then()
                                .slideX(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: 0.1, duration: 1500.ms)
                                .then(),
                            CircularBubles(url: data[0]["image5"])
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                    autoPlay: true)
                                .slideX(end: 0.2, duration: 1500.ms)
                                .then()
                                .slideY(end: 0.2, duration: 1500.ms)
                                .then()
                                .slideX(end: -0.2, duration: 1500.ms)
                                .then()
                                .slideY(end: -0.2, duration: 1500.ms)
                                .then(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularBubles(url: data[0]["image6"])
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                    autoPlay: true)
                                .slideX(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideX(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1500.ms)
                                .then(),
                            CircularBubles(url: data[0]["image7"])
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .slideX(end: 0.3, duration: 3000.ms)
                                .then()
                                .slideY(end: 0.3, duration: 3000.ms)
                                .then()
                                .slideX(end: -0.3, duration: 3000.ms)
                                .then()
                                .slideY(end: -0.3, duration: 3000.ms)
                                .then(),
                            CircularBubles(url: data[0]["image8"])
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .slideX(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideX(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: 0.1, duration: 1500.ms)
                                .then(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularBubles(url: data[0]["image9"])
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .slideX(end: 0.4, duration: 1500.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideX(end: 0.4, duration: 3000.ms)
                                .then()
                                .slideY(end: 0.05, duration: 1500.ms)
                                .then(),
                            CircularBubles(url: data[0]["image10"])
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .slideX(end: 0.1, duration: 1000.ms)
                                .then()
                                // .slideY(end: 0.4, duration: 400.ms)
                                // .then()
                                .slideX(end: -0.1, duration: 1000.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1000.ms)
                                .then(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircularBubles(url: data[0]["image11"])
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: false),
                                    autoPlay: true)
                                // .then()
                                .slideX(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideX(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1500.ms)
                                .then(),
                            const SizedBox(
                              width: 50,
                            ),
                            CircularBubles(url: data[0]["image12"])
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .slideX(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideX(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1500.ms)
                                .then(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularBubles(url: data[0]["image13"])
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                    autoPlay: true)
                                .slideX(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideX(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: 0.1, duration: 1500.ms)
                                .then(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircularBubles(url: data[0]["image14"])
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                    autoPlay: true)
                                .slideX(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideX(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: 0.1, duration: 1500.ms)
                                .then(),
                            CircularBubles(url: data[0]["image15"])
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                    autoPlay: true)
                                .slideX(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: -0.1, duration: 1500.ms)
                                .then()
                                .slideX(end: 0.1, duration: 1500.ms)
                                .then()
                                .slideY(end: 0.1, duration: 1500.ms)
                                .then(),
                            CircularBubles(url: data[0]["image16"])
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                    autoPlay: true)
                                .slideX(end: 0.2, duration: 1500.ms)
                                .then()
                                .slideY(end: 0.2, duration: 1500.ms)
                                .then()
                                .slideX(end: -0.2, duration: 1500.ms)
                                .then()
                                .slideY(end: -0.2, duration: 1500.ms)
                                .then(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ])),
                  ),
                  // RiveAnimation.asset(
                  //   "RiveAssets/onboard_animation.riv",
                  // ),
                  Center(
                    child: SizedBox(
                      height: 250,
                      child: Material(
                        color: Colors.white,
                          elevation: 10,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigator.push(context, route);

                                    // Navigator.of(context).push(CupertinoPageRoute(
                                    //     builder: (builder) => HelpSupport()));
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 0),
                                            reverseTransitionDuration:
                                                Duration(milliseconds: 0),
                                            pageBuilder: (_, __, ___) =>
                                                HelpSupport()));
                                    if (userhelpandsupprotads.isNotEmpty) {
                                      showadsbar(context, userhelpandsupprotads,
                                          () {
                                        Navigator.pop(context);
                                      });
                                    } else {
                                      if (helpandsupprotads.isNotEmpty) {
                                        showadsbar(context, helpandsupprotads,
                                            () {
                                          Navigator.pop(context);
                                        });
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Help & Support',
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                  ),
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                          EdgeInsets.symmetric(
                                              horizontal: 70, vertical: 12)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60.0),
                                              side: BorderSide(
                                                  color: Colors.white))),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white)),
                                ),
                                SizedBox(height: 15),
                                ElevatedButton(
                                  onPressed: () {
                                    NotificationService().addtoadminnotification(
                                        userid: userSave.uid!,
                                        subtitle: "Profile Create",
                                        useremail: userSave.email!,
                                        userimage: userSave.imageUrls!.isEmpty
                                            ? ""
                                            : userSave.imageUrls![0],
                                        title:
                                            "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEEN HOW TO USE APP ");
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 0),
                                            reverseTransitionDuration:
                                                Duration(milliseconds: 0),
                                            pageBuilder: (_, __, ___) =>
                                                Use()));
                                  },
                                  child: Text(
                                    'How To Use App',
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                  ),
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                          EdgeInsets.symmetric(
                                              horizontal: 65, vertical: 12)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60.0),
                                              side: BorderSide(
                                                  color: Colors.white))),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white)),
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

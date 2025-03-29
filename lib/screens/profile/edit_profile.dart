import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/assets/image.dart';
import 'package:ristey/assets/send_message.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/screens/data_collection/custom_img.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/send_utils/noti_function.dart';
import 'package:ristey/services/search_service.dart';
import 'package:ristey/small_functions/profile_completion.dart';
import 'package:ticker_text/ticker_text.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool savedata = false;
  bool aboutUpdateText = false;
  bool partnerUpdateText = false;
  // User userSave = User();
  TextEditingController aboutmeController = TextEditingController();
  TextEditingController partnerPrefController = TextEditingController();
  String dob = "";
  int profilepercentage = 0;
  ProfileCompletion profile = ProfileCompletion();
  void getprecentage() async {
    profilepercentage = profile.profileComplete();
    userProfilePercentage = profilepercentage;
    setState(() {});
  }

  bool isaboutautofocus = false;
  bool ispatnerprefautofocus = false;
  List<AdsModel> picblockads = [];
  List<AdsModel> picunblockads = [];
  List<AdsModel> saveads = [];
  List<AdsModel> aboutmeads = [];
  List<AdsModel> prefads = [];
  void getads() async {
    aboutmeads = await AdsService().getallusers(adsid: "72");
    prefads = await AdsService().getallusers(adsid: "73");
    picblockads = await AdsService().getallusers(adsid: "87");
    picunblockads = await AdsService().getallusers(adsid: "88");
    saveads = await AdsService().getallusers(adsid: "89");

    setState(() {});
  }

  void showinfoaboutme() {
    if (aboutmeads.isNotEmpty) {
      showadsbar(context, aboutmeads, () {
        Navigator.pop(context);
      });
    }
  }

  void showinfopref() {
    if (prefads.isNotEmpty) {
      showadsbar(context, prefads, () {
        Navigator.pop(context);
      });
    }
  }

  initState() {
    super.initState();
    getads();
    forIos = userSave.isBlur!;
    getprecentage();
    HomeService().getuserdata();
    setData();
    if (sendlinks.contains("To Improve About Me")) {
      isaboutautofocus = true;
      aboutUpdateText = true;
      Timer.run(() {
        showinfoaboutme();
      });
      setState(() {});
    }
    if (sendlinks.contains("To Improve About Partner Preference")) {
      ispatnerprefautofocus = true;
      partnerUpdateText = true;
      Timer.run(() {
        showinfopref();
      });
      setState(() {});
    }
    if (!mounted) return;
    setState(() {
      print(userSave.About_Me);
      aboutmeController.text = userSave.About_Me == null
          ? "Welcome to my profile. I'm here to find someone who appreciates authenticity and kindness. Hope you find what you're looking for."
          : userSave.About_Me!;
      partnerPrefController.text = userSave.Partner_Prefs == null
          ? "I am looking for a meaningful connection based on mutual respect, trust and shared values. Someone who is ready to grow and learn with me on this journey I would like to Connect"
          : userSave.Partner_Prefs!;
    });
  }

  bool borderColor = false;
  setData() async {
    print(userSave.dob);
    DateTime dateofbirth = DateTime.fromMillisecondsSinceEpoch(userSave.dob!);

    dob = DateFormat('d-MMM-yyyy').format(dateofbirth);

    setState(() {});
    ImageUrls imageUrls = ImageUrls();

    imageUrls.clear();
    print(userSave.imageUrls);
    if (userSave.imageUrls == null) {
    } else {
      for (var i = 0; i < userSave.imageUrls!.length; i++) {
        if (!mounted) return;
        setState(() {
          imageUrls.add(
            imageurl: userSave.imageUrls![i],
          );
        });
      }
    }
  }

  nameContainer(icon, String head, String body) {
    return Container(
      padding: EdgeInsets.only(left: 25, right: 25),
      margin: EdgeInsets.only(bottom: 5),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage(icon),
                  size: 18,
                  color: mainColor,
                ),
                Container(
                    margin: EdgeInsets.only(left: 5),
                    child: BigText(text: head)),
              ],
            ),
            GestureDetector(
                onTap: () {},
                child: BigText(
                  text: '$body',
                  size: 15,
                )),
          ],
        )
      ]),
    );
  }

  bool forIos = false;
  @override
  Widget build(BuildContext context) {
    final imageurls = ImageUrls();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              BigText(
                text: "Edit Profile",
                size: 20,
                color: mainColor,
                fontWeight: FontWeight.w700,
              )
            ],
          ),
          titleSpacing: 0.1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: mainColor,
              // size: 35,
            ), // set the icon to the back arrow
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyProfile(profilepercentage: 50),
                  ));
            },
          ),
          elevation: 0.5, // set the elevation to 10.0
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.only(left: Get.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Manage Your Profile",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              child: BigText(
                                text:
                                    "Your Changes May Take 72 Hours To Visible",
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Hide Pic"),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10)
                                  .copyWith(right: 20),
                              child: Container(
                                alignment: Alignment.centerRight,
                                height: 35,
                                width: 55,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: CupertinoSwitch(
                                  // overrides the default green color of the track
                                  activeColor: Colors.white,
                                  // color of the round icon, which moves from right to left
                                  thumbColor:
                                      forIos ? mainColor : Colors.black12,
                                  // when the switch is off
                                  trackColor:
                                      forIos ? Colors.white : Colors.black12,
                                  // boolean variable value
                                  value: forIos,
                                  // changes the state of the switch
                                  onChanged: (value) {
                                    if (userSave.imageUrls!.isNotEmpty) {
                                      setState(() {
                                        forIos = value;
                                        userSave.isBlur = value;
                                      });
                                      if (picblockads.isNotEmpty ||
                                          picunblockads.isNotEmpty) {
                                        print("ok");
                                        showadsbar(
                                            context,
                                            value == false
                                                ? picunblockads
                                                : picblockads, () {
                                          Navigator.pop(context);
                                          HomeService().createeditprofile(
                                              userid: userSave.email!,
                                              isBlur: forIos,
                                              editname:
                                                  "Edit by ${userSave.name!}",
                                              aboutme: (userSave.About_Me ==
                                                          null ||
                                                      userSave.About_Me == "")
                                                  ? "Welcome to my profile. I'm here to find someone who appreciates authenticity and kindness. Hope you find what you're looking for."
                                                  : aboutmeController.text,
                                              mypreference: (userSave
                                                              .Partner_Prefs ==
                                                          null ||
                                                      userSave.Partner_Prefs ==
                                                          "")
                                                  ? "I am looking for a meaningful connection based on mutual respect, trust and shared values. Someone who is ready to grow and learn with me on this journey I would like to Connect"
                                                  : partnerPrefController.text,
                                              imageurls: userSave.imageUrls!);
                                          NotificationService()
                                              .addtoadminnotification(
                                                  userid: userSave.uid!,
                                                  subtitle: "EDIT PROFILE",
                                                  useremail: userSave.email!,
                                                  userimage: userSave
                                                          .imageUrls!.isEmpty
                                                      ? ""
                                                      : userSave.imageUrls![0],
                                                  title:
                                                      "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} ${value == false ? "UNHIDE" : "HIDE"} PROFILE ");
                                          HomeService().createeditprofile(
                                              userid: userSave.email!,
                                              isBlur: forIos,
                                              editname:
                                                  "Edit by ${userSave.name!}",
                                              aboutme: (userSave.About_Me ==
                                                          null ||
                                                      userSave.About_Me == "")
                                                  ? "Welcome to my profile. I'm here to find someone who appreciates authenticity and kindness. Hope you find what you're looking for."
                                                  : aboutmeController.text,
                                              mypreference: (userSave
                                                              .Partner_Prefs ==
                                                          null ||
                                                      userSave.Partner_Prefs ==
                                                          "")
                                                  ? "I am looking for a meaningful connection based on mutual respect, trust and shared values. Someone who is ready to grow and learn with me on this journey I would like to Connect"
                                                  : partnerPrefController.text,
                                              imageurls: userSave.imageUrls!);
                                          NotificationService()
                                              .addtoadminnotification(
                                                  userid: userSave.uid!,
                                                  subtitle: "EDIT PROFILE",
                                                  useremail: userSave.email!,
                                                  userimage: userSave
                                                          .imageUrls!.isEmpty
                                                      ? ""
                                                      : userSave.imageUrls![0],
                                                  title:
                                                      "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} ${value == false ? "UNLOCKED" : "LOCKED"} PROFILE PICTURES SUCCESSFULLY");
                                          HomeService()
                                              .updateblur(
                                                  email: userSave.email!,
                                                  isblur: value)
                                              .whenComplete(() {
                                            HomeService().getuserdata();
                                          });
                                        });
                                      } else {
                                        HomeService().createeditprofile(
                                            userid: userSave.email!,
                                            isBlur: forIos,
                                            editname:
                                                "Edit by ${userSave.name!}",
                                            aboutme: (userSave.About_Me ==
                                                        null ||
                                                    userSave.About_Me == "")
                                                ? "Welcome to my profile. I'm here to find someone who appreciates authenticity and kindness. Hope you find what you're looking for."
                                                : aboutmeController.text,
                                            mypreference: (userSave
                                                            .Partner_Prefs ==
                                                        null ||
                                                    userSave.Partner_Prefs ==
                                                        "")
                                                ? "I am looking for a meaningful connection based on mutual respect, trust and shared values. Someone who is ready to grow and learn with me on this journey I would like to Connect"
                                                : partnerPrefController.text,
                                            imageurls: userSave.imageUrls!);
                                        NotificationService()
                                            .addtoadminnotification(
                                                userid: userSave.uid!,
                                                subtitle: "EDIT PROFILE",
                                                useremail: userSave.email!,
                                                userimage: userSave
                                                        .imageUrls!.isEmpty
                                                    ? ""
                                                    : userSave.imageUrls![0],
                                                title:
                                                    "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} ${value == false ? "UNHIDE" : "HIDE"} PROFILE ");
                                        HomeService().createeditprofile(
                                            userid: userSave.email!,
                                            isBlur: forIos,
                                            editname:
                                                "Edit by ${userSave.name!}",
                                            aboutme: (userSave.About_Me ==
                                                        null ||
                                                    userSave.About_Me == "")
                                                ? "Welcome to my profile. I'm here to find someone who appreciates authenticity and kindness. Hope you find what you're looking for."
                                                : aboutmeController.text,
                                            mypreference: (userSave
                                                            .Partner_Prefs ==
                                                        null ||
                                                    userSave.Partner_Prefs ==
                                                        "")
                                                ? "I am looking for a meaningful connection based on mutual respect, trust and shared values. Someone who is ready to grow and learn with me on this journey I would like to Connect"
                                                : partnerPrefController.text,
                                            imageurls: userSave.imageUrls!);
                                        NotificationService()
                                            .addtoadminnotification(
                                                userid: userSave.uid!,
                                                subtitle: "EDIT PROFILE",
                                                useremail: userSave.email!,
                                                userimage: userSave
                                                        .imageUrls!.isEmpty
                                                    ? ""
                                                    : userSave.imageUrls![0],
                                                title:
                                                    "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} ${value == false ? "UNLOCKED" : "LOCKED"} PROFILE PICTURES SUCCESSFULLY");
                                        HomeService()
                                            .updateblur(
                                                email: userSave.email!,
                                                isblur: value)
                                            .whenComplete(() {
                                          HomeService().getuserdata();
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: ImageUrls(),
                              builder: (BuildContext context, dynamic value,
                                  Widget? child) {
                                final urls = value as List<String>;
                                var imageCount = imageurls.length;
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        (imageCount > 0)
                                            ? CustomImageContainer(
                                                isBlur: forIos,
                                                imageUrl: imageurls.imageUrl(
                                                    atIndex: 0),
                                                num: 0)
                                            : CustomImageContainer(
                                                num: 0,
                                                isBlur: forIos,
                                              ),
                                        (imageCount > 1)
                                            ? CustomImageContainer(
                                                isBlur: forIos,
                                                imageUrl: imageurls.imageUrl(
                                                    atIndex: 1),
                                                num: 1)
                                            : CustomImageContainer(
                                                num: 1,
                                                isBlur: forIos,
                                              ),
                                        (imageCount > 2)
                                            ? CustomImageContainer(
                                                isBlur: forIos,
                                                imageUrl: imageurls.imageUrl(
                                                    atIndex: 2),
                                                num: 2)
                                            : CustomImageContainer(
                                                num: 2,
                                                isBlur: forIos,
                                              ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        (imageCount > 3)
                                            ? CustomImageContainer(
                                                isBlur: forIos,
                                                imageUrl: imageurls.imageUrl(
                                                    atIndex: 3),
                                                num: 3)
                                            : CustomImageContainer(
                                                isBlur: forIos,
                                                num: 3,
                                              ),
                                        (imageCount > 4)
                                            ? CustomImageContainer(
                                                isBlur: forIos,
                                                imageUrl: imageurls.imageUrl(
                                                    atIndex: 4),
                                                num: 4)
                                            : CustomImageContainer(
                                                num: 4,
                                                isBlur: forIos,
                                              ),
                                        (imageCount > 5)
                                            ? CustomImageContainer(
                                                isBlur: forIos,
                                                imageUrl: imageurls.imageUrl(
                                                    atIndex: 5),
                                                num: 5)
                                            : CustomImageContainer(
                                                num: 5,
                                                isBlur: forIos,
                                              ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(top: 30, bottom: 15),
                                child: BigText(
                                  text: "About Me",
                                  size: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print("clicked");
                              if (!mounted) return;
                              setState(() {
                                aboutUpdateText = true;
                              });
                            },
                            child: Container(
                                // width: 300,
                                alignment: Alignment.topLeft,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                    boxShadow: [BoxShadow(blurRadius: 0.05)]),
                                margin: EdgeInsets.only(
                                  left: 28,
                                  right: 28,
                                ),
                                padding: EdgeInsets.only(
                                    left: 7, right: 5, top: 7, bottom: 7),
                                child: (aboutUpdateText != true)
                                    ? ExpandableText(
                                        (userSave.About_Me == null ||
                                                userSave.About_Me == "")
                                            ? "Welcome to my profile. I'm here to find someone who appreciates authenticity and kindness. Hope you find what you're looking for."
                                            : aboutmeController.text,
                                        collapseText: 'Less',
                                        linkColor: mainColor,
                                        expandText: 'More',
                                        maxLines: 1,
                                      )
                                    : TextField(
                                        controller: aboutmeController,
                                        minLines: 3,
                                        maxLength: 300,
                                        maxLines: 5,
                                        autofocus: isaboutautofocus,
                                        // maxLengthEnforcement: MaxLengthEnforcement
                                        //     .enforced, // show error message
                                        // maxLengthEnforcedMessage: 'You have reached the maximum character limit of 50',maxLines: 5,
                                        style: TextStyle(
                                            fontFamily: 'Sans-serif',
                                            fontSize: 17),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.only(top: 0.0),
                                          // border: OutlineInputBorder(),
                                          hintText: '',
                                        ),
                                      )),
                          ),
                        ]),
                      ),
                      Container(
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Align(
                              // alignment: FractionalOffset(0.15, 0.6),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(top: 30, bottom: 15),
                                child: BigText(
                                  text: "My Preference",
                                  size: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (!mounted) return;
                              setState(() {
                                partnerUpdateText = true;
                              });
                            },
                            child: Container(
                              // width: 310,
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(blurRadius: 0.05)]
                                  // color: Color(0xFFFFE9E6).withOpacity(0.25)
                                  ),
                              margin: EdgeInsets.only(
                                left: 28,
                                right: 28,
                              ),
                              padding: EdgeInsets.only(
                                  left: 7, right: 7, top: 7, bottom: 7),
                              child: (partnerUpdateText != true)
                                  ? ExpandableText(
                                      (userSave.Partner_Prefs == null ||
                                              userSave.Partner_Prefs == "")
                                          ? "I am looking for a meaningful connection based on mutual respect, trust and shared values. Someone who is ready to grow and learn with me on this journey I would like to Connect"
                                          : partnerPrefController.text,
                                      collapseText: 'Less',
                                      linkColor: mainColor,
                                      expandText: 'More',
                                      maxLines: 1,
                                    )
                                  : TextField(
                                      controller: partnerPrefController,
                                      maxLength: 300,
                                      minLines: 3,
                                      autofocus: ispatnerprefautofocus,
                                      maxLines: 5,
                                      style: TextStyle(
                                          fontFamily: 'Sans-serif',
                                          fontSize: 17),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 0.0),
                                        // hintText: 'Partner Prefs',
                                      ),
                                    ),
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Container(
                          child: Align(
                            // alignment: FractionalOffset(0.15, 0.6),
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(top: 15, bottom: 15),
                              child: BigText(
                                text: "Personal Details",
                                size: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SingleChildScrollView(
                      // child:
                      Column(
                        children: [
                          nameContainer('images/icons/name.png', "Name",
                              "${userSave.name![0].toUpperCase() + userSave.name!.substring(1)} ${userSave.surname![0].toUpperCase() + userSave.surname!.substring(1)}"),
                          const SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/email.png', "Email",
                              "${userSave.email}"),
                          const SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/contact.png',
                              "Contact No", "${userSave.phone}"),
                          const SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/calender.png',
                              "Date of Birth ", dob),
                          const SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/watch.png',
                              "Time of Birth", userSave.timeofbirth!),
                          const SizedBox(
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ImageIcon(
                                      AssetImage('images/icons/location.png'),
                                      color: mainColor,
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: BigText(text: "Place of birth")),
                                  ],
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: TickerText(
                                    // default values
                                    scrollDirection: Axis.horizontal,
                                    speed: 20,
                                    startPauseDuration:
                                        const Duration(seconds: 1),
                                    endPauseDuration:
                                        const Duration(seconds: 1),
                                    returnDuration:
                                        const Duration(milliseconds: 800),
                                    primaryCurve: Curves.linear,
                                    returnCurve: Curves.easeOut,
                                    child: Text(
                                      userSave.placeofbirth!,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(right: 5),
                                //   child: Container(
                                //     width:
                                //         MediaQuery.of(context).size.width * 0.4,
                                //     child: SingleChildScrollView(
                                //       scrollDirection: Axis.horizontal,
                                //       reverse: true,
                                //       child: Text(
                                //         "${userSave.placeofbirth}",
                                //         textAlign: TextAlign.end,
                                //         style: TextStyle(fontSize: 15),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/gender.png', "Gender",
                              "${userSave.gender}"),
                          SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/religion.png', "Religion",
                              "${userSave.religion}"),
                          SizedBox(
                            height: 2,
                          ),
                          (userSave.religion == "Hindu")
                              ? nameContainer('images/icons/kundli.png',
                                  "Kundli Dosh", "${userSave.KundaliDosh}")
                              : Container(),
                          SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/marital_status.png',
                              "Marital Status", "${userSave.MartialStatus}"),
                          SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/food.png', "Diet",
                              "${userSave.Diet}"),
                          SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/drink.png', "Drink",
                              "${userSave.Drink}"),
                          SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/smoke.png', "Smoke",
                              "${userSave.Smoke}"),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 25, right: 25),
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ImageIcon(
                                        AssetImage(
                                            'images/icons/disability.png'),
                                        color: mainColor,
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: BigText(
                                              text: "Disability With Person")),
                                    ],
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TickerText(
                                          // default values
                                          scrollDirection: Axis.horizontal,
                                          speed: 20,
                                          startPauseDuration:
                                              const Duration(seconds: 1),
                                          endPauseDuration:
                                              const Duration(seconds: 1),
                                          returnDuration:
                                              const Duration(milliseconds: 800),
                                          primaryCurve: Curves.linear,
                                          returnCurve: Curves.easeOut,
                                          child: Text(
                                            "${userSave.Disability}",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ]),
                          ),
                          // nameContainer('images/icons/disability.png',
                          //     "Disability With Person", "${userSave.Disability}"),
                          SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/height.png', "Height",
                              "${userSave.Height}"),
                          SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/education.png',
                              "Education", "${userSave.Education}"),
                          SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/profession_suitcase.png',
                              "Profession", "${userSave.Profession}"),
                          SizedBox(
                            height: 2,
                          ),
                          nameContainer('images/icons/hand_rupee.png', "Income",
                              "${userSave.Income}"),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 25, right: 25),
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ImageIcon(
                                        AssetImage('images/icons/location.png'),
                                        color: mainColor,
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: BigText(text: "Address")),
                                    ],
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: TickerText(
                                      // default values
                                      scrollDirection: Axis.horizontal,
                                      speed: 20,
                                      startPauseDuration:
                                          const Duration(seconds: 1),
                                      endPauseDuration:
                                          const Duration(seconds: 1),
                                      returnDuration:
                                          const Duration(milliseconds: 800),
                                      primaryCurve: Curves.linear,
                                      returnCurve: Curves.easeOut,
                                      child: Text(
                                        "${userSave.city},${userSave.state},${userSave.country}",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ]),
                          )
                        ],
                      ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(context, route)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyProfile(
                                        profilepercentage: profilepercentage,
                                      )));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shadowColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.black),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                          side: BorderSide(
                                            color: borderColor
                                                ? mainColor
                                                : Colors.white,
                                          ))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                  fontFamily: 'Serif',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                saveData(imageurls.value
                                    .map((str) => str as dynamic)
                                    .toList());
                              },
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  saveData(List<dynamic> imageurls) async {
    savedata = true;

    bool areEqual1 = const ListEquality().equals(imageurls, userSave.imageUrls);
    if (userSave.About_Me == aboutmeController.text &&
        userSave.Partner_Prefs == partnerPrefController.text &&
        areEqual1) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: SnackBarContent(
                error_text: "Please Make Some Changes",
                appreciation: "",
                icon: Icons.error,
                sec: 2,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            );
          });
    } else {
      userSave.verifiedStatus = "";
      userSave.status = "";
      userSave.videoLink = "";
      print(aboutmeController.text);
      NotificationService().deletevideo(email: userSave.email!);
      Searchservice().unverifyuser(email: userSave.email!);
      if (aboutmeController.text != userSave.About_Me) {
        NotificationService().addtoadminnotification(
            userid: userSave.uid!,
            subtitle: "EDIT PROFILE",
            useremail: userSave.email!,
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            title:
                "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} EDIT PROFILE ${"About Me"}");
      } else if (partnerPrefController.text != userSave.Partner_Prefs) {
        NotificationService().addtoadminnotification(
            userid: userSave.uid!,
            useremail: userSave.email!,
            subtitle: "EDIT PROFILE",
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            title:
                "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} EDIT PROFILE ${"About Partner Preference"}");
        NotificationFunction.setNotification(
          "admin",
          "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} EDIT PROFILE ${"About Partner Preference"}",
          'partnerprefupdate',
        );
        NotificationService().addtonotification(
            email: userSave.email!,
            title: "PARTNER PREFERENCE UPDATED SUCCESSFULLY");
        NotificationFunction.setNotification(
          "user1",
          "PARTNER PREFERENCE UPDATED SUCCESSFULLY",
          'partnerprefupdate',
        );

        try {
          SendMessage sendMessage = SendMessage();

          sendMessage.sendPushMessage("Edit profile successfully",
              "Edit profile", userSave.uid!, "profilepage", userSave.token!);
        } catch (e) {
          print(e);
        }
      } else if (areEqual1 == false) {
        NotificationService().addtoadminnotification(
            userid: userSave.uid!,
            subtitle: "EDIT PROFILE",
            useremail: userSave.email!,
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            title:
                "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} EDIT PROFILE UPLOAD PHOTO ");
      } else {
        // NotificationService().addtoadminnotification(
        //     userid: userSave.uid!,
        //     subtitle: "EDIT PROFILE",
        //     useremail: userSave.email!,
        //     userimage: userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
        //     title:
        //         "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} EDIT PROFILE ");
      }
      if (!mounted) return;
      setState(() {
        // userSave = User.fromdoc(usr);
        userSave.About_Me = aboutmeController.text;
        userSave.Partner_Prefs = partnerPrefController.text;
        userSave.status = '';
      });
      setState(() {
        if (imageurls.isEmpty) {
          userSave.imageUrls?.clear();

          userSave.verifiedStatus = "";
        } else {
          userSave.imageUrls?.addAll(imageurls);
        }
      });

      try {
        SupprotService().deletesendlink(
            email: userSave.email!, value: "To Improve About Me");
        SupprotService().deletesendlink(
            email: userSave.email!, value: "To Save Preference");
        SupprotService()
            .deletesendlink(email: userSave.email!, value: "To Upload Photo");
        SupprotService().deletesendlink(
            email: userSave.email!,
            value: "To Improve About Partner Preference");

        // // print(userSave.toJson().toString());
        // final json = userSave.toJson();
        HomeService().editprofile(
            email: userSave.email!,
            aboutme: aboutmeController.text,
            mypreference: partnerPrefController.text,
            imageurls: imageurls);
        HomeService().createeditprofile(
            userid: userSave.email!,
            isBlur: forIos,
            editname: "Edit by ${userSave.name!}",
            aboutme: (userSave.About_Me == null || userSave.About_Me == "")
                ? "Welcome to my profile. I'm here to find someone who appreciates authenticity and kindness. Hope you find what you're looking for."
                : aboutmeController.text,
            mypreference: (userSave.Partner_Prefs == null ||
                    userSave.Partner_Prefs == "")
                ? "I am looking for a meaningful connection based on mutual respect, trust and shared values. Someone who is ready to grow and learn with me on this journey I would like to Connect"
                : partnerPrefController.text,
            imageurls: imageurls);

        HomeService().updateeditstatus(email: userSave.email!);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Update Successfully",
                  appreciation: "",
                  icon: Icons.check_circle_rounded,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            }).then((value) {
          setState(() {});
          HomeService().getuserdata();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MyProfile(profilepercentage: profilepercentage),
            ),
            (route) => true,
          );
          if (saveads.isNotEmpty) {
            showadsbar(context, saveads, () {
              Navigator.pop(context);
            });
          }
        });
        HomeService().getuserdata();

        sharedPref.save("user", userSave);
      } catch (Excepetion) {
        print(Excepetion);
      }
    }
  }
}

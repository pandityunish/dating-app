import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/assets/image.dart';
import 'package:ristey/chat/main.dart';
import 'package:ristey/common/global.dart';
import 'package:ristey/common/widgets/logo_text.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/new_save_pref.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:ristey/models/shared_pref.dart';
import 'package:ristey/screens/delete_confirmation/delete_confirmation.dart';
import 'package:ristey/screens/main_screen.dart';
import 'package:ristey/screens/navigation/biodata.dart';
import 'package:ristey/screens/navigation/blinking_component.dart';
import 'package:ristey/screens/navigation/fpm/screens/free_matchmaking_screen.dart';
import 'package:ristey/screens/navigation/kundali_match.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:ristey/screens/navigation/support.dart';
import 'package:ristey/screens/notification.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/edit_profile.dart';
import 'package:ristey/screens/profile/online_profile.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/screens/profile/profile_verify.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/screens/search.dart';
import 'package:ristey/screens/search_pref/saved_pref.dart';
import 'package:ristey/send_utils/noti_function.dart';
import 'package:ristey/services/add_to_profile_service.dart';
import 'package:ristey/small_functions/profile_completion.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class IntWrapper {
  int value;

  IntWrapper(this.value);
}

class MyProfile extends StatefulWidget {
  final int profilepercentage;
  const MyProfile({
    Key? key,
    required this.profilepercentage,
  }) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Color newColor = mainColor;

  var numonline = 0;
  int getallnumberofunseen = 0;
  ProfileCompletion profile = ProfileCompletion();
  var profilepercentage = 50;
  late DatabaseReference _dbref;
  late DatabaseReference dbref;
  IntWrapper numunreadMessage = IntWrapper(10);
  var res = ["650e5ed0df998895982ca4e3"];
  bool color_done2 = false;
  var data1;
  void getuser() async {
    data1 = await SupprotService().getsupports(userSave.uid!);
    int statusCode = await UserService().finduser(userSave.email!);
    if (statusCode == 200) {
      HomeService().getuserdata();
    } else {}
    setState(() {});
  }

  void getallunseen() async {
    getallnumberofunseen =
        await HomeService().getallunseennumber(userid: userSave.uid!);
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    getallads();
    _dbref = FirebaseDatabase.instance.ref();
    dbref = FirebaseDatabase.instance.ref();
    getallunseen();
    getuseronlineusers();

    getuser();
    setData();
    // setData2();

    // setchatmessage();
  }

  setData() async {
    SharedPref sharedPref = SharedPref();

    final json2 = await sharedPref.read("uid");
    var json3;
    try {
      json3 = await sharedPref.read("user");
    } catch (e) {
      print(e);
    }

    _dbref = _dbref.child("onlineStatus");
    _dbref.orderByChild('status').equalTo('Online').onValue.listen((event) {
      try {
        var values = event.snapshot.value as Map<dynamic, dynamic>;
        res.clear();
        print(values);
        values.forEach((key, value) {
          if (!mounted) return;
          setState(() {
            res.add(value['uid'].toString());
          });
        });
      } catch (e) {
        print(e);
      }
    });
  }

  List<Map<dynamic, dynamic>> chatNumber = [];
  setData2() {
    _dbref = _dbref.child("chatroomids").child(userSave.uid!);
    _dbref.orderByChild('lmtime').onValue.listen((event) {
      try {
        var values = event.snapshot.value as Map<dynamic, dynamic>;
        chatNumber.clear();
        if (values.isNotEmpty) {
          values.forEach((snapshot, value) {
            chatNumber.add(value);
          });
        }
      } catch (e) {
        print(e);
      }
    });
  }

  deleteAccount() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DeleteConfirm()));
  }

  var percentProfilecomplited;
  profileComplition() {
    if (userSave.name != "") {}
  }

  List<NewUserModel> allonlineusers = [];
  void getuseronlineusers() async {
    var gen;
    if (userSave.gender == "male") {
      gen = "female";
    } else {
      gen = "male";
    }
    List<NewUserModel> allusers = await HomeService().getalluserdata(
        gender: gen,
        email: userSave.email!,
        religion: "",
        page: 1,
        ages: [],
        religionList: [],
        kundaliDoshList: [],
        citylocation: [],
        statelocation: [],
        maritalStatusList: [],
        dietList: [],
        drinkList: [],
        smokeList: [],
        disabilityList: [],
        heightList: [],
        educationList: [],
        professionList: [],
        incomeList: [],
        location: []);
    print(allusers);
    allonlineusers =
        allusers.where((element) => res.contains(element.id)).toList();
    setState(() {});
  }

  onlineUser() async {
    try {
      // print("onpressed clicked");

      if (allonlineusers.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (builder) =>
                OnlineProfile(notiPage: false, user_data: allonlineusers)));
        if (useronlineads.isNotEmpty) {
          showadsbar(context, onlineads, () {
            Navigator.pop(context);
          });
        } else {
          if (onlineads.isNotEmpty) {
            showadsbar(context, onlineads, () {
              Navigator.pop(context);
            });
          }
        }
      } else {
        // showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (context) {
        //       return const AlertDialog(
        //         content: SnackBarContent(
        //           error_text:
        //               "No Online Profile \n According \n Your Preference",
        //           appreciation: "",
        //           icon: Icons.error,
        //           sec: 2,
        //         ),
        //         backgroundColor: Colors.transparent,
        //         elevation: 0,
        //       );
        //     }).whenComplete(() {
          if (useronlineads.isNotEmpty) {
            showadsbar(context, useronlineads, () {
              Navigator.pop(context);
            });
          } else {
            if (onlineads.isNotEmpty) {
              showadsbar(context, onlineads, () {
                Navigator.pop(context);
              });
            }
          }
        // });
        // Future(() {customAlertBox1(context, Icons.error,
        //     "No Online Profile \n According \n Your Preference", "", () {});})

        // await showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         content: SnackBarContent3(
        //             error_text: "No Online Profile",
        //             appreciation: "",
        //             icon: Icons.error),
        //         backgroundColor: Colors.transparent,
        //         elevation: 0,
        //       );
        //     });
      }
    } catch (e) {
      print(e);
    }
  }

  List<AdsModel> allads = [];

  showinfo() {
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
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => MainAppContainer(
                                notiPage: false,
                              )),
                      (route) => false);
                },
                child: Container(
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
          content: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/icons/free_ristawala.png'),
                  const SizedBox(
                    height: 10,
                  ),
                  allads.isNotEmpty
                      ? Center(
                          child: Image.network(allads[0].image),
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
                            // Container(
                            //   height: 140,
                            //   width: 100,
                            //   decoration: const BoxDecoration(
                            //       image: DecorationImage(
                            //           image: AssetImage("images/saurabh.png"),
                            //           // image: NetworkImage(
                            //           //     "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"),
                            //           fit: BoxFit.cover)),
                            // ),
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

  Future<void> scheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Scheduled Title', // Title
      'Scheduled Body', // Body
      tz.TZDateTime.now(tz.local)
          .add(const Duration(seconds: 1)), // Scheduled time
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id', // Channel ID
          'your channel name', // Channel Name
          // Channel Description
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  List<AdsModel> usersearchads = [];
  List<AdsModel> usersavepreferenceads = [];
  List<AdsModel> useronlineads = [];
  List<AdsModel> userverifiedads = [];
  List<AdsModel> usermatchmakingads = [];
  List<AdsModel> userchatads = [];
  List<AdsModel> userkundlimatchads = [];
  List<AdsModel> userbiodataads = [];
  List<AdsModel> usermarrigeloanads = [];
  List<AdsModel> usershareapp = [];
  List<AdsModel> usersupportapp = [];
  List<AdsModel> usereditprofile = [];
  List<AdsModel> userlogoutprofile = [];
  List<AdsModel> userdeleteprofile = [];
  void getallads() async {
    allads = await AdsService().getallusers(adsid: "");
    usersearchads = adsuser.where((element) => element.adsid == "26").toList();
    usersavepreferenceads =
        adsuser.where((element) => element.adsid == "30").toList();
    useronlineads = adsuser.where((element) => element.adsid == "33").toList();
    userverifiedads =
        adsuser.where((element) => element.adsid == "34").toList();
    usermatchmakingads =
        adsuser.where((element) => element.adsid == "35").toList();
    userchatads = adsuser.where((element) => element.adsid == "42").toList();
    userkundlimatchads =
        adsuser.where((element) => element.adsid == "58").toList();
    userbiodataads = adsuser.where((element) => element.adsid == "60").toList();
    usermarrigeloanads =
        adsuser.where((element) => element.adsid == "65").toList();
    usersupportapp = adsuser.where((element) => element.adsid == "67").toList();
    usereditprofile =
        adsuser.where((element) => element.adsid == "81").toList();
    userdeleteprofile =
        adsuser.where((element) => element.adsid == "85").toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: const TextSpan(
        // text: "${userSave.name} ${userSave.surname}",
        text: "ABCDEFGHIJK",
        style: TextStyle(fontSize: 14),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final textWidth = textPainter.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 35, bottom: 15),
              padding: const EdgeInsets.only(left: 1),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () async {},
                            child: Container(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MainAppContainer(
                                                    notiPage: false),
                                          ));
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: mainColor,
                                    ),
                                  ),
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(35),
                                        border: (userSave.imageUrls == null ||
                                                userSave.imageUrls!.isEmpty)
                                            ? Border.all(
                                                width: 1, color: mainColor)
                                            : Border.all(
                                                width: 2, color: Colors.white),
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: (userSave.imageUrls ==
                                                        null ||
                                                    userSave
                                                        .imageUrls!.isEmpty)
                                                ? const NetworkImage(
                                                    "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/impImage%2FnavImageError.png?alt=media&token=49f90276-0a97-4f1f-910f-28e95f1ac29c")
                                                // "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/Images%2F70.png?alt=media&token=05816459-b75e-44ee-8ca6-a6b9b4d9cbf8")
                                                : NetworkImage(
                                                    userSave.imageUrls![0]))),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5),
                                                // width: textWidth,
    
                                                child: SizedBox(
                                                  width: Get.width * 0.33,
                                                  child:
                                                      SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: BigText(
                                                      text: (userSave.name ==
                                                              null)
                                                          ? "Ghanshyam Ramayiyavasta"
                                                          : "${userSave.name![0].toUpperCase() + userSave.name!.substring(1)} ${userSave.surname![0].toUpperCase() + userSave.surname!.substring(1)}",
                                                      size: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(
                                                text: userSave.puid??""))
                                            .then((value) {
                                          //only if ->
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Copied successfully")));
                                        });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 5),
                                                  child: BigText(
                                                    // text: uid.toString().substring(uid.length()-5),
                                                    text:
                                                        (userSave.puid != null)
                                                            ? userSave.puid!
                                                            : "",
                                                            color: mainColor,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              (userSave.verifiedStatus ==
                                                          "verified" &&
                                                      userSave.imageUrls!
                                                          .isNotEmpty)
                                                  ? Icon(
                                                      Icons.verified_user,
                                                      color: mainColor,
                                                      size: 35,
                                                    )
                                                  : const Text(""),
                                              const SizedBox(
                                                height: 4,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.01),
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  width: 2.0,
                                  color: mainColor,
                                ),
                                backgroundColor: Colors.white,
                                minimumSize: const Size(40, 35),
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                )),
                            child: BigText(
                              text: "Edit Profile",
                              size: 15,
                              color: mainColor,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfile()));
                              if (usereditprofile.isNotEmpty) {
                                showadsbar(context, usereditprofile, () {
                                  Navigator.pop(context);
                                });
                              } else {
                                if (editads.isNotEmpty) {
                                  showadsbar(context, editads, () {
                                    Navigator.pop(context);
                                  });
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18, top: 5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 8,
                        width: MediaQuery.of(context).size.width * 0.82,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: mainColor),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                height: 8,
                                width: MediaQuery.of(context).size.width *
                                    0.82 *
                                    userProfilePercentage /
                                    100,
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Profile Completion ${userProfilePercentage}%",
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ],
              ),
            ),
            Container(
              // margin: EdgeInsets.only(left: 10),
              padding: EdgeInsetsDirectional.only(
                end: MediaQuery.of(context).size.width * 0.1,
              ),
    
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          is25Ads = true;
                          int statusCode =
                              await UserService().finduser(userSave.email!);
                          if (statusCode == 200) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MainAppContainer(
                                          notiPage: false,
                                        )),
                                (route) => false);
                          } else {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FirstScreen()),
                                (route) => false);
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.clear();
                          }
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Image.asset(
                                'images/icons/home.png',
                                width: 23,
                                height: 23,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Home",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Search()));
                          if (usersearchads.isNotEmpty) {
                            showadsbar(context, usersearchads, () {
                              Navigator.pop(context);
                            });
                          } else {
                            if (searchads.isNotEmpty) {
                              showadsbar(context, searchads, () {
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Image.asset(
                                'images/icons/search.png',
                                width: 23,
                                height: 23,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Search Profile",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SearchPreferences()));
                          if (usersavepreferenceads.isNotEmpty) {
                            showadsbar(context, usersavepreferenceads, () {
                              Navigator.pop(context);
                            });
                          } else {
                            if (savePreferads.isNotEmpty) {
                              showadsbar(context, savePreferads, () {
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Image.asset(
                                'images/icons/filter.png',
                                width: 23,
                                height: 23,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Saved Preference",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AddToProfileService().updateonlinedata();
    
                          onlineUser();
                          AddToProfileService().updateonlineuser();
                          NotificationService().addtoadminnotification(
                              userid: userSave.uid!,
                              useremail: userSave.email!,
                              subtitle: "ONLINE PROFILES",
                              userimage: userSave.imageUrls!.isEmpty
                                  ? ""
                                  : userSave.imageUrls![0],
                              title:
                                  "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEEN ONLINE PROFILES");
                          NotificationFunction.setNotification(
                            "admin",
                            "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEEN ONLINE PROFILES",
                            'onlineuser',
                          );
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Image.asset(
                                'images/icons/user_dot_green.png',
                                width: 23,
                                height: 23,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Stack(
                              children: [
                                const SizedBox(
                                  width: 120,
                                  child: Text(
                                    "Online",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18),
                                  ),
                                ),
                                // Positioned(
                                //   top: -1,
                                //   right: 0,
                                //   child: Container(
                                //       margin: const EdgeInsets.only(top: 5),
                                //       child: const BlinkingColorScreen()),
                                // ),
                              ],
                            ),
    
                            const SizedBox(width: 4, height: 5),
    
                            // ImageIcon(AssetImage("images/icons/user.png")),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (userSave.imageUrls == null ||
                              userSave.imageUrls!.isEmpty) {
                            AddToProfileService().updateprofileverified();
    
                            NotificationService().addtoadminnotification(
                                userid: userSave.uid!,
                                useremail: userSave.email!,
                                subtitle: "ONLINE PROFILES",
                                userimage: userSave.imageUrls!.isEmpty
                                    ? ""
                                    : userSave.imageUrls![0],
                                title:
                                    "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} TRIED TO VERIFIED PROFILE WITHOUT PHOTO ");
                            Future(() => customAlertBox1(
                                context,
                                Icons.error,
                                "Profile Pics Required \n To \n Verify profile",
                                "",
                                () {}));
                          } else if (userSave.status == "block") {
                            AddToProfileService().updateprofileverified();
    
                            Future(() => customAlertBox1(context, Icons.error,
                                "Under Process", "", () {}));
                          } else if(userSave.verifiedStatus == "approved"){
    
                            Future(() => customAlertBox1(context, Icons.check_circle_sharp,
                                "Already Verified", "", () {}));
                          }else if(userSave.videoLink != ""){
    
                            Future(() => customAlertBox1(context, Icons.check_circle_sharp,
                                "Under Process", "", () {}));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Verify()));
                            if (userprofileads.isNotEmpty) {
                              showadsbar(context, userprofileads, () {
                                Navigator.pop(context);
                              });
                            } else {
                              if (profileads.isNotEmpty) {
                                showadsbar(context, profileads, () {
                                  Navigator.pop(context);
                                });
                              }
                            }
                          }
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Image.asset(
                                'images/icons/verified.png',
                                width: 23,
                                height: 23,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Profile Verification",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //  if (userSave.status == "approved") {
                          AddToProfileService().freepersonmatch();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FreeMatchmakingScreen()));
                          if (usermatchmakingads.isNotEmpty) {
                            showadsbar(context, usermatchmakingads, () {
                              Navigator.pop(context);
                            });
    
                            // }
                          } else {
                            if (matchmakingads.isNotEmpty) {
                              showadsbar(context, matchmakingads, () {
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Image.asset(
                                'images/icons/shake_heart.png',
                                width: 23,
                                height: 23,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Free Personalized Matchmaking",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AddToProfileService().updatechatnow();
    
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) => const ChatPageHome()));
                          if (userchatads.isNotEmpty) {
                            showadsbar(context, userchatads, () {
                              Navigator.pop(context);
                            });
                          } else {
                            if (chatads.isNotEmpty) {
                              showadsbar(context, chatads, () {
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Image.asset(
                                'images/icons/chat.png',
                                width: 23,
                                height: 23,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Chat Now",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BlinkingNumber(
                                    color: (getallnumberofunseen > 0)
                                        ? mainColor
                                        : Colors.white,
                                    number: getallnumberofunseen.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  (userSave.religion == "Hindu")
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const KundliMatch()));
                                    if (userkundaliads.isNotEmpty) {
                                      showadsbar(context, userkundaliads, () {
                                        Navigator.pop(context);
                                      });
                                    } else {
                                      if (kundaliads.isNotEmpty) {
                                        showadsbar(context, kundaliads, () {
                                          Navigator.pop(context);
                                        });
                                      }
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        child: Image.asset(
                                          'images/icons/kundli.png',
                                          width: 23,
                                          height: 23,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        "Free Kundli Match",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AddToProfileService().updatebiodata();
    
                          // Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => BioData()));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => BioData()));
                          if (userSave.verifiedStatus == "verified" &&
                              userSave.imageUrls!.isNotEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BioData()));
                            if (userbioads.isNotEmpty) {
                              showadsbar(context, userbioads, () {
                                Navigator.pop(context);
                              });
                            } else {
                              if (bioads.isNotEmpty) {
                                showadsbar(context, bioads, () {
                                  Navigator.pop(context);
                                });
                              }
                            }
                          } else {
                            (userSave.videoLink == null ||
                                    userSave.videoLink == "" ||
                                    userSave.imageUrls!.isEmpty)
                                ? Future(() => customAlertBox1(
                                    context,
                                    Icons.error,
                                    "Profile Verification Required\nTo\nDownload Matrimonial Biodata",
                                    "",
                                    () {}))
                                : Future(() => customAlertBox1(
                                    context,
                                    Icons.error,
                                    "Profile Verification\nis\nUnder Process",
                                    "",
                                    () {}));
                          }
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Image.asset(
                                'images/icons/download.png',
                                width: 23,
                                height: 23,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Download Matrimonial Biodata",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          NotificationService().addtoadminnotification(
                              userid: userSave.uid!,
                              subtitle: "Profile Create",
                              useremail: userSave.email!,
                              userimage: userSave.imageUrls!.isEmpty
                                  ? ""
                                  : userSave.imageUrls![0],
                              title:
                                  "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} NEED MARRIAGE LOAN ");
                          AddToProfileService().marriageloanupdate();
    
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: SnackBarContent(
                                    error_text:
                                        "Sorry\n Service is Not Available In Your Area \n Please Try Again Later",
                                    appreciation: "",
                                    icon: Icons.error,
                                    sec: 2,
                                  ),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                );
                              }).whenComplete(() {
                            if (usermarrigeloanads.isNotEmpty) {
                              showadsbar(context, usermarrigeloanads, () {
                                Navigator.pop(context);
                              });
                            } else {
                              if (marriageloanads.isNotEmpty) {
                                showadsbar(context, marriageloanads, () {
                                  Navigator.pop(context);
                                });
                              }
                            }
                          });
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Image.asset(
                                'images/icons/income.png',
                                width: 23,
                                height: 23,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Marriage Loan (0% Interest)",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          print(shareads.length);
                           if (usershareapp.isNotEmpty) {
                            showadsbar(context, usershareapp, () async {
                              Get.back();
                            });
                          } else {
                            if (shareads.isNotEmpty) {
                              showadsbar(context, shareads, () async {
                                Get.back();
                              });
                            }
                          }
                          NotificationService().addtoadminnotification(
                              userid: userSave.uid!,
                              subtitle: "Profile Create",
                              useremail: userSave.email!,
                              userimage: userSave.imageUrls!.isEmpty
                                  ? ""
                                  : userSave.imageUrls![0],
                              title:
                                  "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SHARE APP");
                          AddToProfileService().updateshare();
                          SupprotService().deletesendlink(
                              email: userSave.email!, value: "To Share App");
    
                          await Share.share(
                              'https://play.google.com/store/apps/details?id=com.freerishtey.android');
                         
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Image.asset(
                                'images/icons/share.png',
                                width: 23,
                                height: 23,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Share App",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SupportScreen()));
                          if (supportads.isNotEmpty) {
                            showadsbar(context, supportads, () {
                              Navigator.pop(context);
                            });
                          } else if (usersupportads.isNotEmpty) {
                            showadsbar(context, usersupportads, () {
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Image.asset(
                                'images/icons/community.png',
                                width: 23,
                                height: 23,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Stack(
                              children: [
                                const SizedBox(
                                  width: 80,
                                  child: Text(
                                    "Support",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18),
                                  ),
                                ),
                                data1 == null
                                    ? const Center()
                                    : Positioned(
                                        top: -4,
                                        right: 0,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              BlinkingNumber(
                                                  color: data1.length <= 0
                                                      ? Colors.white
                                                      : (data1[0]["isAdmin"] ==
                                                              true)
                                                          ? mainColor
                                                          : Colors.white,
                                                  number: "1"),
                                            ],
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: mainColor,
        selectedItemColor: mainColor,
        backgroundColor: Colors.white,
        onTap: (int index) {
          switch (index) {
            case 0:
              deleteAccount();
              if (userdeleteprofile.isNotEmpty) {
                showadsbar(context, userdeleteprofile, () {
                  Navigator.pop(context);
                });
              } else {
                if (deleteads.isNotEmpty) {
                  showadsbar(context, deleteads, () {
                    Navigator.pop(context);
                  });
                }
              }
              break;
            case 1:
              {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: SizedBox(
                          height: 244,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   height: 26,
                              // ),
                              // const LogoText(),
                             
                              const Text("Log Out \n You Want to Log Out?",
                                  textAlign: TextAlign.center),
                              const SizedBox(
                                height: 23,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 6),
                                width:
                                    MediaQuery.of(context).size.width * 0.8,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shadowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.black),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry?>(
                                          const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        60.0),
                                                side: BorderSide(
                                                  color:
                                                      (color_done2 == false)
                                                          ? Colors.white
                                                          : mainColor,
                                                ))),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white)),
                                    onPressed: () async {
                                      if (!mounted) return;
                                      setState(() {
                                        color_done2 = true;
                                      });
    
                                      await NotificationFunction
                                          .setOnlineStatus(
                                              userSave.uid!, "Offline");
    
                                      logout(
                                          context: context,
                                          noti: true,
                                          isLogout: false);
                                    },
                                    child: Text(
                                      "Yes",
                                      style: (color_done2 == false)
                                          ? const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Serif',
                                              fontWeight: FontWeight.w700)
                                          : TextStyle(
                                              color: mainColor,
                                              fontSize: 16,
                                              fontFamily: 'Serif',
                                              fontWeight: FontWeight.w700),
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
    
                              Container(
                                margin: const EdgeInsets.only(left: 6),
                                width:
                                    MediaQuery.of(context).size.width * 0.8,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shadowColor: MaterialStateColor.resolveWith(
                                            (states) => Colors.black),
                                        padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                            const EdgeInsets.symmetric(
                                                vertical: 12)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        60.0),
                                                side: const BorderSide(
                                                  color: Colors.white,
                                                ))),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel",
                                        style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Serif', fontWeight: FontWeight.w700))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
                if (userlogoutprofile.isNotEmpty) {
                  showadsbar(context, userlogoutprofile, () {
                    Navigator.pop(context);
                  });
                } else {
                  if (logoutads.isNotEmpty) {
                    showadsbar(context, logoutads, () {
                      Navigator.pop(context);
                    });
                  }
                }
              }
              break;
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              const AssetImage('images/icons/delete_bin.png'),
              size: 22,
              color: mainColor,
            ),
            label: 'Delete Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout,
              size: 25,
              color: mainColor,
            ),
            label: 'Log Out',
          ),
        ],
      ),
    );
  }
}

bool logoutrunning = false;
Future<void> logout(
    {required BuildContext context, required noti, required isLogout}) async {
  // if (logoutrunning)
  //   return;
  // else {
  isLogoutString = "";
  HomeService().cleartoken(
    email: userSave.email!,
  );
  print("hello");

  HomeService().updatelogin(email: userSave.email!, mes: "false");
  logoutrunning = true;

  try {
    try {
      await NotificationFunction.setOnlineStatus(userSave.uid!, "Offline");
      SharedPref sharedpref = SharedPref();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.clear();
      sharedPreferences.setString("email", "");
      sharedPreferences.setString("location", "");
      if (isLogout == true) {
      } else {
        NotificationService().addtoadminnotification(
            userid: userSave.uid!,
            useremail: userSave.email!,
            subtitle: "ONLINE PROFILES",
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            title:
                "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} LOGOUT PROFILE");

        NotificationService().addtonotification(
            email: userSave.email!, title: "LOGOUT PROFILE SUCCESSFULLY");
      }

      Get.find<HomeService>().saveprefdata.value = NewSavePrefModel(
          email: "",
          ageList: [],
          citylocation: [],
          statelocation: [],
          id: "",
          v: 0,
          religionList: [],
          kundaliDoshList: [],
          maritalStatusList: [],
          dietList: [],
          drinkList: [],
          smokeList: [],
          disabilityList: [],
          heightList: [],
          educationList: [],
          professionList: [],
          incomeList: [],
          location: []);

      userSave.uid = "";
      userSave.imageUrls!.clear();
      userSave.About_Me = "";
      userSave.Partner_Prefs = "";
      userSave.name = "";
      sharedpref.remove("user");
      sharedpref.remove("uid");
      sharedpref.remove("savedPref");
      sharedpref.remove("imgdict");
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: SnackBarContent(
            error_text: "Error Logout",
            appreciation: "",
            icon: Icons.error,
            sec: 2,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }

    try {
      isLogin = false;
      uid = "";
      ImageUrls().clear();
      imgDict.imageDictionary!.clear();
      friends = []; //sent requests
      friendrej = []; //rejected requests
      blocFriend = []; //blocked users
      reportFriend = []; //blocked users
      shortFriend = [];
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: SnackBarContent(
            error_text: "Error Logout",
            appreciation: "",
            icon: Icons.error,
            sec: 2,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  } catch (e) {
    print(e);
  }
  final GoogleSignIn googleSignIn = GoogleSignIn();
  try {
    if (!kIsWeb) {
      await googleSignIn.signOut();
    }

    await FirebaseAuth.instance.signOut();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: SnackBarContent(
          error_text: "Error Logout",
          appreciation: "",
          icon: Icons.error_rounded,
          sec: 2,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  try {
    // noti
    //     ? NotificationFunction.setNotification(
    //         "admin",
    //         "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} LOGOUT PROFILE ",
    //         'logout',
    //       )
    //     : () {};
    // noti
    //     ?
    //     NotificationFunction.setNotification(
    //         "user1",
    //         "LOGOUT SUCCESSFULLY ",
    //         'logout',
    //       )
    //     : () {};
    // userSave = usr.User();
  } on Exception catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: SnackBarContent(
          error_text: "Error Logout",
          appreciation: "",
          icon: Icons.error,
          sec: 2,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  isLogout == false
      ? await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: SnackBarContent(
                appreciation: "",
                error_text: "Profile Log Out Successfully",
                icon: Icons.check_circle_rounded,
                sec: 2,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            );
          })
      : () {};

  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (builder) => const FirstScreen()),
      (route) => false);
  logoutrunning = false;
}

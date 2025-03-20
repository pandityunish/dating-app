import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ristey/models/shared_pref.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/error/save_pref_error.dart';
import 'package:ristey/screens/mobile_chat_screen.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/notification/nav_home.dart';
import 'package:ristey/screens/profile/profile_page.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/send_utils/noti_function.dart';
import 'package:ristey/small_functions/profile_completion.dart';

import '../../global_vars.dart';

var profiledata;

class OnlineProfile extends StatefulWidget {
  OnlineProfile(
      {super.key,
      this.type = "",
      this.user_data,
      this.user_list,
      required this.notiPage});
  String type;
  var user_data;
  bool notiPage = false;
  var user_list;
  @override
  State<OnlineProfile> createState() => _SlideProfileState();
}

class _SlideProfileState extends State<OnlineProfile> {
  int num = 6;
  int pagecount = 0;
  int profilepercentage = 0;
  bool load = false;
  DatabaseReference? _notificationsRef;
  int _unreadCount = 0;
  // User userSave = User();
  List<User> userlist = [];
  List<User> largeuserlist = [];
  bool nodata = false;
  cloud.QueryDocumentSnapshot? lastDocument;
  HomeService homeservice = Get.put(HomeService());
  ProfileCompletion profile = ProfileCompletion();
  void getalluserlists() async {}

  @override
  void initState() {
    setState(() {
      load = true;
    });
    // print("Page is Running");
    super.initState();
    homeservice.getuserdata().whenComplete(() {
      getalluserlists();
    });

    // getUserList();
    // _notificationsRef =
    //     FirebaseDatabase.instance.ref().child('user1').child(userSave.uid!);
    // _notificationsRef!.onValue.listen((event) {
    //   int count = 0;

    //   Map<dynamic, dynamic> notifications =
    //       event.snapshot.value as Map<dynamic, dynamic>;
    // });
  }

  setuserData() async {
    // print("uid out if ${uid}");
    if (uid == null || uid == "") {
      print("uid under if ${uid}");
      final json2 = await sharedPref.read("uid");
      final json3 = await sharedPref.read("user");
      print("reading numsentreq");
      final json4 = await sharedPref.read("numsentreq");
      print("Json 4 Printing : ${json4}");
      if (!mounted) return;
      setState(() {
        uid = json2['uid'];
        userSave = User.fromJson(json3);
      });
    }
    await setsavedpref();
  }

  setsavedpref() async {
    try {
      final doc = await cloud.FirebaseFirestore.instance
          .collection('saved_pref')
          .doc(uid)
          .get();
      savedPref = SavedPref.fromdoc(doc);
      await sharedPref.save("savedPref", savedPref);
    } catch (e) {
      print(e);
    }
    try {
      var json4 = await SharedPref().read('imgdict');
      imgDict = ImageList(
          imageDictionary: (json4 as List<dynamic>)
              .map((p) => ImagePathInfo.fromJson(p))
              .toSet());
    } catch (e) {
      print(e);
    }
  }

  setFriendList() async {
    try {
      var dbref = FirebaseDatabase.instance.ref();
      dbref = dbref.child('friend_list');
      dbref.child(userSave.uid!).child('sent').onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        // if (friends.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          friends.clear();
          frienda.clear();
        });
        // }

        if (snapshot.value != null) {
          Map<dynamic, dynamic> values =
              snapshot.value as Map<dynamic, dynamic>;
          values.forEach((snapshot, value) {
            if (!mounted) return;
            setState(() {
              friends.add(value['toUid']);
              if (value["status"] == "accepted") {
                frienda.add(value["toUid"]);
              } else if (value["status"] == "rejected") {
                friendrej.add(value["toUid"]);
              }
            });
          });
        }
      });
      var dbref2 = FirebaseDatabase.instance.ref();
      dbref2 = dbref2.child('friend_list');
      dbref2.child(userSave.uid!).child('received').onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        // if (friendr.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          friendr.clear();
        });
        // }
        if (snapshot.value != null) {
          Map<dynamic, dynamic> values =
              snapshot.value as Map<dynamic, dynamic>;
          values.forEach((snapshot, value) {
            if (!mounted) return;
            setState(() {
              print("friendr : $value");
              friendr.add(value["fromUid"]);
              if (value["status"] == "accepted") {
                frienda.add(value["fromUid"]);
              }
            });
          });
        }
      });
    } catch (e) {
      print("error in setfriendList : $e");
    }
  }

  setBlockList() async {
    try {
      var dbref = FirebaseDatabase.instance.ref();
      dbref = dbref.child('block_list');
      dbref.child(userSave.uid!).onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        // if (blocFriend.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          blocFriend.clear();
        });
        // }
        if (snapshot.value != null) {
          Map<dynamic, dynamic> values =
              snapshot.value as Map<dynamic, dynamic>;
          values.forEach((snapshot, value) {
            // print("blocfriend setstate running ${values.length}");
            // print("uid is : ${value["toUid"]} ");
            if (!mounted) return;
            setState(() {
              blocFriend.add(value["toUid"]);
            });
          });
        }
      });
    } catch (e) {
      print("the error in blockList  : $e");
    }
  }

  setReportList() async {
    try {
      var dbref = FirebaseDatabase.instance.ref();
      dbref = dbref.child('report_list');
      dbref.child(userSave.uid!).onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        // if (reportFriend.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          reportFriend.clear();
        });
        // }

        if (snapshot.value != null) {
          Map<dynamic, dynamic> values =
              snapshot.value as Map<dynamic, dynamic>;
          values.forEach((snapshot, value) {
            // print("uid is : ${value["toUid"]} ");
            if (!mounted) return;
            setState(() {
              reportFriend.add(value["toUid"]);
            });
          });
        }
      });
    } catch (e) {
      print("the error in report List  : $e");
    }
  }

  setShortList() async {
    try {
      var dbref = FirebaseDatabase.instance.ref();
      dbref = dbref.child('short_list');
      dbref.child(userSave.uid!).onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        // if (shortFriend.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          shortFriend.clear();
        });
        // }
        if (snapshot.value != null) {
          Map<dynamic, dynamic> values =
              snapshot.value as Map<dynamic, dynamic>;
          values.forEach((key, value) {
            if (value is Map && value.containsKey('toUid')) {
              String toUid = value['toUid'];
              if (!mounted) return;
              setState(() {
                shortFriend.add(toUid);
              });
            }
          });
        }
      });
    } catch (e) {
      print("the error in short List  : $e");
    }
  }

  setdata() async {
    try {
      setFriendList();
      setBlockList();
      setReportList();
      setShortList();
    } catch (e) {
      print("The error in set data : $e");
    }
  }

  String? lastpage;
  pushChatPage(
    var roomid,
    var profiledata,
    var profilepic,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (maincontext) => Scaffold(
                body: MobileChatScreen(
                    roomid: roomid,
                    profileDetail: profiledata,
                    profilepic: profilepic),
              )),
    );
  }

  data() async {
    SharedPref sharedPref = SharedPref();
    final json2 = await sharedPref.read("uid");
    var uid = json2['uid'];
    cloud.FirebaseFirestore.instance
        .collection('user_data')
        .doc(uid)
        .get()
        .then((cloud.DocumentSnapshot doc) async {
      if (!mounted) return;
      setState(() {
        userSave = User.fromdoc(doc);
        load = true;
      });
    });
  }

  int currentPage = 0;
  //  PageController controller = PageController(initialPage: 100,);
  PageController controller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        // key: scrollKey,
        // key: scrollKey,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              widget.user_data.isEmpty
                  ?
                  // ? Center(
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: const [
                  //         // CircularProgressIndicator(),
                  //         Text(
                  //             "No data available according to preference \nKindly change your preference"),
                  //       ],
                  //     ),
                  //   )
                  SavePreferencesError(
                      isfirst: true,
                    )
                  :
//                       PageView.builder(
//   controller: controller,
//   onPageChanged: (index) {

//   },
//   itemCount: newuserlists.length, // Use itemCount to specify the number of items
//   itemBuilder: (BuildContext context, int index) {

//     final user = newuserlists[index];

//     return index < newuserlists.length? Column(
//       children: <Widget>[
//         Expanded(
//           child: ProfilePage(
//             index: index,
//             userSave: user,
//             pushchat: pushChatPage,
//           ),
//         ),
//       ],
//     ):Column(
//       children: [
//         Center(child: Text("helool dflak"),)
//       ],
//     );
//   },
// ),
                  PageView.builder(
                      controller: controller,
                      onPageChanged: (index) {
                        // if (index % 6 == 5 && index == num - 1) {
                        // if (num > 4 && index == num - 3) {
                      },
                      itemBuilder: (BuildContext context, int index) {
                        // Show the SavePreferencesError widget at the end

                        return Column(children: <Widget>[
                          Expanded(
                            child: ProfilePage(
                                // list: userlist,
                                index: index,
                                userSave: widget.user_data[index],
                                controller: controller,
                                pushchat: pushChatPage),
                          ),
                        ]);
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.user_data.length,
                    ),
              (widget.notiPage)
                  ? Positioned(
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.04,
                      child: IconButton(
                        icon: Icon(
                          // Icons.more_vert_outlined,//for three dots
                          Icons.arrow_back_ios, //for three lines
                          size: 25,
                          color: mainColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  : Positioned(
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.04,
                      child: IconButton(
                        icon: const Icon(
                          // Icons.more_vert_outlined,//for three dots
                          Icons.menu, //for three lines
                          size: 20,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(color: Colors.black, blurRadius: 15.0)
                          ],
                        ),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyProfile(
                                        profilepercentage: profilepercentage,
                                      )));

                          // builder: (context) => const CallSample()));

                          // Get.to(() => const MyProfile(),
                          //     transition: Transition.zoom);
                        },
                      ),
                    ),
              (widget.notiPage)
                  ? Positioned(
                      child: Container(
                      width: 0,
                      height: 0,
                    ))
                  : Positioned(
                      right: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.04,
                      child: IconButton(
                        icon: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              child: const Icon(
                                // Icons.more_vert_outlined,//for three dots
                                FontAwesomeIcons.bell, //for three lines
                                size: 25,
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(color: Colors.black, blurRadius: 15.0)
                                ],
                              ),
                            ),
                            if (_unreadCount >= 0)
                              Positioned(
                                right: 6,
                                top: 5.0,
                                child: Container(
                                  height: 5,
                                  width: 5,
                                  // padding: EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 8.0,
                                    minHeight: 8.0,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onPressed: () {
                          NotificationService().addtoadminnotification(
                              userid: userSave.uid!,
                              useremail: userSave.email!,
                              subtitle: "SEEN NOTIFICATIONS",
                              userimage: userSave.imageUrls!.isEmpty
                                  ? ""
                                  : userSave.imageUrls![0],
                              title:
                                  "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEEN NOTIFICATIONS");
                          NotificationFunction.setNotification(
                            "admin",
                            "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEEN NOTIFICATIONS",
                            'notificationbell',
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NavHome()));
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ristey/assets/send_message.dart';
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/admin_modal.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:ristey/screens/mobile_chat_screen.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/profile/service/notification_controller.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/services/add_to_profile_service.dart';
import '../../Assets/Error.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../models/shared_pref.dart';

import '../navigation/service/Notification_local_function.dart';
import '../notification/Widget_Notification/ads_bar.dart';

class Pbuttons extends StatefulWidget {
  Pbuttons({
    super.key,
    required this.profileData,
    required this.pushchat,
    this.type = "",
  });
  NewUserModel? profileData;
  String type;

  Function pushchat;

  @override
  State<Pbuttons> createState() => _PbuttonsState();
}

class _PbuttonsState extends State<Pbuttons> {
  var uid;
  SharedPref sharedPref = SharedPref();
  @override
  initState() {
    super.initState();
    connectuser();
    setData();
    getads();
  }

  bool buttonclicked = true;
  bool isaccept = false;
  bool reporting = false;
  bool connectNow = false;
  bool isConnect = false;
  IO.Socket socket = IO.io("$baseurl/buttons", <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
    'force new connection': true,
  });
  IO.Socket socket1 = IO.io("$baseurl/chat", <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
    'force new connection': true,
  });
  void connectuser() {
    socket.connect();

    socket1.connect();
    socket1.emit("signin", userSave.uid);
    socket.emit("usersignin", userSave.uid);
    socket.onConnect((data) {
      print("connected");
      socket.on("connectbutton", (mes) {
        print("##################hi");
        print(mes);
        print(friendr);
        if (mes["type"] == "connectnow") {
          friendr.add(mes["senderId"]);
          setState(() {});
        } else if (mes["type"] == "canclereq") {
          print("hello");
          friendr.remove(mes["senderId"]);
          setState(() {});
        } else if (mes["type"] == "accept") {
          frienda.add(mes["senderId"]);
          setState(() {});
        } else if (mes["type"] == "reject") {
          print("hello");
          print(friendr);
          friendr.remove(mes["senderId"]);
          friends.remove(mes["senderId"]);
          unapprovefriends.remove(mes["senderId"]);
          setState(() {});
        }
        print("##################hi");
      });
    });
  }

  setData() async {
    if (friends.contains(widget.profileData!.id)) {
      isConnect = true;
      setState(() {});
    }

    // final json2 = await sharedPref.read("uid");
    // final json3 = await sharedPref.read("user");
    // if (!mounted) return;
    // setState(() {
    //   uid = json2['uid'];
    //   // print("uid : $uid");
    //   userSave = User.fromJson(json3);
    // });
  }

  SendMessage sendMessage = SendMessage();
  bool connect_nowrunning = false;
  HomeService homeService = Get.put(HomeService());

  void connect_now() async {
    try {
      print("ok hello");
      AddToProfileService().updateinterestsent();
      print(userSave.email);
      NotificationService().addtoactivities(
          email: userSave.email!,
          title:
              "INTEREST SUCCESSFULLY SENT TO ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid}",
          username: widget.profileData!.name,
          userimage: widget.profileData!.imageurls.isEmpty
              ? ""
              : widget.profileData!.imageurls[0],
          userid: widget.profileData!.id);
      if (userSave.status == "approved") {
        socket.emit("connectbutton", {
          "targetId": widget.profileData!.id,
          "type": "connectnow",
          "senderId": userSave.uid
        });

        homeService
            .sendrequest(
                email: userSave.email!,
                sendemail: widget.profileData!.email,
                senduid: widget.profileData!.id,
                profileid: userSave.uid!)
            .whenComplete(() {
          homeService.getuserdata();
          friends.add(widget.profileData!.id);
          setState(() {});
        });

        print(widget.profileData!.id);
        print(userSave.email!);

        NotificationService().addtoactivities(
            email: widget.profileData!.email,
            title:
                "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} SENT YOU INTEREST TO CONNECT",
            username: userSave.name!,
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            userid: userSave.uid!);

        try {
          sendMessage.sendPushMessage(
              "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.substring(0, 1).toUpperCase() + userSave.surname!.substring(1).toUpperCase()} ${userSave.puid} SENT YOU INTEREST TO CONNECT",
              "Receive Interest",
              userSave.email!,
              "profilepage",
              widget.profileData!.token);
        } catch (e) {
          print(e);
        }
      } else {
        friends.add(widget.profileData!.id);
        unapprovefriends.add(widget.profileData!.id);
        homeService.addtounapproveblock(
            email: userSave.email!, profileid: widget.profileData!.id);
        setState(() {});
      }
      //   await sharedPref.save("friendList", fl);
      //   await sharedPref.save("numsentreq", [
      //     numsentreq.toString(),
      //     DateTime.now().toString().substring(0, 10)
      //   ]);
      // } else {
      //   print("data not found");
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: SnackBarContent(
                error_text: "Interest Sent Successfully",
                appreciation: "",
                icon: Icons.check_circle,
                sec: 2,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            );
          });

      // }
      // // print("${userSave!.name}");
      NotificationService().addtoadminnotification(
          userid: userSave.uid!,
          subtitle: "SENT",
          useremail: userSave.email!,
          userimage: userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
          title:
              "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} SENT INTEREST TO ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid}");

      homeService.addtounapproveacitvites(
          email: userSave.email!,
          reciveuserid: widget.profileData!.id,
          useremail: widget.profileData!.email,
          token: widget.profileData!.token,
          title:
              "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} SENT YOU INTEREST TO CONNECT",
          userimage: widget.profileData!.imageurls.isEmpty
              ? ""
              : widget.profileData!.imageurls[0]);
      // NotificationFunction.setNotification(
      //     "admin",
      //     "${userSave!.name!.substring(0, 1).toUpperCase()} ${userSave!.surname!.toUpperCase()} ${userSave!.puid} SENT INTEREST TO ${widget.profileData!.name!.substring(0, 1).toUpperCase()} ${widget.profileData!.surname!.toUpperCase()} ${widget.profileData!.puid}",
      //     'connectnow',
      //     useruid: widget.profileData!.uid!);
    } catch (e) {}
    connect_nowrunning = false;
  }

  //  bool isblocked=false;
  bool blockrunning = false;
  Future<void> block() async {
    if (blockrunning) {
      return;
    } else {
      print(numberofblock);
      if (userblockads.isNotEmpty) {
        if (numberofblock >= 5) {
          showadsbar(context, userblockads, () {
            Navigator.pop(context);
            numberofblock = 0;
          });

          setState(() {});
        }
      } else {
        if (blockads.isNotEmpty) {
          if (numberofblock >= 5) {
            showadsbar(context, blockads, () {
              Navigator.pop(context);
              numberofblock = 0;
            });

            setState(() {});
          }
        }
      }
      numberofblock++;
      setState(() {});
      blockrunning = true;
      DateTime myDateTime = DateTime.now();
      int timestampInMilliseconds = myDateTime.millisecondsSinceEpoch;
      socket1.emit("message", {
        "message": "Block by user",
        "sourceId": userSave.uid,
        "targetId": widget.profileData!.id,
        "type": "source",
        "uid": uid,
        "time": timestampInMilliseconds,
        "status": "unseen",
      });
      blocFriend.add(widget.profileData!.id);
      setState(() {});
      NotificationServiceLocal().showNotification(
          body: "",
          id: 20,
          payLoad: widget.profileData!.id,
          title: "PROFILE BLOCK SUCCESFULLY");
      NotificationService().addtoadminnotification(
          userid: userSave.uid!,
          subtitle: "Blocked",
          useremail: userSave.email!,
          userimage: userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
          title:
              "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} BLOCK TO ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid}");
      NotificationService().addtoactivities(
          email: userSave.email!,
          title:
              "${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid} BLOCKED SUCCESSFULLY",
          username: widget.profileData!.name,
          userimage: widget.profileData!.imageurls.isEmpty
              ? ""
              : widget.profileData!.imageurls[0],
          userid: widget.profileData!.id);

      homeService
          .addtoblock(
              email: userSave.email!,
              profileid: widget.profileData!.id,
              sendemail: widget.profileData!.email)
          .whenComplete(() {
        homeService.getuserdata();
      });
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: SnackBarContent(
              error_text: "Profile Block Successfully",
              appreciation: "",
              icon: Icons.check_circle,
              sec: 2,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          );
        });

    blockrunning = false;
  }

  bool reportrunning = false;

  Future<void> report() async {
    if (reportrunning) {
      return;
    } else {
      if (userreportads.isNotEmpty) {
        if (numberofreport >= 5) {
          showadsbar(context, userreportads, () {
            Navigator.pop(context);
          });
          numberofreport = 0;
          setState(() {});
        }
      } else {
        if (reportads.isNotEmpty) {
          if (numberofreport >= 5) {
            showadsbar(context, reportads, () {
              Navigator.pop(context);
            });
            numberofreport = 0;
            setState(() {});
          }
        }
      }
      reportFriend.add(widget.profileData!.id);
      setState(() {});

      homeService
          .addtoreportlist(
              email: userSave.email!, profileid: widget.profileData!.id)
          .whenComplete(() {
        homeService.getuserdata();
      });
      NotificationService().addtoadminnotification(
          userid: userSave.uid!,
          subtitle: "REPORTED",
          useremail: userSave.email!,
          userimage: userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
          title:
              "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} REPORT TO ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid}");
      NotificationServiceLocal().showNotification(
          body: "",
          id: 3,
          payLoad: widget.profileData!.id,
          title: "PROFILE REPORT SUCCESFULLY");

      NotificationService().addtoactivities(
          email: userSave.email!,
          title:
              "${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid} REPORTED SUCCESSFULLY ",
          username: widget.profileData!.name,
          userimage: widget.profileData!.imageurls.isEmpty
              ? ""
              : widget.profileData!.imageurls[0],
          userid: widget.profileData!.id);
    }
    numberofreport++;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: SnackBarContent(
              error_text: "Profile Report Successfully",
              appreciation: "",
              icon: Icons.check_circle,
              sec: 2,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          );
        });

    reportrunning = false;
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  bool shortlistrunning = false;
  Future<void> shortList() async {
    if (shortlistrunning) {
      return;
    } else {
      if (usersortlistads.isNotEmpty) {
        if (numberofsortlist >= 5) {
          showadsbar(context, usersortlistads, () {
            Navigator.pop(context);
            numberofsortlist = 0;
          });
        }
      } else {
        if (sortlistads.isNotEmpty) {
          if (numberofsortlist >= 5) {
            showadsbar(context, sortlistads, () {
              numberofsortlist = 0;

              Navigator.pop(context);
            });
          }
        }
      }
      numberofsortlist++;
      shortFriend.add(widget.profileData!.id);
      setState(() {});

      homeService
          .addtosortlist(
              email: userSave.email!, profileid: widget.profileData!.id)
          .whenComplete(() {
        homeService.getuserdata();
      });
      NotificationServiceLocal().showNotification(
          body: "",
          id: 21,
          payLoad: widget.profileData!.id,
          title: "PROFILE SHORTLIST SUCCESFULLY");
      NotificationService().addtoactivities(
          email: userSave.email!,
          title:
              "${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid} SHORTLISTED SUCCESSFULLY ",
          username: widget.profileData!.name,
          userimage: widget.profileData!.imageurls.isEmpty
              ? ""
              : widget.profileData!.imageurls[0],
          userid: widget.profileData!.id);
      NotificationService().addtoactivities(
          email: widget.profileData!.email,
          title:
              "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.substring(0, 1).toUpperCase() + userSave.surname!.substring(1).toUpperCase()} ${userSave.puid} SHORTLISTED YOU",
          username: widget.profileData!.name,
          userimage: widget.profileData!.imageurls.isEmpty
              ? ""
              : userSave.imageUrls![0],
          userid: userSave.uid!);
      try {
        sendMessage.sendPushMessage(
            "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.substring(0, 1).toUpperCase() + userSave.surname!.substring(1).toUpperCase()} ${userSave.puid} SHORTLISTED YOU",
            "Receive Interest",
            userSave.uid!,
            "profilepage",
            widget.profileData!.token);
      } catch (e) {
        print(e);
      }
      NotificationService().addtoadminnotification(
          userid: userSave.uid!,
          subtitle: "SHORTLISTED",
          useremail: userSave.email!,
          userimage: userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
          title:
              "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} SHORTLIST TO ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid}");

      setState(() {});
    }
    // try {
    //   shortlistrunning = true;
    //   ShortL friend = ShortL(
    //       date: DateTime.now().toString(),
    //       fromUid: userSave!.uid,
    //       toUid: widget.profileData!.uid);
    //   var dbref1 =
    //       FirebaseDatabase.instance.ref().child('short_list').child(uid);
    //   await dbref1.child(friend.toUid!).set(friend.toJson());

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: SnackBarContent(
              error_text: "Profile Shortlist Successfully",
              appreciation: "",
              icon: Icons.check_circle,
              sec: 2,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          );
        });

    //   NotificationFunction.setNotification(
    //       "admin",
    //       "${userSave!.name!.substring(0, 1).toUpperCase()} ${userSave!.surname!.toUpperCase()} ${userSave!.puid} SHORTLISTED ${widget.profileData!.name!.substring(0, 1).toUpperCase()} ${widget.profileData!.surname!.toUpperCase()} ${widget.profileData!.puid}",
    //       'shortlist',
    //       useruid: widget.profileData!.uid!);
    // NotificationFunction.setNotification(
    //     "user1",
    //     "${widget.profileData!.name!.substring(0, 1).toUpperCase()} ${widget.profileData!.surname!.toUpperCase()} ${widget.profileData!.puid} SHORTLISTED SUCCESSFULLY ",
    //     'shortlist',
    //     useruid: widget.profileData!.uid!);

    // } catch (e) {}
    shortlistrunning = false;
  }

  // List<AdsModel> sentreqads = [];
  // List<AdsModel> blockads = [];
  // List<AdsModel> reportads = [];
  // List<AdsModel> acceptads = [];
  // List<AdsModel> useracceptads = [];
  // List<AdsModel> unblockads = [];
  // List<AdsModel> unreportads = [];
  // List<AdsModel> unsortlistads = [];
  // List<AdsModel> userunblockads = [];
  // List<AdsModel> userunreportads = [];
  // List<AdsModel> userunsortlistads = [];

  // List<AdsModel> rejectads = [];
  // List<AdsModel> sortlistads = [];
  // List<AdsModel> usersentreqads = [];
  // List<AdsModel> userblockads = [];
  // List<AdsModel> userreportads = [];
  // List<AdsModel> usersortlistads = [];
  void getads() async {
    // usersentreqads = adsuser.where((element) => element.adsid == "14").toList();
    // userblockads = adsuser.where((element) => element.adsid == "16").toList();
    // userunblockads = adsuser.where((element) => element.adsid == "17").toList();
    // userreportads = adsuser.where((element) => element.adsid == "18").toList();
    // userunreportads =
    //     adsuser.where((element) => element.adsid == "19").toList();
    // usersortlistads =
    //     adsuser.where((element) => element.adsid == "20").toList();
    // userunsortlistads =
    //     adsuser.where((element) => element.adsid == "21").toList();
    // sentreqads = await AdsService().getallusers(adsid: "14");
    // blockads = await AdsService().getallusers(adsid: "16");
    // reportads = await AdsService().getallusers(adsid: "18");
    // sortlistads = await AdsService().getallusers(adsid: "20");
    // acceptads = await AdsService().getallusers(adsid: "22");
    // rejectads = await AdsService().getallusers(adsid: "23");
    // unblockads = await AdsService().getallusers(adsid: "17");
    // unreportads = await AdsService().getallusers(adsid: "19");
    // unsortlistads = await AdsService().getallusers(adsid: "21");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final NotificationController noticontroller = Get.find();

    return Center(
      child: Container(
        // padding: EdgeInsets.only(left: 28),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: 10,),
          Container(
            // width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: (frienda.contains(widget.profileData!.id) ||
                    isaccept == true)
                ? Container(
                    padding: const EdgeInsets.only(left: 28, right: 28),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          // minimumSize: Size(200, 50),
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.87, 40),
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: mainColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          )),
                      child: Text("Chat Now",
                          style: TextStyle(
                              color: mainColor,
                              fontFamily: 'Serif',
                              fontWeight: FontWeight.w700,
                              fontSize: 18)),
                      onPressed: () async {
                        print("hello");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MobileChatScreen(
                                roomid: widget.profileData!.token,
                                profileDetail: widget.profileData!,
                                profilepic: widget
                                        .profileData!.imageurls.isNotEmpty
                                    ? widget.profileData!.imageurls[0]
                                    : "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/impImage%2Fnoimage.jpg?alt=media&token=4c0d4bc9-761e-48af-b947-4a05a0eaa6d2",
                              ),
                            ));
                        if (buttonclicked) {
                          buttonclicked = false;
                          print("hello");

                          buttonclicked = true;
                        }
                      },
                    ),
                  )
                : (friendr.contains(widget.profileData!.id))
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.08,
                            right: MediaQuery.of(context).size.width * 0.08),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width * 0.4,
                                        40),
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                    shadowColor: Colors.black,
                                    shape: const RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Colors.black12),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    )),
                                onPressed: () async {
                          noticontroller.fetchUnreadCount();

                                  if (buttonclicked) {
                                    buttonclicked = false;
                                    await accept_req();
                                    List<AdminModel> alladmins =
                                        await HomeService().getalladmins();
                                    for (var i = 0; i < alladmins.length; i++) {
                                      sendMessage.sendPushMessage(
                                          "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} ACCEPTED INTEREST OF ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid}",
                                          "Free Rishtey wala",
                                          userSave.uid!,
                                          "Free Rishtey wala",
                                          alladmins[i].token,
                                          sound: "sendinterest");
                                    }
                                    buttonclicked = true;
                                  }

                                  // print("accept clicked");
                                },
                                child: Container(
                                  child: const Text("Accept",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Serif',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18)),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width * 0.4,
                                      40),
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.black,
                                  shape: const RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1, color: Colors.black12),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  )),
                              child: const Text("Reject",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Serif',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18)),
                              onPressed: () async {
                                if (buttonclicked) {
                                  buttonclicked = false;
                                  await reject_req();
                                  buttonclicked = true;
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    : Container(

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.95, 40),
                              elevation: 0,
                              backgroundColor: Colors.white,
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                side:
                                    (friends.contains(widget.profileData!.id) ||
                                            isConnect == true)
                                        ? BorderSide(width: 1, color: mainColor)
                                        : const BorderSide(
                                            width: 1, color: Colors.black12),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                              )),
                          child: (friends.contains(widget.profileData!.id) ||
                                  unapprovefriends
                                      .contains(widget.profileData!.id))
                              ? Text("Cancel Interest",
                                  style: TextStyle(
                                      color: mainColor,
                                      fontFamily: 'Serif',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18))
                              : const Text("Connect Now",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Serif',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18)),
                          onPressed: () async {
                            print(numberofcancelrequest);
                            if (buttonclicked) {
                              buttonclicked = false;

                              if (friends.contains(widget.profileData!.id) ||
                                  unapprovefriends
                                      .contains(widget.profileData!.id)) {
                                isConnect = !isConnect;

                                setState(() {});
                                await cancel_req();
                                if (cancelinterestads.isNotEmpty) {
                                  if (numberofcancelrequest == 5) {
                                    showadsbar(context, sentreqads, () {
                                      Navigator.pop(context);
                                    });
                                    numberofcancelrequest = 0;
                                    setState(() {});
                                  }
                                }
                                numberofcancelrequest++;
                                setState(() {});
                              } else {
                                if (blocFriend
                                    .contains(widget.profileData!.id)) {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: SnackBarContent(
                                            error_text:
                                                "Please Unblock User First \nto \n Send Interest",
                                            appreciation: "",
                                            icon: Icons.error,
                                            sec: 2,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                        );
                                      });
                                } else if (reportFriend
                                    .contains(widget.profileData!.id)) {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: SnackBarContent(
                                            error_text:
                                                "Please Unreport User First \nto \n Send Interest",
                                            appreciation: "",
                                            icon: Icons.error,
                                            sec: 2,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                        );
                                      });
                                } else {
                                  if (numsentreq <= 20) {
                                    print("ok");
                                    isConnect = !isConnect;

                                    //
                                    setState(() {});
                                    connect_now();
                                    numsentreq += 1;
                                    setState(() {});

                                    if (usersentreqads.isNotEmpty) {
                                      if (numsentreq == 5) {
                                        showadsbar(context, usersentreqads, () {
                                          Navigator.pop(context);
                                        });
                                        numsentreq = 0;
                                        setState(() {});
                                      }
                                    } else {
                                      if (sentreqads.isNotEmpty) {
                                        if (numsentreq == 5) {
                                          showadsbar(context, sentreqads, () {
                                            Navigator.pop(context);
                                          });
                                          numsentreq = 0;
                                          setState(() {});
                                        }
                                      }
                                    }
                                    //                              sendrequest(email:userSave!.email!,
                                    //  sendemail: widget.profileData!.email, senduid: widget.profileData!.id,
                                    //   profileid: userSave!.uid!);
                                  } else {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            content: SnackBarContent(
                                              error_text:
                                                  "You have Reached\nto the\nMaximum Limit of Sending \nInterest of the Day",
                                              appreciation: "",
                                              icon: Icons.error,
                                              sec: 2,
                                            ),
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                          );
                                        });
                                  }
                                }
                              }
                              buttonclicked = true;
                            }
                          },
                        ),
                      ),
          ),
        
          Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                              MediaQuery.of(context).size.width*0.28, 40),
                          // minimumSize: Size(150, 50),
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            side: (blocFriend.contains(widget.profileData!.id))
                                ? BorderSide(width: 1, color: Colors.red)
                                : const BorderSide(
                                    width: 1, color: Colors.black12),
                            // side: BorderSide(width: 1, color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          )),
                      onPressed: () async {
                          noticontroller.fetchUnreadCount();

                        if (buttonclicked) {
                          // print(isblocked);
                          // buttonclicked = false;
                          // setState(() {
                          //   isblocked=!isblocked;
                          // });
                          if (blocFriend.contains(widget.profileData!.id)) {
                            //  print("ok");
                            //  setState(() {
                            //   isblocked=!isblocked;
                            // });
                            if (reportFriend.contains(widget.profileData!.id)) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      content: SnackBarContent(
                                        error_text:
                                            "Please Unreport User First \nto \n Unblock",
                                        appreciation: "",
                                        icon: Icons.error,
                                        sec: 2,
                                      ),
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    );
                                  });
                            } else {
                              await unblock();
                            }
                          } else {
                            if (!(frienda.contains(widget.profileData!.id)) &&
                                (friendr.contains(widget.profileData!.id))) {
                              setState(() {});

                              await block();
                              await reject_req(notidata: false);
                            } else {
                              await block();
                            }
                          }

                          buttonclicked = true;
                        }
                      },
                      child: (blocFriend.contains(widget.profileData!.id))
                          ? Text("Block",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontFamily: 'Serif',
                                fontWeight: FontWeight.w700,
                              ))
                          : const Text("Block",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Serif',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18)),
                    ),
                  ),
                  // SizedBox(
                  //   width: 4,
                  // ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                              MediaQuery.of(context).size.width*0.28, 40),
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            side:
                                (reportFriend.contains(widget.profileData!.id))
                                    ? BorderSide(width: 1, color: Colors.red)
                                    : const BorderSide(
                                        width: 1, color: Colors.black12),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          )),
                      onPressed: () async {
                          noticontroller.fetchUnreadCount();

                        if (buttonclicked) {
                          buttonclicked = false;
                          if (reportFriend.contains(widget.profileData!.id)) {
                            await unreport();
                          } else {
                            if (blocFriend.contains(widget.profileData!.id)) {
                              await report();
                            } else {
                              NotificationService().addtoadminnotification(
                                  userid: userSave.uid!,
                                  subtitle: "REPORTED",
                                  useremail: userSave.email!,
                                  userimage: userSave.imageUrls!.isEmpty
                                      ? ""
                                      : userSave.imageUrls![0],
                                  title:
                                      "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} TRY TO UNBLOCK ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid} (ERROR)");
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      content: SnackBarContent(
                                        error_text:
                                            "Profile Block First To Report",
                                        appreciation: "",
                                        icon: Icons.error,
                                        sec: 2,
                                      ),
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    );
                                  });
                            }
                          }
                          buttonclicked = true;
                        }
                      },
                      child: (reportFriend.contains(widget.profileData!.id))
                          ? Text("Report",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Serif',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18))
                          : const Text("Report",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Serif',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18)),
                    ),
                  ),
                  // SizedBox(
                  //   width: 4,
                  // ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width*0.28, 40),
                            elevation: 0,
                            backgroundColor: Colors.white,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              side:
                                  (shortFriend.contains(widget.profileData!.id))
                                      ? BorderSide(width: 1, color: mainColor)
                                      : const BorderSide(
                                          width: 1, color: Colors.black12),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                            )),
                        child: (shortFriend.contains(widget.profileData!.id))
                            ? Text("Shortlist",
                                style: TextStyle(
                                    color: mainColor,
                                    fontFamily: 'Serif',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18))
                            : const Text("Shortlist",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Serif',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18)),
                        onPressed: () async {
                          noticontroller.fetchUnreadCount();

                          if (buttonclicked) {
                            buttonclicked = false;

                            if (shortFriend.contains(widget.profileData!.id)) {
                              await unshortList();
                              setState(() {});
                            } else {
                              await shortList();
                            }
                            buttonclicked = true;
                          }
                        }),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                ],
              )),
        ]),
      ),
    );
  }

  // functions to remove from list
  bool cancel_reqrunning = false;
  Future<void> cancel_req() async {
    if (cancel_reqrunning) {
      return;
    } else {
      try {
        if (userSave.status == "" || userSave.status == "blocked") {
          homeService.addtounapproveacitvites(
              email: userSave.email!,
              reciveuserid: widget.profileData!.id,
              token: widget.profileData!.token,
              useremail: widget.profileData!.email,
              title:
                  "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} CANCEL INTEREST TO CONNECT",
              userimage: widget.profileData!.imageurls.isEmpty
                  ? ""
                  : widget.profileData!.imageurls[0]);
        }
        print(friends);
        cancel_reqrunning = true;
        friends.remove(widget.profileData!.id);

        unapprovefriends.remove(widget.profileData!.id);
        setState(() {});
        homeService.removeunapproveblock(
            email: userSave.email!, profileid: widget.profileData!.id);

        NotificationService().addtoactivities(
            email: userSave.email!,
            title:
                "INTEREST CANCEL SUCCESSFULLY WITH ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid}",
            username: widget.profileData!.name,
            userimage: widget.profileData!.imageurls.isEmpty
                ? ""
                : widget.profileData!.imageurls[0],
            userid: widget.profileData!.id);
        if (userSave.status == "approved") {
          socket.emit("connectbutton", {
            "targetId": widget.profileData!.id,
            "type": "canclereq",
            "senderId": userSave.uid
          });
          homeService
              .canclereq(
                  email: userSave.email!,
                  sendemail: widget.profileData!.email,
                  senduid: widget.profileData!.id,
                  profileid: userSave.uid!)
              .whenComplete(() {
            homeService.getuserdata();
          });

          NotificationService().addtoactivities(
              email: widget.profileData!.email,
              title:
                  "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} CANCEL INTEREST TO CONNECT",
              username: userSave.name!,
              userimage:
                  userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
              userid: userSave.uid!);

          NotificationService().addtoadminnotification(
              userid: userSave.uid!,
              subtitle: "CANCEL INTEREST",
              useremail: userSave.email!,
              userimage:
                  userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
              title:
                  "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} CANCEL INTEREST WITH ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid}");
          try {
            sendMessage.sendPushMessage(
                "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.substring(0, 1).toUpperCase() + userSave.surname!.substring(1).toUpperCase()} ${userSave.puid} CANCEL INTEREST TO CONNECT",
                "Cancel Interest",
                userSave.uid!,
                "profilepage",
                widget.profileData!.token);
          } catch (e) {}
        }

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Interest Cancel Successfully",
                  appreciation: "",
                  icon: Icons.check_circle,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
        // );
        // await sharedPref.save("friendList", fl);
        // if (!mounted) return;
        // setState(() {
        //   friends.remove("${friend.toUid}");
        //   connectNow = (!connectNow) ? true : false;
        // });

        // NotificationFunction.setNotification(
        //     "admin",
        //     "${userSave!.name!.substring(0, 1).toUpperCase()} ${userSave!.surname!.toUpperCase()} ${userSave!.puid} CANCEL INTEREST WITH ${widget.profileData!.name!.substring(0, 1).toUpperCase()} ${widget.profileData!.surname!.toUpperCase()} ${widget.profileData!.puid}",
        //     'cancelinterest',
        //     useruid: widget.profileData!.id!);
      } catch (e) {}
      cancel_reqrunning = false;
    }
  }

  bool accept_reqrunning = false;
  Future<void> accept_req() async {
    if (accept_reqrunning) {
      return;
    } else {
      try {
        accept_reqrunning = true;
        isaccept = true;
        friendr.remove(widget.profileData!.id);
        setState(() {});
        unapprovefriends.remove(widget.profileData!.id);
        homeService.removeunapproveblock(
            email: userSave.email!, profileid: widget.profileData!.id);
        homeService
            .acceptrequest(
                email: userSave.email!,
                sendemail: widget.profileData!.email,
                senduid: widget.profileData!.id,
                profileid: userSave.uid!)
            .whenComplete(() {});
        socket.emit("connectbutton", {
          "targetId": widget.profileData!.id,
          "type": "accept",
          "senderId": userSave.uid
        });
        // var dbref1 =
        //     FirebaseDatabase.instance.ref().child('friend_list').child(uid);
        // var dbref2 = FirebaseDatabase.instance
        //     .ref()
        //     .child('friend_list')
        //     .child(widget.profileData!.id!);
        // await dbref1
        //     .child("received")
        //     .child(widget.profileData!.id!)
        //     .update({"status": "accepted"});
        // await dbref2.child("sent").child(uid).update({"status": "accepted"});
        // FirebaseFirestore.instance
        //     .collection("friend_list")
        //     .doc("$uid")
        //     .update(json)
        //     .then((value) =>
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Interest Accept Successfully",
                  appreciation: "",
                  icon: Icons.check_circle,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            }).whenComplete(() {
          if (useracceptads.isNotEmpty) {
            showadsbar(context, useracceptads, () async {
              Navigator.pop(context);
            });
          } else {
            if (acceptads.isNotEmpty) {
              showadsbar(context, acceptads, () async {
                Navigator.pop(context);
              });
            }
          }
        });

        // );
        NotificationService().addtoadminnotification(
            userid: userSave.uid!,
            useremail: userSave.email!,
            subtitle: "ACCEPTED INTEREST",
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            title:
                "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} ACCEPTED  ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid} INTEREST");

        NotificationService().addtoactivities(
            email: userSave.email!,
            title:
                "ACCEPTED INTEREST OF ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid} SUCCESSFULLY",
            username: widget.profileData!.name,
            userimage: widget.profileData!.imageurls.isEmpty
                ? ""
                : widget.profileData!.imageurls[0],
            userid: widget.profileData!.id);
        NotificationService().addtoactivities(
            email: widget.profileData!.email,
            title:
                "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} ACCEPTED YOUR INTEREST",
            username: userSave.name!,
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            userid: userSave.uid!);
        try {
          sendMessage.sendPushMessage(
              "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.substring(0, 1).toUpperCase() + userSave.surname!.substring(1).toUpperCase()} ${userSave.puid} ACCEPTED YOUR INTEREST SUCCESSFULLY",
              "Accept Interest",
              userSave.uid!,
              "profilepage",
              widget.profileData!.token);
        } catch (e) {}
      } catch (e) {}
      accept_reqrunning = false;
    }
  }

  bool reject_reqrunning = false;
  Future<void> reject_req({bool notidata = true}) async {
    if (reject_reqrunning) {
      return;
    } else {
      try {
        reject_reqrunning = true;
        friendr.remove(widget.profileData!.id);
        setState(() {});
        unapprovefriends.remove(widget.profileData!.id);
        homeService.removeunapproveblock(
            email: userSave.email!, profileid: widget.profileData!.id);
        homeService.rejectreq(
            email: userSave.email!,
            sendemail: widget.profileData!.email,
            senduid: widget.profileData!.id,
            profileid: userSave.uid!); // var dbref1 =
        //     FirebaseDatabase.instance.ref().child('friend_list').child(uid);
        // var dbref2 = FirebaseDatabase.instance
        //     .ref()
        //     .child('friend_list')
        //     .child(widget.profileData!.id!);
        // await dbref1.child("received").child(widget.profileData!.id!).remove();
        // await dbref2.child("sent").child(uid).remove();
        socket.emit("connectbutton", {
          "targetId": widget.profileData!.id,
          "type": "reject",
          "senderId": userSave.uid
        });
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Interest Decline Successfully",
                  appreciation: "",
                  icon: Icons.check_circle,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            }).whenComplete(() {
          if (rejectads.isNotEmpty) {
            showadsbar(context, rejectads, () async {
              Navigator.pop(context);
              if (buttonclicked) {
                buttonclicked = false;
                await reject_req();
                buttonclicked = true;
              }
            });
          }
        });

        NotificationService().addtoadminnotification(
            userid: userSave.uid!,
            useremail: userSave.email!,
            subtitle: "DECLINED INTEREST",
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            title:
                "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} DECLINED ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid} INTEREST");
        // if (notidata) {
        //   NotificationFunction.setNotification(
        //       "admin",
        //       "${userSave!.name!.substring(0, 1).toUpperCase()} ${userSave!.surname!.toUpperCase()} ${userSave!.puid} DECLINED INTEREST OF ${widget.profileData!.name!.substring(0, 1).toUpperCase()} ${widget.profileData!.surname!.toUpperCase()} ${widget.profileData!.puid}",
        //       'declinerequest',
        //       useruid: widget.profileData!.id!);
        //   NotificationFunction.setNotification(
        //       "user2",
        //       "${userSave!.name!.substring(0, 1).toUpperCase()} ${userSave!.surname!.toUpperCase()} ${userSave!.puid} DECLINED YOUR INTEREST",
        //       'declinerequest',
        //       useruid: widget.profileData!.id!);
        //   NotificationFunction.setNotification(
        //       "user1",
        //       "DECLINED INTEREST OF ${widget.profileData!.name!.substring(0, 1).toUpperCase()} ${widget.profileData!.surname!.toUpperCase()} ${widget.profileData!.puid} SUCCESSFULLY",
        //       'declinerequest',
        //       useruid: widget.profileData!.id!);
        NotificationService().addtoactivities(
            email: userSave.email!,
            title:
                "DECLINED INTEREST OF ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid} SUCCESSFULLY",
            username: widget.profileData!.name,
            userimage: widget.profileData!.imageurls.isEmpty
                ? ""
                : widget.profileData!.imageurls[0],
            userid: widget.profileData!.id);
        NotificationService().addtoactivities(
            email: widget.profileData!.email,
            title:
                "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} DECLINED YOUR INTEREST",
            username: userSave.name!,
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            userid: userSave.uid!);
        try {
          sendMessage.sendPushMessage(
              "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.substring(0, 1).toUpperCase() + userSave.surname!.substring(1).toUpperCase()} ${userSave.puid} DECLINED YOUR INTEREST",
              "Declined Interest",
              userSave.uid!,
              "profilepage",
              widget.profileData!.token);
        } catch (e) {}
        // }
      } catch (e) {}
      reject_reqrunning = false;
    }
  }

  bool unblockrunning = false;

  Future<void> unblock() async {
    if (unblockrunning) {
      return;
    } else {
      try {
        print(numberofunblock);
        if (numberofunblock >= 5 && userunblockads.isNotEmpty) {
          showadsbar(context, userunblockads, () {
            Navigator.pop(context);
            numberofunblock = 0;
          });
        } else {
          if (numberofunblock >= 5 && unblockads.isNotEmpty) {
            showadsbar(context, unblockads, () {
              Navigator.pop(context);
              numberofunblock = 0;
            });
          }
        }
        numberofunblock++;
        setState(() {});
        unblockrunning = true;

        blocFriend.remove(widget.profileData!.id);
        setState(() {});
        NotificationServiceLocal().showNotification(
          body: "",
          id: 2,
          payLoad: widget.profileData!.id,
          title: "PROFILE UNBLOCK SUCCESFULLY",
        );
        NotificationService().addtoadminnotification(
            userid: userSave.uid!,
            subtitle: "UNBLOCKED",
            useremail: userSave.email!,
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            title:
                "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.uid?.substring(userSave.uid!.length - 5)} UNBLOCK TO ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid}");
        NotificationService().addtoactivities(
            email: userSave.email!,
            title:
                "${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid} UNBLOCKED SUCCESSFULLY ",
            username: widget.profileData!.name,
            userimage: widget.profileData!.imageurls.isEmpty
                ? ""
                : widget.profileData!.imageurls[0],
            userid: widget.profileData!.id);
        DateTime myDateTime = DateTime.now();
        int timestampInMilliseconds = myDateTime.millisecondsSinceEpoch;
        socket1.emit("message", {
          "message": "Unblock by user",
          "sourceId": userSave.uid,
          "targetId": widget.profileData!.id,
          "type": "source",
          "uid": uid,
          "time": timestampInMilliseconds,
          "status": "unseen",
        });
        homeService
            .unblock(
                email: userSave.email!,
                profileid: widget.profileData!.id,
                sendemail: widget.profileData!.email)
            .whenComplete(() {
          homeService.getuserdata();
        });

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Profile Unblock Successfully",
                  appreciation: "",
                  icon: Icons.check_circle,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      } catch (e) {}
      unblockrunning = false;
    }
  }

  bool unreportrunning = false;

  Future<void> unreport() async {
    if (unreportrunning) {
      return;
    } else {
      try {
        if (userunreportads.isNotEmpty && numberofunreport >= 5) {
          showadsbar(context, userunreportads, () {
            Navigator.pop(context);
            numberofunreport = 0;
          });
        } else {
          if (unreportads.isNotEmpty && numberofunreport >= 5) {
            showadsbar(context, unreportads, () {
              Navigator.pop(context);
              numberofunreport = 0;
            });
          }
        }
        numberofunreport++;
        setState(() {});
        unreportrunning = true;
        reportFriend.remove(widget.profileData!.id);
        setState(() {});
        homeService
            .removefromreportlist(
                email: userSave.email!, profileid: widget.profileData!.id)
            .whenComplete(() {
          homeService.getuserdata();
        });

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Profile Unreport Successfully",
                  appreciation: "",
                  icon: Icons.check_circle,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });

        NotificationService().addtoactivities(
            email: userSave.email!,
            title:
                "${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid} UNREPORTED SUCCESSFULLY ",
            username: widget.profileData!.name,
            userimage: widget.profileData!.imageurls.isEmpty
                ? ""
                : widget.profileData!.imageurls[0],
            userid: widget.profileData!.id);
        NotificationServiceLocal().showNotification(
            body: "",
            id: 2,
            payLoad: widget.profileData!.id,
            title: "PROFILE UNREPORT SUCCESFULLY");
        NotificationService().addtoadminnotification(
            userid: userSave.uid!,
            useremail: userSave.email!,
            subtitle: "UNREPORTED",
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            title:
                "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} UNREPORT TO ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid}");
        numberofreport++;
      } catch (e) {}
      unreportrunning = false;
    }
  }

  bool unshortlistrunning = false;
  Future<void> unshortList() async {
    if (unshortlistrunning) {
      return;
    } else {
      try {
        if (userunsortlistads.isNotEmpty && numberofunsortlist >= 5) {
          showadsbar(context, usersortlistads, () {
            numberofunsortlist = 0;

            Navigator.pop(context);
          });
        } else {
          if (unsortlistads.isNotEmpty && numberofunsortlist >= 5) {
            showadsbar(context, unsortlistads, () {
              Navigator.pop(context);
              numberofunsortlist = 0;
            });
          }
        }
        numberofunsortlist++;
        unshortlistrunning = true;
        // var dbref1 =
        //     FirebaseDatabase.instance.ref().child('short_list').child(uid);
        // await dbref1.child(widget.profileData!.id!).remove();
        shortFriend.remove(widget.profileData!.id);
        homeService
            .unshortlistuser(
                email: userSave.email!, profileid: widget.profileData!.id)
            .whenComplete(() {
          homeService.getuserdata();
        });
        NotificationServiceLocal().showNotification(
            body: "",
            id: 22,
            payLoad: widget.profileData!.id,
            title: "PROFILE UNSHORTLIST SUCCESFULLY");
        NotificationService().addtoactivities(
            email: userSave.email!,
            title:
                "${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid} UNSHORTLISTED SUCCESSFULLY ",
            username: widget.profileData!.name,
            userimage: widget.profileData!.imageurls.isEmpty
                ? ""
                : widget.profileData!.imageurls[0],
            userid: widget.profileData!.id);
        NotificationService().addtoadminnotification(
            userid: userSave.uid!,
            useremail: userSave.email!,
            subtitle: "UNSHORTLISTED",
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            title:
                "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} UNSHORTLIST TO ${widget.profileData!.name.substring(0, 1).toUpperCase()} ${widget.profileData!.surname.toUpperCase()} ${widget.profileData!.puid}");
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Profile Unshortlist Successfully",
                  appreciation: "",
                  icon: Icons.check_circle,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });

        // NotificationFunction.setNotification(
        //     "admin",
        //     "${userSave!.name!.substring(0, 1).toUpperCase()} ${userSave!.surname!.toUpperCase()} ${userSave!.puid} UNSHORTLISTED ${widget.profileData!.name!.substring(0, 1).toUpperCase()} ${widget.profileData!.surname!.toUpperCase()} ${widget.profileData!.puid}",
        //     'unshortlist',
        //     useruid: widget.profileData!.id!);
        // NotificationFunction.setNotification(
        //     "user1",
        //     "${widget.profileData!.name!.substring(0, 1).toUpperCase()} ${widget.profileData!.surname!.toUpperCase()} ${widget.profileData!.puid} UNSHORTLISTED SUCCESSFULLY ",
        //     'unshortlist',
        //     useruid: widget.profileData!.id!);
      } catch (e) {}
      unshortlistrunning = false;
    }
  }
}

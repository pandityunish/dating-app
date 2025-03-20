import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:ristey/assets/info.dart';
import 'package:ristey/assets/notification_pop_up.dart';
import 'package:ristey/assets/send_message.dart';
import 'package:ristey/chat/main.dart';
import 'package:ristey/chat/widget/my_message_card.dart';
import 'package:ristey/chat/widget/send_button.dart';
import 'package:ristey/chat/widget/sender_message_card.dart';
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/common/global.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/message_modal.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/screens/search_profile/video_call.dart';
import 'package:ristey/services/call_controller.dart';
import 'package:ristey/services/chat_services.dart';

import '../../Assets/Error.dart';

import '../../screens/profile/service/notification_service.dart';

// import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'search_profile/audio_call.dart';

// import 'package:audiofileplayer/audiofileplayer.dart';
// import 'package:audiofileplayer/audio_system.dart';

// ignore: must_be_immutable
class MobileChatScreen extends StatefulWidget {
  MobileChatScreen(
      {Key? key,
      required this.roomid,
      required this.profileDetail,
      required this.profilepic})
      : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var roomid;
  // ignore: prefer_typing_uninitialized_variables
  NewUserModel profileDetail;
  // ignore: prefer_typing_uninitialized_variables
  var profilepic;
  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  final profanityFilter = ProfanityFilter();
  String censorMessage(String message) {
    final censoredWords = profanityFilter.censor(message);
    return censoredWords;
  }

  final ScrollController _scrollController = ScrollController();
  SendMessage sendPushMessage = SendMessage();
  TextEditingController msg = TextEditingController(text: "Initial value");
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  // late DatabaseReference _dbref;
  late DatabaseReference _dbref2;
  late DatabaseReference _dbref5;
  var temp1 =
      DateTime.fromMillisecondsSinceEpoch(1000).toString().substring(0, 10);
  var event1;
  var event2;
  List<Map<dynamic, dynamic>> messages = [];
  MessageText temp = MessageText();
  bool isUploading = false;
  var percentUpload = 0.0;
  bool isBlocked = false;
  bool callstatus = false;
  var connectivity = '';
  var token = '';
  HomeService homeService = HomeService();
  NotificationData notificationData = NotificationData();
  List<AdsModel> audiocall = [];
  List<AdsModel> videocall = [];
  List<AdsModel> profileclickads = [];
  List<AdsModel> chatads = [];
  List<AdsModel> blockads = [];
  List<AdsModel> unblockads = [];
  List<AdsModel> conferenceads = [];
  List<AdsModel> reportads = [];
  void getads() async {
    audiocall = await AdsService().getallusers(adsid: "50");
    videocall = await AdsService().getallusers(adsid: "51");
    profileclickads = await AdsService().getallusers(adsid: "52");
    reportads = await AdsService().getallusers(adsid: "57");
    chatads = await AdsService().getallusers(adsid: "53");
    conferenceads = await AdsService().getallusers(adsid: "54");
    blockads = await AdsService().getallusers(adsid: "55");
    unblockads = await AdsService().getallusers(adsid: "56");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getads();
    ChatService().updateunseenmessage(email: userSave.email!);
    NotificationData.uid = widget.profileDetail.id;
    msg.text = "";

    _dbref2 = FirebaseDatabase.instance.ref();
    _dbref5 = FirebaseDatabase.instance.ref();
    // _dbref = FirebaseDatabase.instance.ref().child("firstchat");
    // setdata();
    setconnection();
    isblockedcheck();
    getallmessages();
    connect();
    NotificationData.isChatting = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
    // var dbref4 = FirebaseDatabase.instance.ref().child('chatroomids');
    // dbref4 = dbref4.child(userSave.uid!).child(widget.roomid);
    // dbref4.update({'numunread': 0});
    checkcallstatus();
  }

  @override
  void dispose() {
    NotificationData.isChatting =
        false; // Reset the chatting flag when the screen is disposed.
    NotificationData.uid = "";
    super.dispose();

    // event1.cancel();
    _scrollController.dispose();
    // event2.cancel();
  }

  updateIsUploading(bool val) {
    setState(() {
      isUploading = val;
    });
  }

  updatePercentUpload(var val) {
    setState(() {
      percentUpload = val;
    });
  }

  checkcallstatus() async {
    var doc = FirebaseDatabase.instance.ref().child("need_call");
    doc = doc.child(userSave.uid!);
    doc = doc.child(widget.profileDetail.id);
    var doc2 = await doc.get();
    if (doc2.value == null) {
    } else {
      var doc3 = doc2.value as Map<dynamic, dynamic>;
      print("doc3 : $doc3");
      if (doc3.isNotEmpty) {
        setState(() {
          callstatus = true;
        });
      }
    }
  }

  setconnection() {
    _dbref2 = _dbref2.child("onlineStatus");
    _dbref5 = _dbref5.child("token");
    event2 = _dbref2.child(widget.profileDetail.id).onValue.listen((event) {
      // var values = event.snapshot.value as Map<dynamic, dynamic>;
      try {
        var res = event.snapshot.child('status').value;

        setState(() {
          print(res);
          connectivity = res.toString();
        });
      } catch (e) {
        print(e);
      }
    });

    _dbref5.child(widget.profileDetail.id).onValue.listen((event) {
      try {
        var res = event.snapshot.child('token').value;
        setState(() {
          token = res.toString();
        });
      } catch (e) {
        print(e);
      }
    });
  }

  setdata() async {
    print(true);
  }

  Future<bool> docexist(DatabaseReference databaseReference) async {
    DatabaseEvent dataSnapshot = await databaseReference.once();
    print(dataSnapshot.snapshot.value);
    return dataSnapshot.snapshot.value != null;
  }

  Future<void> report() async {
    reportFriend.add(widget.profileDetail.id);
    setState(() {});
    homeService
        .addtoreportlist(
            email: userSave.email!, profileid: widget.profileDetail.id)
        .whenComplete(() {
      homeService.getuserdata();
    });

    NotificationService().addtoactivities(
        email: userSave.email!,
        title:
            "${widget.profileDetail.name.substring(0, 1).toUpperCase()} ${widget.profileDetail.surname.toUpperCase()} ${widget.profileDetail.puid} REPORTED SUCCESSFULLY ",
        username: widget.profileDetail.name,
        userimage: widget.profileDetail.imageurls[0],
        userid: widget.profileDetail.id);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: SnackBarContent(
              error_text: "Profile Report Successfully",
              appreciation: "",
              icon: Icons.check,
              sec: 2,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          );
        }).whenComplete(() {
      if (reportads.isNotEmpty) {
        showadsbar(context, reportads, () {
          Navigator.pop(context);
        });
      }
    });
  }

  Future<void> unreport() async {
    try {
      reportFriend.remove(widget.profileDetail.id);
      setState(() {});
      homeService
          .removefromreportlist(
              email: userSave.email!, profileid: widget.profileDetail.id)
          .whenComplete(() {
        homeService.getuserdata();
      });

      Future(() => customAlertBox1(
          context, Icons.check, "Profile Unreported Successfully", "", () {}));
      NotificationService().addtoactivities(
          email: userSave.email!,
          title:
              "${widget.profileDetail.name.substring(0, 1).toUpperCase()} ${widget.profileDetail.surname.toUpperCase()} ${widget.profileDetail.puid} UNREPORTED SUCCESSFULLY ",
          username: widget.profileDetail.name,
          userimage: widget.profileDetail.imageurls.isEmpty
              ? ""
              : widget.profileDetail.imageurls[0],
          userid: widget.profileDetail.id);
    } catch (e) {
      print("This is unreport error $e");
    }
  }

  var res;
  isblockedcheck() {
    if (widget.profileDetail.blocklists.contains(userSave.uid)) {
      res = userSave.uid;
      setState(() {});
    }
    var databaseRef = FirebaseDatabase.instance.ref();
    databaseRef = databaseRef
        .child('chatroomids')
        .child(widget.profileDetail.id)
        .child(widget.roomid);
    databaseRef.onValue.listen((event) {
      try {
        res = event.snapshot.child('blockedby').value;

        print("blocked by : $res");

        if (res != null && res != "") {
          setState(() {
            isBlocked = true;
          });
        } else {
          setState(() {
            isBlocked = false;
          });
        }
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> block() async {
    blocFriend.add(widget.profileDetail.id);
    setState(() {});
    homeService
        .addtoblock(
            email: userSave.email!,
            profileid: widget.profileDetail.id,
            sendemail: widget.profileDetail.email)
        .whenComplete(() {
      homeService.getuserdata();
    });

    Future(() => customAlertBox1(
        context, Icons.check, "Profile Blocked Successfully", "", () {}));

    NotificationService().addtoactivities(
        email: userSave.email!,
        title:
            "${widget.profileDetail.name.substring(0, 1).toUpperCase()} ${widget.profileDetail.surname.toUpperCase()} ${widget.profileDetail.puid} BLOCKED SUCCESSFULLY",
        username: widget.profileDetail.name,
        userimage: widget.profileDetail.imageurls.isEmpty
            ? ""
            : widget.profileDetail.imageurls[0],
        userid: widget.profileDetail.id);
  }

  Future<void> unblock() async {
    blocFriend.remove(widget.profileDetail.id);
    setState(() {});
    homeService
        .unblock(
            email: userSave.email!,
            profileid: widget.profileDetail.id,
            sendemail: widget.profileDetail.email)
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
              icon: Icons.check,
              sec: 2,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          );
        });
    // );
    NotificationService().addtoactivities(
        email: userSave.email!,
        title:
            "${widget.profileDetail.name.substring(0, 1).toUpperCase()} ${widget.profileDetail.surname.toUpperCase()} ${widget.profileDetail.puid} UNBLOCKED SUCCESSFULLY",
        username: widget.profileDetail.name,
        userimage: widget.profileDetail.imageurls.isEmpty
            ? ""
            : widget.profileDetail.imageurls[0],
        userid: widget.profileDetail.id);
  }

  List<MessageModelChats> chats = [];
  void getallmessages() async {
    try {
      if (userSave.email == widget.profileDetail.email) {
        print(widget.profileDetail.id);
        chats = await ChatService()
            .getallmessage(to: widget.profileDetail.id, from: "12345");
      }
      chats = await ChatService()
          .getallmessage(to: widget.profileDetail.id, from: userSave.uid!);
      setState(() {});
      print("I run now add message");
      for (var i = 0; i < chats.length; i++) {
        messages.add({
          "text": chats[i].text,
          "type": "source",
          "uid": chats[i].uid,
          "time": chats[i].time,
          "status": chats[i].status,
        });
      }
      setState(() {});
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _onBackPress() {
    // HomeService().getuserdata();
  }
  IO.Socket socket = IO.io("$baseurl/chat", <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
    'force new connection': true,
  });
  void connect() {
    // MessageModel messageModel = MessageModel(sourceId: widget.sourceChat.id.toString(),targetId: );
    socket.connect();
    print("${socket.connected} ");
    // socket.emit("signin", widget.profileDetail.id);
    socket.emit("signin", userSave.uid);
    socket.onConnect((data) {
      socket.on("message", (mes) {
        //     DateTime myDateTime = DateTime.now();

        // // Convert the DateTime object to a Unix timestamp in milliseconds.
        // int timestampInMilliseconds = myDateTime.millisecondsSinceEpoch;

        ChatService().updateusernumberofunseenmes(
            from: userSave.uid!, to: widget.profileDetail.id);
        for (int i = 0; i < messages.length; i++) {
          messages[i]["status"] = "seen";
        }
        setState(() {});

        DateTime myDateTime = DateTime.now();

        int timestampInMilliseconds = myDateTime.millisecondsSinceEpoch;

        if (mounted) {
          setState(() {
            messages.add({
              "text": mes["message"],
              "type": 'destination',
              "uid": widget.profileDetail.id,
              "time": timestampInMilliseconds,
              "status": "seen",
            });
          });
        }
        if (mes["message"] == "Block by user") {
          widget.profileDetail.blocklists.add(userSave.uid);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: SnackBarContent(
                    error_text: "You are blocked",
                    appreciation: "",
                    icon: Icons.check,
                    sec: 2,
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                );
              });
        }
        if (mes["message"] == "Unblock by user") {
          widget.profileDetail.blocklists.remove(userSave.uid);
        }
        setState(() {});
        if (mes != null) {
          ChatService().updateusernumberofunseenmes(
              from: userSave.uid!, to: widget.profileDetail.id);
          ChatService().updateusernumberofunseenmes(
              from: widget.profileDetail.id, to: userSave.uid!);
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      });
    });
  }

  void sendMessage(String message, String sourceId, String targetId) async {
    DateTime myDateTime = DateTime.now();
    int timestampInMilliseconds = myDateTime.millisecondsSinceEpoch;
    if (messages.isEmpty) {
      ChatService().setusermessage(
        username: widget.profileDetail.surname,
        userimage: widget.profilepic,
        userid: widget.profileDetail.id,
        lasttime: timestampInMilliseconds,
        sendemail: widget.profileDetail.email,
        lastmessage: message,
      );
    } else {
      ChatService()
          .updatelastmessage(
              lasttime: timestampInMilliseconds,
              senderemail: widget.profileDetail.email,
              lastmessage: message,
              email: userSave.email!)
          .onError((error, stackTrace) => printError());
    }

    setMessage("source", message, userSave.uid!);
    socket.emit("message", {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId,
      "type": "source",
      "uid": userSave.uid,
      "time": timestampInMilliseconds,
      "status": "unseen",
    });
    if (message != "") {
      var filteredMessage = censorMessage(message);
      // print(filteredMessage);
      // print("hamro lawuda");

      ChatService().sendmessages(
          text: message,
          to: widget.profileDetail.id,
          token: token,
          from: userSave.uid!,
          time: timestampInMilliseconds,
          status: "unseen");
      DateTime time = DateTime.now().toUtc();

      int millisecondsSinceEpoch = time.millisecondsSinceEpoch;
      try {
        sendPushMessage.sendPushMessage(
            "'$filteredMessage'",
            "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.substring(0, 1).toUpperCase() + userSave.surname!.substring(1).toUpperCase()} SENT MESSAGE",
            userSave.email!,
            "Chat",
            widget.profileDetail.token);
      } catch (e) {
        print(e);
      }

      temp = MessageText(
          text: filteredMessage,
          uid: userSave.uid!,
          time: millisecondsSinceEpoch,
          type: "txt",
          status: "unseen");
      msg.text = "";
    }

    ChatService().updateusernumberofunseenmes(
        from: userSave.uid!, to: widget.profileDetail.id);
    setState(() {});
    msg.clear();
    _scrollToEnd();
  }

  void setMessage(String type, String message, String uid) {
    // print(messages);
    DateTime myDateTime = DateTime.now();
    int timestampInMilliseconds = myDateTime.millisecondsSinceEpoch;

    if (mounted) {
      setState(() {
        messages.add({
          "text": message,
          "type": type,
          "uid": uid,
          "time": timestampInMilliseconds,
          "status": "unseen",
        });
      });
    }
  }

  String groupByDate(int timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
    DateTime now = DateTime.now().toLocal();
    DateTime yesterday =
        DateTime.now().subtract(const Duration(days: 1)).toLocal();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Today';
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return 'Yesterday';
    } else {
      // Format other dates as needed
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress(),
      child: CupertinoTheme(
        data: const CupertinoThemeData(
          primaryColor: Colors.white,
        ),
        child: Material(
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                backgroundColor: mainColor,
                leading: GestureDetector(
                  onTap: () {
                    HomeService().getuserdata().then((value) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => const ChatPageHome()));
                    });
                  },
                  // onTap: Navigator.of(context).push(Materiroute),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                middle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //pic
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                          image: DecorationImage(
                              image: NetworkImage(widget.profilepic))),
                    ),
                    //name and data
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MainAppContainer(
                                  notiPage: true,
                                  user_data: [widget.profileDetail],
                                )));
                        if (profileclickads.isNotEmpty) {
                          showadsbar(context, profileclickads, () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.005),
                        // margin: const EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userSave.email == widget.profileDetail.email
                                ? BigText(
                                    text: "Free Risthey Wala",
                                    size: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  )
                                : BigText(
                                    text: (widget.profileDetail.name != '')
                                        ? "${widget.profileDetail.name.substring(0, 1).toUpperCase()} ${widget.profileDetail.surname.substring(0, 1).toUpperCase() + widget.profileDetail.surname.substring(1).toLowerCase()}"
                                        : "",
                                    size: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            userSave.email == widget.profileDetail.email
                                ? const Center()
                                : Row(
                                    children: [
                                      BigText(
                                        text: widget.profileDetail.puid,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                            userSave.email == widget.profileDetail.email
                                ? const Center()
                                : Row(
                                    children: [
                                      BigText(
                                          text: (connectivity == "Online")
                                              ? "Online"
                                              : (connectivity == "Resumed")
                                                  ? "Offline"
                                                  : "InActive",
                                          size: 8,
                                          color: Colors.white),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          width: 9,
                                          height: 9,
                                          decoration: BoxDecoration(
                                              color: (connectivity == "Online")
                                                  ? const Color(0xFF00FF19)
                                                  : (connectivity == "Resumed")
                                                      ? const Color.fromARGB(
                                                          255, 255, 208, 0)
                                                      : const Color(0xFFBDBDBD)
                                              // color: Color(0xFF33D374)),
                                              // color: if(userSave.connectivity == "Online"){Color(0xFF00FF19)}else if(userSave.connectivity == "Offline"){Color(0xFFBDBDBD)} else{Color(0xFFDBFF00)}
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                    //video,audio,call button
                    Material(
                      color: Colors.transparent,
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.to(VideoCall(
                                profilepic: widget.profilepic,
                                profileId: widget.profileDetail.id,
                                uid: widget.profileDetail.puid,
                                profileName:
                                    "${widget.profileDetail!.name.substring(0, 1).toUpperCase()} ${widget.profileDetail!.surname.substring(0, 1).toUpperCase() + widget.profileDetail!.surname.substring(1).toLowerCase()}",
                                currentProfilePic: userSave.imageUrls!.isEmpty
                                    ? "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/impImage%2Fnoimage.jpg?alt=media&token=4c0d4bc9-761e-48af-b947-4a05a0eaa6d2"
                                    : userSave.imageUrls![0],
                              ));
                              if (videocall.isNotEmpty) {
                                showadsbar(context, videocall, () {
                                  Navigator.pop(context);
                                });
                              } else {}
                            },
                            icon: const Icon(
                              Icons.video_call,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.to(AudioCall(
                                profilepic: widget.profilepic,
                             callStartTime: DateTime.now(),
                             profileId: widget.profileDetail.id,
                               profileName:
                                    "${widget.profileDetail!.name.substring(0, 1).toUpperCase()} ${widget.profileDetail!.surname.substring(0, 1).toUpperCase() + widget.profileDetail!.surname.substring(1).toLowerCase()}",
                                uid:widget.profileDetail.puid ,

                              ));
                            },
                            // enable:false,
                            icon: const Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                          ),
                          PopupMenuButton(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  enabled: !(callstatus ||
                                      blocFriend
                                          .contains(widget.profileDetail.id)),
                                  child: const Text(
                                    'Need conference call',
                                  ),
                                  onTap: () {
                                    var dbref = FirebaseDatabase.instance
                                        .ref()
                                        .child("need_call");
                                    dbref = dbref.child(userSave.uid!);
                                    dbref.child(widget.profileDetail.id).set({
                                      "frienduid": widget.profileDetail.id,
                                      "myuid": userSave.uid
                                    });
                                    setState(() {
                                      callstatus = true;
                                    });
                                    Future(() => customAlertBox1(
                                        context,
                                        Icons.check,
                                        "Conference Call Request\nSent Successfully",
                                        "",
                                        () {}));
                                    if (conferenceads.isNotEmpty) {
                                      showadsbar(context, conferenceads, () {
                                        Navigator.pop(context);
                                      });
                                    }
                                  }),
                              PopupMenuItem(
                                  child: Text(
                                    (reportFriend
                                            .contains(widget.profileDetail.id))
                                        ? "Unreport"
                                        : 'Report',
                                  ),
                                  // enabled:
                                  // !(reportFriend
                                  //           .contains(widget.profileDetail!.id)),
                                  onTap: () {
                                    if (reportFriend
                                        .contains(widget.profileDetail.id)) {
                                      unreport();
                                    } else {
                                      if (blocFriend
                                          .contains(widget.profileDetail.id)) {
                                        report();
                                      } else {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                content: SnackBarContent(
                                                  error_text:
                                                      "Please Block User First \nto \nReport",
                                                  appreciation: "",
                                                  icon: Icons.error,
                                                  sec: 2,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                              );
                                            }).whenComplete(() {
                                          if (blockads.isNotEmpty) {
                                            showadsbar(context, blockads, () {
                                              Navigator.pop(context);
                                            });
                                          }
                                        });
                                      }
                                    }
                                  }),
                              PopupMenuItem(
                                  child: Text(
                                    (blocFriend
                                            .contains(widget.profileDetail.id))
                                        ? "Unblock"
                                        : 'Block',
                                  ),
                                  // enabled: !( blocFriend.contains(widget.profileDetail.id)),
                                  onTap: () {
                                    if (isBlocked ||
                                        blocFriend.contains(
                                            widget.profileDetail.id)) {
                                      if (reportFriend
                                          .contains(widget.profileDetail.id)) {
                                        Future(() => customAlertBox1(
                                            context,
                                            Icons.error,
                                            "Please Unreport User First \nto \nUnblock",
                                            "",
                                            () {}));
                                      } else {
                                        DateTime myDateTime = DateTime.now();
                                        int timestampInMilliseconds =
                                            myDateTime.millisecondsSinceEpoch;
                                        socket.emit("message", {
                                          "message": "Unblock by user",
                                          "sourceId": userSave.uid,
                                          "targetId": widget.profileDetail.id,
                                          "type": "source",
                                          "uid": uid,
                                          "time": timestampInMilliseconds,
                                          "status": "unseen",
                                        });

                                        blocFriend
                                            .remove(widget.profileDetail.id);
                                        setState(() {});
                                        homeService
                                            .unblock(
                                                email: userSave.email!,
                                                profileid:
                                                    widget.profileDetail.id,
                                                sendemail:
                                                    widget.profileDetail.email)
                                            .whenComplete(() {
                                          homeService.getuserdata();
                                        });

                                        NotificationService().addtoactivities(
                                            email: userSave.email!,
                                            title:
                                                "${widget.profileDetail.name.substring(0, 1).toUpperCase()} ${widget.profileDetail.surname.toUpperCase()} ${widget.profileDetail.puid} UNBLOCKED SUCCESSFULLY",
                                            username: widget.profileDetail.name,
                                            userimage: widget.profileDetail
                                                    .imageurls.isEmpty
                                                ? ""
                                                : widget
                                                    .profileDetail.imageurls[0],
                                            userid: widget.profileDetail.id);
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                content: SnackBarContent(
                                                  error_text:
                                                      "Unlock Successfully",
                                                  appreciation: "",
                                                  icon: Icons.error,
                                                  sec: 2,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                              );
                                            }).whenComplete(() {
                                          if (unblockads.isNotEmpty) {
                                            showadsbar(context, unblockads, () {
                                              Navigator.pop(context);
                                            });
                                          }
                                        });
                                      }
                                    } else {
                                      print("block clicked");
                                      DateTime myDateTime = DateTime.now();
                                      int timestampInMilliseconds =
                                          myDateTime.millisecondsSinceEpoch;
                                      socket.emit("message", {
                                        "message": "Block by user",
                                        "sourceId": userSave.uid,
                                        "targetId": widget.profileDetail.id,
                                        "type": "source",
                                        "uid": uid,
                                        "time": timestampInMilliseconds,
                                        "status": "unseen",
                                      });
                                      blocFriend.add(widget.profileDetail.id);
                                      setState(() {});
                                      homeService
                                          .addtoblock(
                                              email: userSave.email!,
                                              profileid:
                                                  widget.profileDetail.id,
                                              sendemail:
                                                  widget.profileDetail.email)
                                          .whenComplete(() {
                                        homeService.getuserdata();
                                      });
                                      NotificationService().addtoactivities(
                                          email: userSave.email!,
                                          title:
                                              "${widget.profileDetail.name.substring(0, 1).toUpperCase()} ${widget.profileDetail.surname.toUpperCase()} ${widget.profileDetail.puid} BLOCKED SUCCESSFULLY",
                                          username: widget.profileDetail.name,
                                          userimage: widget.profileDetail
                                                  .imageurls.isEmpty
                                              ? ""
                                              : widget
                                                  .profileDetail.imageurls[0],
                                          userid: widget.profileDetail.id);
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return const AlertDialog(
                                              content: SnackBarContent(
                                                error_text:
                                                    "Block Successfully",
                                                appreciation: "",
                                                icon: Icons.error,
                                                sec: 2,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0,
                                            );
                                          }).whenComplete(() {
                                        if (blockads.isNotEmpty) {
                                          showadsbar(context, blockads, () {
                                            Navigator.pop(context);
                                          });
                                        }
                                      });
                                    }
                                  })
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                previousPageTitle: "",
              ),
              child: Material(
                color: Colors.white,
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 25),
                  height: MediaQuery.of(context).size.width * 2.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: GroupedListView<dynamic, String>(
                          elements: messages,
                          controller: _scrollController,
                          groupBy: (element) => groupByDate(element['time']),
                          order: GroupedListOrder
                              .DESC, // Order groups in descending order based on date
                          useStickyGroupSeparators: true,
                          groupSeparatorBuilder: (String value) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          itemBuilder: (context, dynamic element) {
                            DateTime dateTime =
                                DateTime.fromMillisecondsSinceEpoch(
                                    element['time']);
                            var temp2 = dateTime.toString().substring(0, 10);
                            // if (messages[index]['type'] == "date") {
                            //   ChatDate(txt: messages[index]['text']);
                            // } else {
                            if (element["text"] == "Unblock by user" ||
                                element["text"] == "Block by user") {
                              return Container();
                            } else {
                              if (element['uid'] == userSave.uid) {
                                return MyMessageCard(
                                  message: element['text'].toString(),
                                  date: dateTime.toString().substring(11, 16),
                                  status: element['status'].toString(),
                                );
                              } else {
                                return (element['type'] == "date")
                                    ? ChatDate(txt: element['text'])
                                    : (userSave.status == "approved" &&
                                            widget.profileDetail.status ==
                                                "approved")
                                        ? SenderMessageCard(
                                            date: dateTime
                                                .toString()
                                                .substring(11, 16),
                                            message: element['text'].toString(),
                                          )
                                        : const SizedBox(
                                            height: 0,
                                            width: 0,
                                          );
                              }
                            }
                          },
                          sort: false,
                          itemComparator: (item1, item2) {
                            return item1['time'].compareTo(item2['time']);
                          },
                          groupComparator: (group1, group2) {
                            // Sort groups in descending order based on date
                            return group2.compareTo(group1);
                          },
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      (isUploading)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "${(percentUpload * 100).toStringAsFixed(0)} %"),
                                Container(
                                  height: 8,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: mainColor,
                                      )),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 8,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7 *
                                                percentUpload,
                                        decoration: BoxDecoration(
                                          color: mainColor,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(
                              width: 0,
                              height: 0,
                            ),
                      widget.profileDetail.blocklists.contains(userSave.uid)
                          ? Text(
                              "Blocked by ${widget.profileDetail.name.substring(0, 1).toUpperCase()} ${widget.profileDetail.surname.substring(0, 1).toUpperCase() + widget.profileDetail.surname.substring(1)}",
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 12))
                          : blocFriend.contains(widget.profileDetail.id)
                              ? Text(
                                  "You blocked ${widget.profileDetail.name.substring(0, 1).toUpperCase()} ${widget.profileDetail.surname.substring(0, 1).toUpperCase() + widget.profileDetail.surname.substring(1)}",
                                  style: TextStyle(
                                      color: Colors.grey[400], fontSize: 12))
                              // ? Text(
                              //     "Blocked by ${widget.profileDetail.name!.substring(0, 1).toUpperCase()} ${widget.profileDetail.surname!.substring(0, 1).toUpperCase() + widget.profileDetail.surname!.substring(1)}",
                              //     style: TextStyle(
                              //         color: Colors.grey[400], fontSize: 12))

                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                      ((blocFriend.contains(widget.profileDetail.id)) ||
                              widget.profileDetail.blocklists
                                  .contains(userSave.uid))
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                            )
                          : userSave.email == widget.profileDetail.email
                              ? const Center()
                              : SendMessageBottom(
                                  isBlocked: isBlocked,
                                  msg: msg,
                                  onclick: () {
                                    print("ok");
                                    if (msg.text.isNotEmpty) {
                                      ChatService().addtounseenmessage(
                                          userimage: userSave.imageUrls!.isEmpty
                                              ? ""
                                              : userSave.imageUrls![0],
                                          username: userSave.name!,
                                          userid: userSave.uid!,
                                          title: msg.text,
                                          email: widget.profileDetail.email);
                                      sendMessage(msg.text, userSave.uid!,
                                          widget.profileDetail.id);
                                    }
                                    if (uploadimageurl != "") {
                                      ChatService().addtounseenmessage(
                                          userimage: userSave.imageUrls!.isEmpty
                                              ? ""
                                              : userSave.imageUrls![0],
                                          username: userSave.name!,
                                          userid: userSave.uid!,
                                          title: uploadimageurl,
                                          email: widget.profileDetail.email);
                                      sendMessage(uploadimageurl, userSave.uid!,
                                          widget.profileDetail.id);
                                      uploadimageurl = "";
                                      setState(() {});
                                    }
                                    if (videoimageurl != "") {
                                      ChatService().addtounseenmessage(
                                          userimage: userSave.imageUrls!.isEmpty
                                              ? ""
                                              : userSave.imageUrls![0],
                                          username: userSave.name!,
                                          userid: userSave.uid!,
                                          title: videoimageurl,
                                          email: widget.profileDetail.email);
                                      sendMessage(videoimageurl, userSave.uid!,
                                          widget.profileDetail.id);
                                      videoimageurl = "";
                                      setState(() {});
                                    }
                                    if (audiourl != "") {
                                      ChatService().addtounseenmessage(
                                          userimage: userSave.imageUrls!.isEmpty
                                              ? ""
                                              : userSave.imageUrls![0],
                                          username: userSave.name!,
                                          userid: userSave.uid!,
                                          title: audiourl,
                                          email: widget.profileDetail.email);
                                      sendMessage(audiourl, userSave.uid!,
                                          widget.profileDetail.id);
                                      audiourl = "";
                                      setState(() {});
                                    }
                                  }),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ristey/chat/colors.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/chat_modal.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:ristey/screens/mobile_chat_screen.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/services/chat_services.dart';

import '../../Assets/Error.dart';

class ContactsList extends StatefulWidget {
  ContactsList({Key? key, required this.res}) : super(key: key);
  List<ChatsModel> res;
  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    // print(widget.res);
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              // itemCount: info.length,
              itemCount: widget.res.length,
              itemBuilder: (context, index) {
                return ChatlistTile(res: widget.res[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatlistTile extends StatefulWidget {
  String? senderuid;
  String? message;
  int? time;
  // int ?numberofunreadmes;
  ChatlistTile({
    super.key,
    required this.res,
    this.message,
    this.senderuid,
    this.time,
  });
  ChatsModel res;
  @override
  State<ChatlistTile> createState() => _ChatlistTileState();
}

class _ChatlistTileState extends State<ChatlistTile> {
  var time;

  List<AdsModel> userads = [];
  void getads() async {
    userads = await AdsService().getallusers(adsid: "49");
    setState(() {});
  }

  var imgurl =
      "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/impImage%2Fnoimage.jpg?alt=media&token=4c0d4bc9-761e-48af-b947-4a05a0eaa6d2";
  setImgUrl() async {
    if (newUserModel!.imageurls.isNotEmpty) {
      imgurl = newUserModel!.imageurls[0];

      setState(() {});
      print(imgurl);
    }
  }

  // late DatabaseReference _dbref;
  Map<dynamic, dynamic>? lastMessage;
  DateTime? dateTime;
  @override
  void initState() {
    super.initState();
    getads();
    setdata();
    // Profile2 = new User();

    setState(() {});
    setImgUrl();
    // _dbref = FirebaseDatabase.instance.ref().child("firstchat");
  }

  NewUserModel? newUserModel;
  int numofunread = 0;
  setdata() async {
    print(widget.res.email);
    newUserModel = await ChatService().getuserdata(widget.res.email);

    numofunread = await ChatService()
        .getnumberofunreadmsg(from: userSave.uid!, to: newUserModel!.id);
    setState(() {});
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final DateFormat timeFormat = DateFormat('HH:mm');
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    final dateWithoutTime = DateTime(date.year, date.month, date.day);
    final yesterdayWithoutTime =
        DateTime(yesterday.year, yesterday.month, yesterday.day);

    if (dateWithoutTime.isAtSameMomentAs(today)) {
      return timeFormat.format(date);
    } else if (dateWithoutTime.isAtSameMomentAs(yesterdayWithoutTime)) {
      return 'Yesterday';
    } else {
      return dateFormat.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("${formatDate(widget.res.lasttime.toString())} sender");
    if (newUserModel != null) {
      if (widget.senderuid == newUserModel!.id) {
        numofunread++;
      }
    }

    // print(newUserModel!.id);
    dateTime = DateTime.fromMillisecondsSinceEpoch(
        widget.res.lasttime.millisecondsSinceEpoch);
    return newUserModel == null
        ? Column(
            children: [
              SizedBox(
                height: Get.height * 0.4,
              ),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          )
        : Column(
            children: [
              InkWell(
                onTap: () async {
                  if (userSave.status == "approved" &&
                      newUserModel!.status == "approved") {
                    ChatService()
                        .updateusernumberofunseenmes(
                            from: userSave.uid!, to: newUserModel!.id)
                        .whenComplete(() {
                      numofunread = 0;
                      setState(() {});
                    });
                    int statusCode =
                        await UserService().finduser1(newUserModel!.email);
                    if (statusCode == 200) {
                      print(newUserModel!.email);
                      print(userSave.email);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MobileChatScreen(
                            roomid: widget.res.userid,
                            profileDetail: newUserModel!,
                            profilepic: widget.res.userimage == ""
                                ? imgurl
                                : widget.res.userimage,
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: SnackBarContent(
                                error_text: "User not found",
                                appreciation: "",
                                icon: Icons.error,
                                sec: 2,
                              ),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            );
                          });
                    }
                    if (userads.isNotEmpty) {
                      showadsbar(context, userads, () async {
                        Navigator.pop(context);
                      });
                    } else {}
                  } else {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            content: SnackBarContent(
                              error_text: "User not found",
                              appreciation: "",
                              icon: Icons.error,
                              sec: 2,
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          );
                        });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: ListTile(
                 
                    title: userSave.email == newUserModel!.email
                        ? Text(widget.res.username)
                        : Text(
                            (newUserModel!.name != '')
                                ? "${newUserModel!.name.substring(0, 1).toUpperCase()} ${newUserModel!.surname.substring(0, 1).toUpperCase() + newUserModel!.surname.substring(1).toLowerCase()}"
                                : "",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: identifyTextType(widget.res.lastmessage) ==
                              "Video URL"
                          ? const Text(
                              // lastMessage.toString(),
                              "Video",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            )
                          : identifyTextType(widget.res.lastmessage) ==
                                  "Audio URL"
                              ? const Text(
                                  // lastMessage.toString(),
                                  "Audio",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                )
                              : identifyTextType(widget.res.lastmessage) ==
                                      "Image URL"
                                  ? const Text(
                                      // lastMessage.toString(),
                                      "Image",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    )
                                  : Text(
                                      // lastMessage.toString(),
                                      (widget.res.lastmessage
                                                  .toString()
                                                  .length <
                                              15)
                                          ? widget.res.lastmessage
                                          : "${widget.res.lastmessage.toString().substring(0, 15)} ...",
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: mainColor,
                      backgroundImage: NetworkImage(
                        widget.res.userimage,
                      ),
                      radius: 25,
                    ),
                    trailing: Column(
                      children: [
                        (userSave.status == "approved" && numofunread > 0)
                            ? Container(
                                height: 18,
                                width: 18,
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 10.0,
                                  minHeight: 10.0,
                                ),
                                child: Text(
                                  numofunread.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : const SizedBox(
                                width: 0,
                                height: 10,
                              ),
                        Text(
                          formatDate(widget.res.lasttime.toString()),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(color: dividerColor),
            ],
          );
  }
}

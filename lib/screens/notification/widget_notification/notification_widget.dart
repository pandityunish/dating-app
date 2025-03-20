import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/screens/mobile_chat_screen.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/use.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/send_utils/noti_modal.dart';
import 'package:timezone/standalone.dart';

import '../../navigation/help_support.dart';

class NotificationWidget1 extends StatefulWidget {
  const NotificationWidget1({super.key});

  @override
  State<NotificationWidget1> createState() => _NotificationWidget1State();
}

class _NotificationWidget1State extends State<NotificationWidget1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          // print("hello");
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Great1()));
        },
        child: const Material(
          elevation: 5,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: SizedBox(
            height: 80,
            width: 350,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 37,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage:
                        NetworkImage('https://picsum.photos/id/65/200/300'),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text.rich(TextSpan(
                        //style: TextStyle(color: Colors.redAccent), //apply style to all
                        children: [
                          TextSpan(
                              text: 'A Sharma CMF10451',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          TextSpan(text: ' Viewed your profile.')
                        ])),
                    SizedBox(
                      height: 10,
                    ),
                    Text("🕙 22 Nov 2021   14:36")
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationWidget2 extends StatefulWidget {
  NotificationWidget2(
      {super.key,
      // required this.name,
      // required this.action,
      required this.notiData,
      this.list,
      this.index});
  // final name;
  // final action;
  NotifyModel notiData;
  var list;
  var index;
  @override
  State<NotificationWidget2> createState() => _NotificationWidget2State();
}

class _NotificationWidget2State extends State<NotificationWidget2> {
  var time;
  List<AdsModel> unsortlistads = [];
  void getads() async {
    unsortlistads = await AdsService().getallusers(adsid: "102");

    setState(() {});
  }

  var imgurl =
      "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/impImage%2Fnoimage.jpg?alt=media&token=4c0d4bc9-761e-48af-b947-4a05a0eaa6d2";
  @override
  void initState() {
    super.initState();
    gettime();
    setImgUrl();
    getads();
  }

  void gettime() async {
    // Parse the timestamp into a DateTime object
    DateTime timestamp = DateTime.parse(widget.notiData.time);

    // Convert the DateTime to a specific timezone
    TZDateTime timestampInNewYork =
        TZDateTime.from(timestamp, getLocation("Asia/Kolkata"));

    // Format the DateTime as a real-time string
    time = DateFormat("yyyy-MM-dd HH:mm").format(timestampInNewYork);
    setState(() {});
  }

  setImgUrl() async {
    // // if (widget.notiData.uid != userSave.uid) {
    // User? profile = User.fromdoc(await FirebaseFirestore.instance
    //     .collection("user_data")
    //     .doc(widget.notiData.uid)
    //     .get());
    // // if (profile.status == "approved") {
    // if (profile.imageUrls != null && profile.imageUrls!.isNotEmpty) {
    //   setState(() {
    //     imgurl = profile.imageUrls![0];
    //   });
    // }
    // } else {
    //   print("removing ${widget.index}");
    //   widget.list.removeAt(widget.index);
    // }
    // }
  }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(bottom: 10, left: 5),
      child: GestureDetector(
        onTap: () async {
          if (widget.notiData.text == "KNOW HOW TO USE APP") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Use()));
            if (unsortlistads.isNotEmpty) {
              showadsbar(context, unsortlistads, () {
                Navigator.pop(context);
              });
            }
          } else if (widget.notiData.text == "QUERY RESOLVED SUCCESSFULLY") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HelpSupport()));
            if (unsortlistads.isNotEmpty) {
              showadsbar(context, unsortlistads, () {
                Navigator.pop(context);
              });
            }
          }
        },
        child: Material(
          elevation: 5,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: SizedBox(
            height: 80,
            width: 350,
            child: Row(
              children: [
                // (userSave.uid == widget.notiData.uid)
                //     ? Container(width: 0, height: 0)
                //     : ClipOval(
                //         child: Image.network(
                //           imgurl,
                //           fit: BoxFit.cover,
                //           filterQuality: FilterQuality.low,
                //           width: 42,
                //           height: 42,
                //         ),
                //       ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: (userSave.uid == widget.notiData.uid) ? 350 : 300,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            RichText(
                                text: TextSpan(
                                    text: widget.notiData.text.trim(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Sans-serif',
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("🕙 $time",
                        style: const TextStyle(
                            fontSize: 8,
                            fontFamily: 'Sans-serif',
                            fontWeight: FontWeight.w400))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ristey/chat/widget/my_message_card.dart';
import 'package:ristey/chat/widget/sender_message_card.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/message_modal.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/search_profile/live_audio_call.dart';
import 'package:ristey/screens/search_profile/live_video_call.dart';
import 'package:ristey/services/chat_services.dart';

class FreeChatScreen extends StatefulWidget {
  final String id;
  const FreeChatScreen({super.key, required this.id});

  @override
  State<FreeChatScreen> createState() => _FreeChatScreenState();
}

class _FreeChatScreenState extends State<FreeChatScreen> {
  List<AdsModel> matchads = [];
  List<AdsModel> astroads = [];
  final ScrollController _scrollController = ScrollController();

  void getads() async {
    matchads = await AdsService().getallusers(adsid: "44");
    astroads = await AdsService().getallusers(adsid: "45");

    setState(() {});
  }

  List<Map<dynamic, dynamic>> messages = [];

  @override
  void initState() {
    getads();
    getallmessages();
    super.initState();
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

  List<MessageModelChats> chats = [];

  void getallmessages() async {
    try {
      chats =
          await ChatService().getallmessage(to: userSave.uid!, from: widget.id);

      setState(() {});
      print(chats);
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

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(
        primaryColor: Colors.white,
      ),
      child: MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: mainColor,
            leading: GestureDetector(
              onTap: () {
                Get.back();
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
                      // color: Colors.transparent,
                      borderRadius: BorderRadius.circular(35),
                      image: const DecorationImage(
                          image: NetworkImage(
                              "https://res.cloudinary.com/dfkxcafte/image/upload/v1713673971/ic_launcher_inlm33.png"))),
                ),
                //name and data
                Container(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.005),
                  // margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(
                        text: "Live Matchmaker",
                        size: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              // margin: const EdgeInsets.only(left: 15),
                              child: BigText(
                                text: "Free Risthey Wala",
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
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
                          Get.to(LiveVideoCall(title: "Live Matchmaker", profilePic:  userSave.imageUrls!.isEmpty?"https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/impImage%2Fnoimage.jpg?alt=media&token=4c0d4bc9-761e-48af-b947-4a05a0eaa6d2":userSave.imageUrls![0]));
                          if (astroads.isNotEmpty) {
                            showadsbar(context, astroads, () {
                              Navigator.pop(context);
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.video_call,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(LiveAudioCall());
                          if (matchads.isNotEmpty) {
                            showadsbar(context, matchads, () {
                              Navigator.pop(context);
                            });
                          }
                          // SendMessage().sendPushMessage(
                          //   "Call",
                          //   "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()}",
                          //   userSave.puid!,
                          //   "audio",
                          //   token,
                          // );
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => CallSample(
                          //               userId: widget.profileDetail.uid,
                          //               selfId: userSave.uid!,
                          //               callType: 0,
                          //             )));
                        },
                        // enable:false,
                        icon: const Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
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
                        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                            element['time']);
                        var temp2 = dateTime.toString().substring(0, 10);
                        // if (messages[index]['type'] == "date") {
                        //   ChatDate(txt: messages[index]['text']);
                        // } else {

                        return (element['type'] == "date")
                            ? ChatDate(txt: element['text'])
                            : SenderMessageCard(
                                date: dateTime.toString().substring(11, 16),
                                message: element['text'].toString(),
                              );
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

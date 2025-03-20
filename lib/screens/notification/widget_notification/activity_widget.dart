import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/activities_modal.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:ristey/screens/mobile_chat_screen.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/services/chat_services.dart';
import 'package:timezone/standalone.dart';

class NotificationWidget3 extends StatefulWidget {
  NotificationWidget3(
      {super.key,
      // required this.name,
      // required this.action,
      this.list,
      required this.activitiesModel,
      required this.onclick,
      required this.adslist,
      this.index});
  // final name;
  // final action;
  ActivitiesModel activitiesModel;
  List<AdsModel> adslist;
  var list;
  var index;
  Function onclick;
  @override
  State<NotificationWidget3> createState() => _NotificationWidget3State();
}

class _NotificationWidget3State extends State<NotificationWidget3> {
  var time;
  var imgurl =
      "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/impImage%2Fnoimage.jpg?alt=media&token=4c0d4bc9-761e-48af-b947-4a05a0eaa6d2";
  @override
  void initState() {
    super.initState();
    getuserdata();
    gettime();

    // DateTime createdAt = DateTime.parse(widget.activitiesModel.createdAt);
    // setState(() {
    //   time = DateFormat("yyyy-MM-dd HH:mm").format(createdAt);
    // });

    // setImgUrl();
  }

  void gettime() async {
    // Parse the timestamp into a DateTime object
    DateTime timestamp = DateTime.parse(widget.activitiesModel.createdAt);

    // Convert the DateTime to a specific timezone
    TZDateTime timestampInNewYork =
        TZDateTime.from(timestamp, getLocation("Asia/Kolkata"));

    // Format the DateTime as a real-time string
    time = DateFormat("yyyy-MM-dd HH:mm").format(timestampInNewYork);
    setState(() {});
  }

  NewUserModel? newUserModel;
  void getuserdata() async {
    newUserModel =
        await ChatService().getuserdatabyid(widget.activitiesModel.userid);
    setState(() {});
  }

  setImgUrl() async {
    print(widget.activitiesModel.userimage);
    // // if (widget.notiData.uid != userSave.uid) {
    // User? profile = User.fromdoc(await FirebaseFirestore.instance
    //     .collection("user_data")
    //     .doc(widget.notiData.uid)
    //     .get());
    // // if (profile.status == "approved") {
    // if (profile.imageUrls != null && profile.imageUrls!.isNotEmpty) {
    if (widget.activitiesModel.userimage == "") {
    } else {
      print("ok");
      setState(() {
        imgurl = widget.activitiesModel.userimage;
      });
    }
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
          // if (widget.notiData.uid != userSave.uid) {
          //   var userSave1 = await FirebaseFirestore.instance
          //       .collection("user_data")
          //       .where('uid', isEqualTo: widget.notiData.uid)
          //       .get();
          //   print('noti click check agin');
          //   var doc = FirebaseDatabase.instance.ref().child('block_list');
          //   doc = doc.child(widget.notiData.uid);
          //   var res = await doc.child(userSave.uid!).get();
          //   // Navigator.push(
          //   //     context,
          //   //     MaterialPageRoute(
          //   //         builder: (context) => ProfilePage(
          //   //               userSave: userSave,
          //   //               pushchat: pushChatPage,
          //   //               type: "other",
          //   //             )));
          if (newUserModel != null && newUserModel!.status == "approved") {
            if (newUserModel!.blocklists.contains(userSave.uid)) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: SnackBarContent(
                        error_text: "User doesn't exist",
                        appreciation: "",
                        icon: Icons.error,
                        sec: 2,
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    );
                  }).whenComplete(() {
                if (widget.adslist.isNotEmpty) {
                  showadsbar(context, widget.adslist, () {
                    Navigator.pop(context);
                  });
                }
              });
            } else {
              // NotificationService().addtoadminnotification(
              //     userid: userSave.uid!,
              //     useremail: userSave.email!,
              //     subtitle: "ACCEPTED INTEREST",
              //     userimage:
              //         userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
              //     title:
              //         "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEEN  ${newUserModel!.name.substring(0, 1).toUpperCase()} ${newUserModel!.surname.toUpperCase()} ${newUserModel!.puid} THROUGH NOTIFICATIONS");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MainAppContainer(
                        notiPage: true,
                        user_data: [newUserModel!],
                      )));

              if (widget.adslist.isNotEmpty) {
                showadsbar(context, widget.adslist, () {
                  Navigator.pop(context);
                });
              }
            }
            // ignore: use_build_context_synchronously
          } else {
            // ignore: use_build_context_synchronously
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    content: SnackBarContent(
                      error_text: "User doesn't exist",
                      appreciation: "",
                      icon: Icons.error,
                      sec: 2,
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  );
                });
          }
          // } else if (widget.notiData.type == "knowHow") {
          //   // ignore: use_build_context_synchronously
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (context) => const Use()));
          // }
        },
        child: Material(
          elevation: 5,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: SizedBox(
            height: 80,
            width: 350,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  // (userSave.uid == widget.activitiesModel.)
                  //     ? Container(width: 0, height: 0)
                  //     :
                  ClipOval(
                    child: Image.network(
                      widget.activitiesModel.userimage == ""
                          ? imgurl
                          : widget.activitiesModel.userimage,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                      width: 42,
                      height: 42,
                    ),
                  ),
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
                        width:
                            //  (userSave.uid == widget.notiData.uid) ? 350
                            //  :
                            290,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text: widget.activitiesModel.title,
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
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: widget.onclick as VoidCallback,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: mainColor, width: 3)),
                      child: const Center(
                        child: Icon(
                          Icons.close,
                          size: 14,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

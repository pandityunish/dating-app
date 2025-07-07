import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:linkify/linkify.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/reply_support.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/send_utils/noti_function.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/widgets/circular_bubbles.dart';
import '../data_collection/custom_appbar.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({Key? key}) : super(key: key);

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  int value = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController descController = TextEditingController();
  var data1;
  List<AdsModel> helpandsupprotads = [];
  List<AdsModel> userhelpandsupprotads = [];
  int adminCount = 0;
  int userCount = 0;
  void getads() async {
    helpandsupprotads = await AdsService().getallusers(adsid: "69");
    userhelpandsupprotads =
        adsuser.where((element) => element.adsid == "69").toList();

    setState(() {});
  }

  void getsupprot() async {
    data1 = await SupprotService().getsupports(userSave.uid!);
    setState(() {
      if (data1 != null) {
        print(data1.length);
        if (data1.length != 0) {
          descController.text = data1[0]["description"];
          adminCount = data1.where((item) => item['isAdmin'] == true).length;
          userCount = data1.where((item) => item['isAdmin'] == false).length;
        }
      }
    });
    print("*************");
    print(data1);
  }

  var data;
  void getallbubbles() async {
    data = await UserService().getbubbles();
    SupprotService()
        .deletesendlink(email: userSave.email!, value: "To Show Support Reply");

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getads();
    getallbubbles();
    getmessage();
    getsupprot();
  }

  String messagesent = "";
  void getmessage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    messagesent = preferences.getString("query")!;
    print(messagesent);
    setState(() {});
  }

  checkdata() async {
    // final docUser = await FirebaseFirestore.instance
    //     .collection('query_data')
    //     .doc(uid)
    //     .get();
    // if (docUser.exists) {
    //   print("query : ${docUser.toString()}");
    //   if (!mounted) return;
    //   setState(() {
    //     messageSend = true;
    //     emailController.text = docUser['email'];
    //     descController.text = docUser['message'];

    //     // emailController.dispose();
    //     descController.dispose();
    //   });
    // }
    // print("checkdata ends");
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar:CustomAppBar(title: "Support", iconImage: 'images/icons/community.png') ,
   
          // CupertinoNavigationBar(
          //   leading: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const MyProfile(
          //                     profilepercentage: 50,
          //                   )));
          //     },
          //     child: Icon(
          //       Icons.arrow_back_ios_new,
          //       color: mainColor,
          //       size: 25,
          //     ),
          //   ),
          //   // middle: Icon(
          //   //   Icons.supervised_user_circle_outlined,
          //   //   // color: ma/
          //   //   size: 30,
          //   // ),
          //   middle: Text.rich(
          //       TextSpan(style: const TextStyle(fontSize: 20), children: [
          //     const TextSpan(
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
          body: Stack(
            children: [
              data == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    )
                  : Container(
                  
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                          
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircularBubles(url: data[0]["image2"])
                                      .animate(
                                          onPlay: (controller) =>
                                              controller.repeat(reverse: false),
                                          autoPlay: true)
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                          ],
                        ),
                      ),
                    ),
              // RiveAnimation.asset(
              //   "RiveAssets/onboard_animation.riv",
              // ),
              data1 == null
                  ? const Center()
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 350,
                          child: Material(
                            color: Colors.white,
                              elevation: 10,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Help & Support",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      (data1.length >= 1)
                                          ? data1[0]["isAdmin"] == true
                                              ? "Query Resolved"
                                              : "Query Raised"
                                          : "Query form",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const SizedBox(height: 10),
                                    SingleChildScrollView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      child: Container(
                                        height: 150,
                                        alignment: Alignment.topLeft,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(blurRadius: 0.05)
                                            ]),
                                        // margin: EdgeInsets.only(
                                        //   left: 5,
                                        //   right: 5,
                                        // ),
                                        padding: const EdgeInsets.only(
                                            left: 7, right: 5, top: 7, bottom: 7),
                                        child: data1.isEmpty || data1 == null
                                            ? TextField(
                                                maxLength: 300,
                                                // enabled: !messageSend,
                                                // enabled: true,
                                                minLines: 5,
                                                maxLines: 10,
                                                // scrollPhysics:AlwaysScrollableScrollPhysics(),
                                                controller: descController,
                                                scrollController:
                                                    ScrollController(),
                                                cursorColor: mainColor,
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                        
                                                  // border: Border.all(
                                                  //   color: CupertinoColors.inactiveGray,
                                                  // ),
                                                  // borderRadius: BorderRadius.circular(30),
                                                  hintText: "Enter Your Query Here",
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                onChanged: (name) => {
                                                  /*setState(() {
                                          this.User_Name = name;
                                        })*/
                                                },
                                                //onSubmitted: (User_Name) => print('Submitted $User_Name'),
                                              )
                                            : SizedBox(
                                                height: 130,
                                                child: ClickableText(
                                                    text: data1[0]
                                                        ["description"]),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    SizedBox(
                                       width: double.infinity,
                                      child: ElevatedButton(
                                        // onPressed: () {
                                        //   print("This is lado ${data1.length}");
                                        // },
                                        
                                        onPressed: (data1.length >= 1)
                                            ? () {
                                                print(data1[0]["isAdmin"]);
                                                              
                                                if (data1[0]["isAdmin"] == true) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ReplySupport(),
                                                      ));
                                                  if (userhelpandsupprotads
                                                      .isNotEmpty) {
                                                    showadsbar(context,
                                                        userhelpandsupprotads, () {
                                                      Navigator.pop(context);
                                                    });
                                                  } else {
                                                    if (helpandsupprotads
                                                        .isNotEmpty) {
                                                      showadsbar(context,
                                                          helpandsupprotads, () {
                                                        Navigator.pop(context);
                                                      });
                                                    }
                                                  }
                                                }
                                              }
                                            : () {
                                                (descController.text.isNotEmpty)
                                                    ? sendQuery()
                                                    : showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (context) {
                                                          return const AlertDialog(
                                                            content: SnackBarContent(
                                                                appreciation: "",
                                                                error_text:
                                                                    "Please Describe Your Query",
                                                                sec: 1,
                                                                icon: Icons.error),
                                                            backgroundColor:
                                                                Colors.transparent,
                                                            elevation: 0,
                                                          );
                                                        });
                                              },
                                        style: ButtonStyle(
                                         
                                            padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
                                                const EdgeInsets.symmetric(
                                                    horizontal: 65, vertical: 12)),
                                            shape: WidgetStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(60.0),
                                                    side: const BorderSide(
                                                        color: Colors.white))),
                                            backgroundColor:
                                                WidgetStateProperty.all<Color>(
                                                    Colors.white)),
                                        child: data1.isEmpty || data1 == null
                                            ? const Text(
                                                'Send',
                                                style: TextStyle(
                                                  fontFamily: 'Serif',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              )
                                            : Text(
                                                data1[0]["isAdmin"] == false
                                                    ? "Pending"
                                                    : messagesent == "false"
                                                        ? 'Pending'
                                                        : messagesent == ""
                                                            ? 'Send'
                                                            : data1 != null &&
                                                                    data1.length ==
                                                                        0
                                                                ? "Reply"
                                                                : 'Reply',
                                                style:  TextStyle(
                                                  fontFamily: 'Serif',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                  color:messagesent == "false"||data1[0]["isAdmin"] == false?Colors.red: Colors.black,
                                                ),
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
            ],
          )),
    );
  }

  sendQuery() async {
    if (descController.text.isEmpty) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: SnackBarContent(
                error_text: "Please enter message",
                appreciation: "",
                icon: Icons.error,
                sec: 3,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            );
          });
    } else {
      if (messagesent == "false") {
      } else {
        messagesent = "false";

        setState(() {});
        var query = {
          "email": userSave.email,
          "message": descController.text,
          "status": "",
        };
        SharedPreferences preferences = await SharedPreferences.getInstance();
        SupprotService().postquery(
          email: userSave.uid!,
          desc: descController.text,
        );
        preferences.setString("query", "true");
        messageSend = true;
        setState(() {});
        NotificationService().addtoadminnotification(
            userid: userSave.uid!,
            useremail: userSave.email!,
            subtitle: "Query",
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            title:
                "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SENT QUERY (${userCount + 1 > 3 ? "More than 3" : userCount + 1})");
        NotificationFunction.setNotification(
          "admin",
          "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SENT QUERY",
          'queryraised',
        );
        NotificationService().addtonotification(
          email: userSave.email!,
          title: "QUERY SENT SUCCESSFULLY",
        );
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text:
                      "Your Message Has Been Sent Successfully \n We Will Reply You Soon",
                  appreciation: "",
                  icon: Icons.check_circle_rounded,
                  sec: 3,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            }).whenComplete(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MyProfile(
                profilepercentage: userProfilePercentage,
              ),
            ),
            (route) => false,
          );
        });
      }
    }
  }
}

class ClickableText extends StatelessWidget {
  final String text;

  const ClickableText({super.key, required this.text});

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch ${link.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Linkify(
          onOpen: _onOpen,
          text: text,
          style: const TextStyle(color: Colors.black),
          linkStyle: const TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}

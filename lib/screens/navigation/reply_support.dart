import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/common/widgets/circular_bubbles.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/navigation/help_support.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/send_utils/noti_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReplySupport extends StatefulWidget {
  const ReplySupport({Key? key}) : super(key: key);

  @override
  State<ReplySupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<ReplySupport> {
  int value = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController descController = TextEditingController();
  var data1;
  void getsupprot() async {
    data1 = await SupprotService().getsupports(userSave.uid!);
    setState(() {});
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
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpSupport()));
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: mainColor,
                size: 25,
              ),
            ),
            // middle: Icon(
            //   Icons.supervised_user_circle_outlined,
            //   // color: ma/
            //   size: 30,
            // ),
            middle: Text.rich(
                TextSpan(style: const TextStyle(fontSize: 20), children: [
              const TextSpan(
                  text: "Free",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: "Showg")),
              TextSpan(
                  text: "rishteywala",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                      fontFamily: "Showg")),
              // TextSpan(
              //     text: ".in", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Showg")),
            ])),
            previousPageTitle: "",
          ),
          child: Stack(
            children: [
              data == null
                  ? const Center()
                  : Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
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
                                      // .then()
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
                      child: SizedBox(
                        height: 350,
                        child: Material(
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
                                  const Text(
                                    "Enquiry Form",
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
                                      alignment: Alignment.topLeft,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
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
                                      child: TextField(
                                        maxLength: 300,
                                        // enabled: !messageSend,
                                        // enabled: true,
                                        minLines: 3,
                                        maxLines: 5,
                                        // scrollPhysics:AlwaysScrollableScrollPhysics(),
                                        controller: descController,
                                        scrollController: ScrollController(),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          // border: Border.all(
                                          //   color: CupertinoColors.inactiveGray,
                                          // ),
                                          // borderRadius: BorderRadius.circular(30),
                                          hintText: "Enter your Message",
                                        ),
                                        textInputAction: TextInputAction.next,
                                        onChanged: (name) => {
                                          /*setState(() {
                                        this.User_Name = name;
                                      })*/
                                        },
                                        //onSubmitted: (User_Name) => print('Submitted $User_Name'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  ElevatedButton(
                                    onPressed: () {
                                      sendQuery();
                                    },
                                    style: ButtonStyle(
                                        padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
                                            const EdgeInsets.symmetric(
                                                horizontal: 65, vertical: 20)),
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
                                    child: const Text(
                                      'Send Message',
                                      style: TextStyle(
                                        fontFamily: 'Serif',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
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
        SupprotService()
            .postquery(email: userSave.uid!, desc: descController.text);
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
                "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SENT QUERY");
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
                  icon: Icons.check,
                  sec: 2,
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
        // showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         content: SnackBarContent2(
        //             error_text:
        //                 "Your Message Has Been Sent Successfully \n We Will Reply You Soon",
        //             icon: Icons.check),
        //         backgroundColor: Colors.transparent,
        //         elevation: 0,
        //       );
        //     });
      }
      // descController.clear();
      // NotificationFunction.setNotification(
      //   "user1",
      //   "QUERY SENT SUCCESSFULLY",
      //   'queryraised',
      // );
    }
  }
}

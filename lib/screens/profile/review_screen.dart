import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/common/widgets/circular_bubbles.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _MeintenanceScreenState();
}

class _MeintenanceScreenState extends State<ReviewScreen> {
  var data;
  void getallbubbles() async {
    data = await UserService().getbubbles();
    setState(() {});
  }

  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    getallbubbles();
  }

  int _rating = 0;
  void showrating() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RatingDialog();
        });
  }

  bool isFiveRating = false;
  void _launchPlayStore() async {
    final Uri url = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.freerishtey.android&reviewId=0');
    // Replace with the package name of the app you want to open
    // const url = 'https://play.google.com/store/apps/details?id=com.freerishtey.android';
    // if (await canLaunchUrl(Uri.parse("https://flutter.dev"))) {
    if (await launchUrl(url).whenComplete(() {
      isFiveRating = true;
      print(_rating);
    })) {
      //                               Navigator.pushAndRemoveUntil(
      // context,
      // MaterialPageRoute(
      //   builder: (context) => MainAppContainer(notiPage: false),
      // ),
      // (route) => false);
    }
    // } else {
    //   throw 'Could not launch https://flutter.dev';
    // }
  }

  Widget buildStar(int starRating) {
    return GestureDetector(
      onTap: () {
        if (starRating == 5) {
          _launchPlayStore();
          HomeService().createRating(
              email: userSave.uid!, number: 5, description: controller.text);

          SupprotService()
              .deletesendlink(email: userSave.email!, value: "To Ask Rating")
              .whenComplete(() {
            exit(0);
          });
          NotificationService().addtoadminnotification(
              userid: userSave.uid!,
              useremail: userSave.email!,
              subtitle: "ONLINE PROFILES",
              userimage:
                  userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
              title:
                  "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} SUBMIT FEEDBACK ${'⭐' * 5}");
        }
        setState(() {
          _rating = starRating;
        });
        print(_rating);
      },
      child: Icon(
        Icons.star,
        size: 40,
        color: _rating >= starRating ? Colors.yellow : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(isFiveRating);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
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
        child: data == null
            ? const Center()
            : Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        padding: const EdgeInsets.symmetric(horizontal: 50),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        padding: const EdgeInsets.symmetric(horizontal: 50),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ])),
                  ),
                  // RiveAnimation.asset(
                  //   "RiveAssets/onboard_animation.riv",
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: SizedBox(
                        height: 320,
                        child: Material(
                            elevation: 10,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Please Rate Us',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        buildStar(1),
                                        buildStar(2),
                                        buildStar(3),
                                        buildStar(4),
                                        buildStar(5),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _rating == 0 || _rating > 4
                                        ? const Center()
                                        : Container(
                                            margin: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            height: 120, // Fixed height
                                            child: TextField(
                                              controller: controller,
                                              minLines: 3,
                                              maxLines: 5,
                                              maxLength: 300,
                                              style: const TextStyle(
                                                  fontFamily: 'Sans-serif',
                                                  fontSize: 17),
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Please write a review",
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: mainColor)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: mainColor)),
                                                // labelText: 'Write Here',
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        // margin: EdgeInsets.only(left: 15),
                                        width: 100,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                shadowColor: WidgetStateColor.resolveWith(
                                                    (states) => Colors.black),
                                                padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
                                                    const EdgeInsets.symmetric(
                                                        vertical: 17)),
                                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                30.0),
                                                        side: const BorderSide(
                                                          color: Colors.white,
                                                        ))),
                                                backgroundColor:
                                                    WidgetStateProperty.all<Color>(
                                                        Colors.white)),
                                            onPressed: () async {
                                              if (_rating == 5) {
                                                NotificationService()
                                                    .addtoadminnotification(
                                                        userid: userSave.uid!,
                                                        useremail:
                                                            userSave.email!,
                                                        subtitle:
                                                            "ONLINE PROFILES",
                                                        userimage: userSave
                                                                .imageUrls!
                                                                .isEmpty
                                                            ? ""
                                                            : userSave
                                                                .imageUrls![0],
                                                        title:
                                                            "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} SUBMIT FEEDBACK ${'⭐' * 5}");
                                                HomeService().createRating(
                                                    email: userSave.uid!,
                                                    number: 5,
                                                    description:
                                                        controller.text);
                                                SupprotService().deletesendlink(
                                                    email: userSave.email!,
                                                    value: "To Ask Rating");
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MainAppContainer(
                                                              notiPage: false),
                                                    ),
                                                    (route) => false);
                                              }
                                              HomeService().createRating(
                                                  email: userSave.uid!,
                                                  number: _rating,
                                                  description: controller.text);
                                              SupprotService().deletesendlink(
                                                  email: userSave.email!,
                                                  value: "To Ask Rating");
                                              NotificationService()
                                                  .addtoadminnotification(
                                                      userid: userSave.uid!,
                                                      useremail:
                                                          userSave.email!,
                                                      subtitle:
                                                          "ONLINE PROFILES",
                                                      userimage: userSave
                                                              .imageUrls!
                                                              .isEmpty
                                                          ? ""
                                                          : userSave
                                                              .imageUrls![0],
                                                      title:
                                                          "${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} SUBMIT FEEDBACK ${'⭐' * _rating}");
                                              await showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return const AlertDialog(
                                                      content: SnackBarContent(
                                                        appreciation: "",
                                                        error_text:
                                                            "Feedback Submit Successfully",
                                                        icon: Icons.check_circle_rounded,
                                                        sec: 2,
                                                      ),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                    );
                                                  });

                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainAppContainer(
                                                            notiPage: false),
                                                  ),
                                                  (route) => false);
                                            },
                                            child: const Text("Submit",
                                                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Serif'))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rate this app'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('How would you rate this app?'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildStar(1),
              buildStar(2),
              buildStar(3),
              buildStar(4),
              buildStar(5),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        MaterialButton(
          onPressed: () {
            // You can perform actions based on the rating, like submitting it to a backend
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _launchPlayStore() async {
    const String appId =
        'com.freerishtey.android'; // Replace with the package name of the app you want to open
    const url = 'https://play.google.com/store/apps/details?id=$appId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await canLaunchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildStar(int starRating) {
    return GestureDetector(
      onTap: () {
        if (starRating == 5) {
          _launchPlayStore();
        } else {
          setState(() {
            _rating = starRating;
          });
        }
      },
      child: Icon(
        Icons.star,
        size: 50,
        color: starRating <= _rating ? Colors.yellow : Colors.grey,
      ),
    );
  }
}

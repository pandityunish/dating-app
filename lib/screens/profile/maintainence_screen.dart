// import 'package:couple_match/globalVars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ristey/common/widgets/circular_bubbles.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';

class MeintenanceScreen extends StatefulWidget {
  const MeintenanceScreen({super.key});

  @override
  State<MeintenanceScreen> createState() => _MeintenanceScreenState();
}

class _MeintenanceScreenState extends State<MeintenanceScreen> {
  var data;
  void getallbubbles() async {
    data = await UserService().getbubbles();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getallbubbles();
  }

  @override
  Widget build(BuildContext context) {
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
                  Center(
                    child: SizedBox(
                      height: 250,
                      child: Material(
                          elevation: 10,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error,
                                  color: mainColor,
                                  size: 70,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Opps",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "Under Maintenance!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                                const Text(
                                  "Sorry For The Inconvenience!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

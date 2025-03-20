import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ristey/common/widgets/circular_bubbles.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';

class BubbleImage extends StatefulWidget {
  BubbleImage({super.key, this.height = 60.0});
  var height = 1.0;
  @override
  State<BubbleImage> createState() => _BubbleImageState();
}

class _BubbleImageState extends State<BubbleImage> {
  var heightOfBubble;
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
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: data == null
            ? const Center()
            : Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image2"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image3"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image1"])
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image4"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image5"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image6"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image7"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image8"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image9"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image10"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image11"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image12"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image13"])
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image14"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image15"])
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
                      CircularBubles(
                              height: widget.height * 0.8,
                              url: data[0]["image16"])
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
              ]));
  }
}

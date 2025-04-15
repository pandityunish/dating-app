import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

void _launchPlayStore(String url) async {
  final Uri url0 = Uri.parse(url);
  // Replace with the package name of the app you want to open
  // const url = 'https://play.google.com/store/apps/details?id=com.freerishtey.android';
  // if (await canLaunchUrl(Uri.parse("https://flutter.dev"))) {
  if (await launchUrl(url0).whenComplete(() {})) {
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

bool containsUrl(String input) {
  const urlPattern = r'(http|https):\/\/([\w.]+\/?)\S*';
  final regex = RegExp(urlPattern, caseSensitive: false);
  return regex.hasMatch(input);
}

void showadsbar(
    BuildContext context, List<AdsModel> allads, VoidCallback onclick) {
  if (allads[0].isActive == false) {
    const Center();
  } else {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      allads.isNotEmpty
                          ? Center(
                              child: allads[0].image.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        bool hasUrl =
                                            containsUrl(allads[0].description);
                                        if (hasUrl) {
                                          AdsService().updateClickAds(
                                              adsId: allads[0].id
                                          );
                                          _launchPlayStore(
                                              allads[0].description);
                                          Navigator.pop(context);
                                          if (allads[0].description == "ads" ||
                                              allads[0].description == "") {
                                            NotificationService()
                                                .addtoadminnotification(
                                                    userid: userSave.uid!,
                                                    useremail: userSave.email!,
                                                    subtitle: "",
                                                    userimage: userSave
                                                            .imageUrls!.isEmpty
                                                        ? ""
                                                        : userSave
                                                            .imageUrls![0],
                                                    title:
                                                        "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEEN ADVERTISEMENT-${allads[0].adsid} CLICK");
                                          }
                                        } else {
                                             AdsService().updateSeenAds(
                                              adsId: allads[0].id
                                          );
                                          onclick();
                                          // Navigator.pop(context);
                                        }
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: allads[0].image,
                                        fit: BoxFit.cover,
                                        // height: 400,
                                        errorWidget: (context, url, error) =>
                                            Image.network(allads[0].image),
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                SizedBox(
                                          height: 80,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                                color: Colors
                                                    .blue), // Replace main_color with actual color
                                          ),
                                        ),
                                      ),
                                    )
                                  : allads[0].video.isNotEmpty
                                      ? VideoPlayerWidget(
                                          videoUrl: allads[0].video,
                                          link: allads[0].description,
                                        )
                                      : Container(),
                            )
                          : const Column(
                              children: [
                                Text(
                                  "जरूरी सूचना ",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "हम आपके महत्वपूर्ण समय और प्रयासों का सम्मान करते हैं। हम बिल्कुल मुफ्त सेवाएं दे रहे हैं और यह पूरी तरह से प्रयास के लायक है।\nनकली से सावधान!",
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Important Information",
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "We regard your important time and endeavors. We are offering absolutely free services and it's totally worth the effort.\nBeware with fakes!",
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    "By \nSourabh Mehndiratta\n The MatchMaker",
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                    ],
                  ),
                ),
              ),

              // Positioned(
              //   top: 5,
              //   right: 5,
              //   child:  InkWell(
              //   onTap: () {
              //     if(userSave.name==null || userSave.imageUrls==null){
              //     onclick();

              //     }else{
              //        NotificationService().addtoadminnotification(
              //         userid: userSave.uid??"",
              //         useremail: userSave.email??"",
              //         subtitle: "",
              //         userimage: userSave.imageUrls!.isEmpty
              //             ? ""
              //             : userSave.imageUrls![0],
              //         title:
              //             "${userSave.name??"2121".substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEEN ADVERTISEMENT-${allads.isEmpty?"85": allads[0].adsid} CLOSE");
              //     onclick();
              //     }
              //     // Assuming NotificationService and userSave are defined elsewhere

              //   },
              //   child:const GlassContainer(
              //     child: Center(child:  Icon(Icons.close,size: 20,)),
              //   ),
              // ))
            ],
          ),
        );
      },
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String link;

  const VideoPlayerWidget(
      {super.key, required this.videoUrl, required this.link});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                onTap: () {
                  _launchPlayStore(widget.link);
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              // GestureDetector(
              //   onTap: _togglePlayPause,
              //   child: Icon(
              //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              //     size: 80.0,
              //     color: Colors.white,
              //   ),
              // ),
            ],
          )
        : const SizedBox(
            height: 200, child: Center(child: CircularProgressIndicator()));
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;

  const GlassContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: SizedBox(
        width: 30,
        height: 30,
        child: Stack(
          children: [
            // Blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            // Optional gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.05)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Border
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
            ),
            // Child content
            Center(child: child),
          ],
        ),
      ),
    );
  }
}

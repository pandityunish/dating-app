// import 'package:couple_match/screens/congo.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ristey/chat/colors.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:ristey/small_functions/profile_completion.dart';
import 'package:video_player/video_player.dart';

class Use extends StatefulWidget {
  const Use({Key? key}) : super(key: key);

  @override
  State<Use> createState() => _UseState();
}

class _UseState extends State<Use> with WidgetsBindingObserver {
  int value = 0;
  TextEditingController nameController = TextEditingController();
  void onPressed() {}

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/How%20to%20use%202.mp4?alt=media&token=8c4c882e-ea75-439a-b412-bb9582e33d03")
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Dispose of the video player controller and chewie controller when the widget is disposed
    _controller.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller.pause();
      setState(() {});
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
            onTap: () async {
              ProfileCompletion profile = ProfileCompletion();
              int profilepercentage = await profile.profileComplete();
              _controller.pause();
              setState(() {});
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyProfile(
                            profilepercentage: profilepercentage,
                          )));
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: mainColor,
              size: 25,
            ),
          ),
          previousPageTitle: "",
          middle: Text.rich(TextSpan(style: TextStyle(fontSize: 20), children: [
            TextSpan(
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
        ),
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                /*crossAxisAlignment: CrossAxisAlignment.start,*/
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.95,
                      child: Material(
                          child: _controller.value.isInitialized
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: AspectRatio(
                                        aspectRatio:
                                            _controller.value.aspectRatio,
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
                              :  SizedBox(
                                  height: 200,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                        color:  mainColor,
                                      )))
                          // child: Chewie(

                          //         controller: _chewieController,
                          //       ),
                          ),
                      // VideoPlayerWidget(
                      //     file:
                      //         "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/How%20to%20use%202.mp4?alt=media&token=8c4c882e-ea75-439a-b412-bb9582e33d03"),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String file;
  // final File file;

  VideoPlayerWidget({required this.file});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SupprotService()
        .deletesendlink(email: userSave.email!, value: "To How Use App");

    // Initialize the video player controller
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.file));
    // _videoPlayerController = VideoPlayerController.file(widget.file);

    // Initialize the chewie controller
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
// aspectRatio: 19/9,
      allowFullScreen: true,
      autoPlay: true,
      looping: false,
      // Other customization options can be added here
      // playedColor: Colors
      //     .red, // Change the color of the played portion of the progress bar
      // handleColor:
      //     Colors.blue, // Change the color of the progress bar handle (thumb)
      // backgroundColor: Colors.grey,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Dispose of the video player controller and chewie controller when the widget is disposed
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _chewieController.pause();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}

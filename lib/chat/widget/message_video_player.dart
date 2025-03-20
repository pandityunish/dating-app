// import 'package:couple_match/globalVars.dart';
import 'package:flutter/material.dart';
import 'package:ristey/global_vars.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class MessageVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const MessageVideoPlayer({super.key, required this.videoUrl});

  @override
  _MessageVideoPlayerState createState() => _MessageVideoPlayerState();
}

class _MessageVideoPlayerState extends State<MessageVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      showControls: true,
      allowFullScreen: true,
      allowMuting: true,
      showOptions: true,
      allowPlaybackSpeedChanging: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: mainColor,
        handleColor: mainColor,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoPlayerController.value.isInitialized
        ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: Chewie(
              controller: _chewieController,
            ))
        : const SizedBox(
            height: 200, child: Center(child: CircularProgressIndicator()));
  }
}

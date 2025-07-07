import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ristey/global_vars.dart';
import 'package:video_player/video_player.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  _VideoUploadScreenState createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final picker = ImagePicker();
  late File _videoFile = File('');

  Future _pickVideoFromGallery() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _videoFile = File(pickedFile.path);
      } else {
        print('No video selected.');
      }
    });
  }

  Future _captureVideoFromCamera() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _videoFile = File(pickedFile.path);
      } else {
        print('No video captured.');
      }
    });
  }

  Future _uploadVideoToFirebase() async {
    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
    final UploadTask uploadTask = storageRef.putFile(_videoFile);
    await uploadTask
        .whenComplete(() => print('Video uploaded to Firebase storage'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _videoFile != null
                ? VideoPlayerWidget(videoFile: _videoFile)
                : Container(
                    child: const Text("no video selected"),
                  ),
            ElevatedButton(
              onPressed: _pickVideoFromGallery,
              child: const Text('Pick video from gallery'),
            ),
            ElevatedButton(
              onPressed: _captureVideoFromCamera,
              child: const Text('Capture video from camera'),
            ),
            ElevatedButton(
              onPressed: _uploadVideoToFirebase,
              child: const Text('Upload video to Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  const VideoPlayerWidget({super.key, required this.videoFile});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(widget.videoFile);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isInitialized &&
          !_videoPlayerController.value.isPlaying) {
        setState(() {});
        _videoPlayerController.play();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      width: 200.0,
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _videoPlayerController.value.isInitialized) {
            return AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor)),
            );
          }
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

class VideoPlayerWidget1 extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget1({super.key, required this.videoUrl});

  @override
  _VideoPlayerWidget1State createState() => _VideoPlayerWidget1State();
}

// class _VideoPlayerWidget1State extends State<VideoPlayerWidget1> {
//   late VideoPlayerController _videoPlayerController;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _videoPlayerController.initialize();
//     _videoPlayerController.addListener(() {
//       if (_videoPlayerController.value.isInitialized &&
//           !_videoPlayerController.value.isPlaying) {
//         setState(() {});
//         _videoPlayerController.play();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _videoPlayerController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done &&
//             _videoPlayerController.value.isInitialized) {
//           return AspectRatio(
//             aspectRatio: _videoPlayerController.value.aspectRatio,
//             child: VideoPlayer(_videoPlayerController),
//           );
//         } else {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerWidget1 extends StatefulWidget {
//   final String videoUrl;

//   const VideoPlayerWidget1({Key? key, required this.videoUrl})
//       : super(key: key);

//   @override
//   _VideoPlayerWidget1State createState() => _VideoPlayerWidget1State();
// }

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerWidget1 extends StatefulWidget {
//   final String videoUrl;

//   VideoPlayerWidget1({required this.videoUrl});

//   @override
//   _VideoPlayerWidget1State createState() => _VideoPlayerWidget1State();
// }

class _VideoPlayerWidget1State extends State<VideoPlayerWidget1> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isInitialized) {
        setState(() {});
      }
      if (_videoPlayerController.value.isPlaying) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  void _toggleVideoPlayback() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
        _isPlaying = false;
      } else {
        _videoPlayerController.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _videoPlayerController.value.isInitialized) {
            return GestureDetector(
              onTap: _toggleVideoPlayback,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10), // Ensure rounded corners
                    child: SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit
                            .fill, // Makes video behave like a cover image
                        child: SizedBox(
                          width: _videoPlayerController.value.size.width,
                          height: _videoPlayerController.value.size.height,
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      ),
                    ),
                  ),
                  if (!_isPlaying)
                    Positioned.fill(
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            _isPlaying
                                ? Icons.pause
                                : Icons.play_circle_outline_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: _toggleVideoPlayback,
                        ),
                      ),
                    ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor)),
            );
          }
        },
      ),
    );
  }
}

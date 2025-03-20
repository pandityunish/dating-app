import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ristey/global_vars.dart';
import 'package:video_player/video_player.dart';

class SendMessageBottom extends StatefulWidget {
  final bool isBlocked;
  final TextEditingController msg;
  final VoidCallback onclick;
  const SendMessageBottom(
      {super.key,
      required this.isBlocked,
      required this.msg,
      required this.onclick});

  @override
  State<SendMessageBottom> createState() => _SendMessageBottomState();
}

class _SendMessageBottomState extends State<SendMessageBottom> {
  VideoPlayerController? _controller;
  final ImagePicker _picker = ImagePicker();
  double uploadProgress = 10;
  XFile? pickedvideo;
  bool isRecording = false;
  XFile? image;
  bool isUploading = false;
  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    pickedvideo = video;
    setState(() {});
    _uploadVideo();
    // if (video != null) {
    //   _controller = VideoPlayerController.file(File(video.path))
    //     ..initialize().then((_) {
    //       setState(() {}); // Update the UI after initialization.
    //       _controller?.play();
    //     });
    // }
  }

  void pickimage() async {
    final pickimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    image = pickimage;
    setState(() {});
    uploadimage();
  }

  // final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _recordingFilePath;
  Future<void> requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future startRecording() async {
    setState(() {
      isRecording = true;
    });
    await requestPermissions(); // Request permissions first

    // await _recorder.openRecorder();

    // await _recorder.startRecorder(
    //   toFile: 'audio.aac', // Use .aac extension
    //   codec: Codec.aacADTS,
    // );
  }

  void stopRecording() async {
    try {
      // String? path = await _recorder.stopRecorder();
      // await _recorder.closeRecorder();
      // setState(() {
      //   isRecording = false;
      // });
      // Check if the file path is null or empty
      // if (path == null || path.isEmpty) {
      //   print("Recording failed or file path is invalid.");
      //   return;
      // }

      // // Ensure the file exists before trying to upload
      // final file = File(path);
      // if (await file.exists()) {
      //   print("File exists, ready for upload.");
      //   // Proceed with uploading the file
      //   uploadaudio(path);
      //   setState(() {
      //     isRecording = false;
      //   });
      // } else {
      //   print("File does not exist at path: $path");
      // }
    } catch (e) {
      print("Failed to stop recorder or upload file: $e");
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Choose option",
            style: TextStyle(color: mainColor, fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    pickimage();
                    Navigator.pop(context);
                  },
                  title: const Text("Photo"),
                  leading: Icon(
                    Icons.account_box,
                    color: mainColor,
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                ListTile(
                  onTap: () {
                    _pickVideo();
                    Navigator.pop(context);
                  },
                  title: const Text("Video"),
                  leading: Icon(
                    Icons.camera,
                    color: mainColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _uploadVideo() async {
    var videoname = '${DateTime.now().millisecondsSinceEpoch}.mp4';
    final cloudinary = CloudinaryPublic("dfkxcafte", "jhr5a7vo");
    print(pickedvideo);
    setState(() {
      isuploading = true;
      isUploading = true;
    });

    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(pickedvideo!.path, folder: videoname),
        onProgress: (count, total) {
          setState(() {
            uploadProgress = (count / total) * 100;
          });
        },
      );
      String imageurl = response.secureUrl;

      videoimageurl = imageurl;
      setState(() {
        isuploading = false;
      });
    } catch (e) {
      setState(() {
        isuploading = false;
        isUploading = false;
      });
    }

    // });
  }

  bool isuploading = false;
  Future uploadimage() async {
    final cloudinary = CloudinaryPublic("dfkxcafte", "jhr5a7vo");

    setState(() {
      isuploading = true;
      isUploading = true;
    });
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(image!.path, folder: "userimage"),
      onProgress: (count, total) {
        setState(() {
          uploadProgress = (count / total) * 100;
        });
      },
    );
    String imageurl = response.secureUrl;
    uploadimageurl = imageurl;
    setState(() {
      isuploading = false;
    });
  }

  Future uploadaudio(String path) async {
    var videoname = '${DateTime.now().millisecondsSinceEpoch}.mp3';

    final cloudinary = CloudinaryPublic("dfkxcafte", "jhr5a7vo");

    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(path, folder: videoname),
      onProgress: (count, total) {
        setState(() {
          uploadProgress = (count / total) * 100;
        });
      },
    );
    String imageurl = response.secureUrl;
    audiourl = imageurl;
    print(imageurl);
    setState(() {});
    widget.onclick();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height:
      //     MediaQuery.of(context).size.height * 0.1,

      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isUploading == true
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 201, 201, 201)),
                    child: isuploading == true
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(mainColor),
                                value: 100,
                                color: mainColor,
                              ),
                              Positioned(
                                  top: 19,
                                  left: 19,
                                  child: InkWell(
                                    onTap: () {
                                      uploadimageurl = "";
                                      videoimageurl = "";
                                      isUploading = false;
                                      isuploading = false;
                                      setState(() {});
                                    },
                                    child: const Center(
                                      child: Icon(Icons.close),
                                    ),
                                  ))
                            ],
                          )
                        : Center(
                            child:
                                identifyTextType(uploadimageurl) == "Image URL"
                                    ? Image.network(uploadimageurl)
                                    : const Center(
                                        child: Text("Video"),
                                      ),
                          ),
                  ),
                )
              : const Center(),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              isRecording == true
                  ? SizedBox(
                      width: 300,
                      height: 30,
                      child: const Center(
                        child: Text("Recording"),
                      ),
                    )
                  : SizedBox(
                      width: Get.width * 0.6,
                      child: TextField(
                        enabled: !widget.isBlocked,
                        maxLength: 100,
                        minLines: 2,
                        maxLines: 4,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Sans-serif',
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        controller: widget.msg,
                        // onSubmitted: sendMessage,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Type a message!',
                          hintStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sans-serif',
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  widget.onclick();
                  setState(() {
                    isUploading = false;
                  });
                },
                child: Icon(
                  Icons.send,
                  color: mainColor,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              isRecording == false
                  ? GestureDetector(
                      onTap: () {
                        // stopRecording();
                        startRecording();
                      },
                      child: Icon(
                        Icons.keyboard_voice_outlined,
                        color: mainColor,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        // stopRecording();
                        stopRecording();
                      },
                      child: Icon(
                        Icons.pause,
                        color: mainColor,
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              isRecording == false
                  ? GestureDetector(
                      onTap: () {
                        _showChoiceDialog(context);
                      },
                      child: Icon(
                        Icons.attach_file,
                        color: mainColor,
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        // await _recorder.closeRecorder();
                        // await _recorder.stopRecorder();
                        isRecording = false;
                        setState(() {});
                      },
                      child: Icon(
                        Icons.cancel,
                        color: mainColor,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

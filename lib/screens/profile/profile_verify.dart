import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/assets/video_upload.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/send_utils/noti_function.dart';
import 'package:ristey/small_functions/profile_completion.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  get navigator => null;
  final picker = ImagePicker();
  late File _videoFile = File('');
  bool isuploading = false;
  double uploadProgress = 0;
  // ignore: prefer_typing_uninitialized_variables
  var uid;

  @override
  void initState() {
    super.initState();
    setuserData();
  }

  setuserData() async {
    // if (uid == null) {
    //   final json2 = await sharedPref.read("uid");
    //   final json3 = await sharedPref.read("user");
    //   setState(() {
    //     uid = json2['uid'];
    //     userSave = User.fromJson(json3);
    //   });
    // }
  }

  Future _pickVideoFromGallery() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    // setState(() {
    if (pickedFile != null) {
      // _videoFile = File(pickedFile.path);
      var size = await pickedFile.length();
      if (size < 2e+7) {
        setState(() {
          _videoFile = File(pickedFile.path);
        });
        setState(() {
          isuploading = true;
        });
        _uploadVideoToFirebase();
        NotificationService().addtoadminnotification(
            userid: userSave.uid!,
            useremail: userSave.email!,
            subtitle: " UPLOAD VIDEO",
            userimage:
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            title:
                "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} TRIED TO UPLOAD VIDEO (JUST LIKE THAT )");
        NotificationFunction.setNotification(
          "admin",
          "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} TRIED TO UPLOAD VIDEO (JUST LIKE THAT )",
          'videouploadjlt',
        );
      } else {
        await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Video size must be less than 20 MB",
                  appreciation: "",
                  icon: Icons.check,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      }
    } else {}
    // });
  }

  Future _captureVideoFromCamera() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.camera);
    // setState(() {
    setState(() {});
    print(pickedFile);
    if (pickedFile != null) {
      var size = await pickedFile.length();
      if (size < 2e+7) {
        // _videoFile = File(pickedFile.path);
        setState(() {
          _videoFile = File(pickedFile.path);
        });
        setState(() {
          isuploading = true;
        });
        _uploadVideoToFirebase();
        NotificationFunction.setNotification(
          "admin",
          "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} TRIED TO UPLOAD VIDEO (JUST LIKE THAT )",
          'videouploadjlt',
        );
      } else {
        await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Video size must be less than 20 MB",
                  appreciation: "",
                  icon: Icons.check,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      }
    } else {
      print('No video captured.');
    }
    // });
  }

  Future _uploadVideoToFirebase() async {
    var videoname = '${DateTime.now().millisecondsSinceEpoch}.mp4';
    final cloudinary = CloudinaryPublic("dfkxcafte", "jhr5a7vo");
    SupprotService()
        .deletesendlink(email: userSave.email!, value: "To Upload Video");

    print(cloudinary);
    setState(() {
      isuploading = true;
    });
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(_videoFile.path, folder: videoname),
      onProgress: (count, total) {
        setState(() {
          uploadProgress = (count / total) * 100;
        });
      },
    );
    String imageurl = response.secureUrl;
    // setState(() {
    //   uploadProgress=response.;
    // });
    // final Reference storageRef =
    //     FirebaseStorage.instance.ref().child('videos/$videoname');
    // final UploadTask uploadTask = storageRef.putFile(_videoFile);
    // uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
    //   print('Upload ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
    //   setState(() {
    //     uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
    //   });
    // }, onError: (Object e) {
    //   print(e.toString());
    // }, onDone: () async {
    //   print('File uploaded!');
    // });
    // await uploadTask.whenComplete(() async {
    setState(() {
      userSave.videoLink = imageurl;
    });
    HomeService().updateeditstatus(email: userSave.email!);
    print('Video uploaded to Firebase storage');
    NotificationService().addtoadminnotification(
        userid: userSave.uid!,
        subtitle: "UPLOAD VIDEO",
        useremail: userSave.email!,
        userimage: userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
        title:
            "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} UPLOADED VIDEO SUCCESSFULLY");

    // _getDownloadUrl(videoname);
    NotificationFunction.setNotification(
      "admin",
      "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} TRIED TO UPLOAD VIDEO (JUST LIKE THAT )",
      'videouploadsuccess',
    );
    NotificationService().addtonotification(
        email: userSave.email!, title: "VIDEO UPLOADED SUCCESSFULLY");
    // NotificationFunction.setNotification(
    //   "user1",
    //   "VIDEO UPLOADED SUCCESSFULLY",
    //   'videouploadsuccess',
    // );
    setState(() {
      isuploading = false;
    });
    HomeService().createverifieduser(
        editname: "Created By ${userSave.name}", videolink: imageurl);
    UserService().addvideo(userSave.email!, imageurl).whenComplete(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: SnackBarContent(
                error_text: "Video Has Been Uploaded Successfully",
                appreciation: "",
                icon: Icons.check,
                sec: 3,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            );
          }).whenComplete(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyProfile(
                      profilepercentage: userProfilePercentage,
                    )));
      });
    }).whenComplete(() {});

    // });
  }

  // Future _getDownloadUrl(var videoName) async {
  //   final FirebaseStorage storage = FirebaseStorage.instance;
  //   User? user = User.fromJson(await sharedPref.read("user"));
  //   String downloadUrl =
  //       await storage.ref('videos/${videoName}').getDownloadURL();
  //   setState(() {
  //     user.videoLink = downloadUrl;
  //     user.videoName = videoName;
  //   });
  //   final json = user.toJson();
  //   print(json.toString());
  //   print("uid : ${uid}");
  //   final docUser =
  //       await FirebaseFirestore.instance.collection('user_data').doc(uid);

  //   try {
  //     await sharedPref.save("user", user);
  //     await docUser.update(json).catchError((error) => print(error));
  //     setState(() {
  //       userSave = user;
  //       isuploading = false;
  //     });
  //   } catch (e) {
  //     print(e);

  //   }
  // }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickVideoFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _captureVideoFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _deleteVideo() async {
    if (userSave.videoLink != null && userSave.videoLink != "") {
      HomeService().createverifieduser(
          editname: "Deleted By ${userSave.name}",
          videolink: userSave.videoLink!);

      setState(() {
        userSave.videoLink = "";
        userSave.videoName = "";
      });
      NotificationService().addtoadminnotification(
          userid: userSave.uid!,
          useremail: userSave.email!,
          subtitle: "ONLINE PROFILES",
          userimage: userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
          title:
              "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} DELETE VIDEO");
      UserService().deletevido(userSave.email!);
      NotificationService().addtonotification(
        email: userSave.email!,
        title: "DELETE VIDEO SUCCESSFULLY",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
          appBar: CustomAppBar(
            title: "Profile Verification",
            iconImage: "images/icons/verified.png",
            onBackButtonPressed: () async {
              ProfileCompletion profile = ProfileCompletion();
              int profilepercentage = profile.profileComplete();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyProfile(
                            profilepercentage: profilepercentage,
                          )));
            },
          ),
          body: Center(
            child: userSave.verifiedStatus == "verified"
                ? Text(
                    "You are Already Verified",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'Sans-serif',
                        decoration: TextDecoration.none,
                        fontSize: 24,
                        color: mainColor,
                        fontWeight: FontWeight.w600),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          const Text(
                            "Upload a Video About You in Brief",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Sans-serif',
                                decoration: TextDecoration.none,
                                fontSize: 18,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                              height: 200,
                              width: Get.width * 0.9,
                              child: (isuploading)
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    mainColor),
                                            value: uploadProgress,
                                            color: mainColor,
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            "Uploading Video: ${(uploadProgress).toStringAsFixed(0)}%",
                                            style: const TextStyle(
                                              fontFamily: 'Sans-serif',
                                              decoration: TextDecoration.none,
                                              fontSize: 16,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : (userSave.videoLink == null ||
                                          userSave.videoLink == '')
                                      ? FloatingActionButton(
                                          onPressed: () {
                                            _showPicker(context: context);
                                          },
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : VideoPlayerWidget1(
                                          videoUrl: userSave.videoLink!)),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "How To Upload Video About You In Brief",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 18,
                                fontFamily: 'Sans-serif',
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Card(
                            elevation: 4,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Consistent border radius
                            ),
                            child: SizedBox(
                              height: 200,
                              width: Get.width * 0.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10), // Ensuring video is rounded too
                                child: FittedBox(
                                  fit: BoxFit
                                      .cover, // Ensures the video fills the card like a cover
                                  child: SizedBox(
                                    width:
                                        Get.width * 0.9, // Matches card width
                                    height: 200, // Matches card height
                                    child: VideoPlayerWidget1(
                                      videoUrl: (userSave.gender != "male")
                                          ? "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/videos%2Ffemalevideo.mp4?alt=media&token=46d36b9f-e321-4fe8-ac66-496a27aca7c7"
                                          : "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/videos%2Fmalevideo.mp4?alt=media&token=96c5c184-1ee7-49c2-80dd-ba63f564766d",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                      // BigText(text: 'A Video About Me'),

                      (userSave.verifiedStatus != "verified")
                          ? SizedBox(
                              height: 50,
                              width: Get.width * 0.9,
                              child: ElevatedButton(
                                // enabled: userSave.verifiedStatus != "verified",
                                style: ButtonStyle(
                                    shadowColor: WidgetStateColor.resolveWith(
                                        (states) => Colors.black),
                                    shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      // side: const BorderSide(
                                      //     color: Colors.black)
                                    )),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white)),
                                child: Text(
                                  (userSave.videoLink == null ||
                                          userSave.videoLink == '')
                                      ? "Upload"
                                      : "Upload",
                                  style: const TextStyle(
                                    fontFamily: 'Serif',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: isuploading
                                    ? null
                                    : () {
                                        if (userSave.verifiedStatus !=
                                            "verified") {
                                          if (isuploading) {
                                            print("updating video");
                                          } else {
                                            if ((userSave.videoLink == null ||
                                                userSave.videoLink == '')) {
                                              _showPicker(context: context);
                                            } else {
                                              // _deleteVideo();
                                            }
                                          }
                                        }
                                        print(_videoFile.path);
                                      },
                              ))
                          : SizedBox(height: 0, width: 0),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
          )),
    );
  }
}

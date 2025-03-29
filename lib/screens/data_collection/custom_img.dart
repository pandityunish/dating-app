// import 'dart:html';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ristey/assets/image.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/storage/storage_repo.dart';

import '../../Assets/Error.dart';

import 'package:http/http.dart' as http;
import '../../models/shared_pref.dart';

class CustomImageContainer extends StatefulWidget {
  const CustomImageContainer({
    Key? key,
    this.imageUrl,
    required this.num,
    required this.isBlur,
  }) : super(key: key);
  final String? imageUrl;
  final int num;
  final bool isBlur;
  @override
  State<CustomImageContainer> createState() => _CustomImageContainerState();
}

class _CustomImageContainerState extends State<CustomImageContainer> {
  late final String? imageUrl;
  late final int num;
  bool imagepicked = false;
  var imgPath = File("/");
  @override
  initState() {
    super.initState();
    num = widget.num;
    if (widget.imageUrl == null) {
      imageUrl = "";
    } else {
      imageUrl = widget.imageUrl;
    }
  }

  final imageurls = ImageUrls();

  Future<void> onPressed() async {
    CroppedFile? croppedFile;
    ImagePicker _picker = ImagePicker();
    // final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
    final _image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    if (_image == null) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: SnackBarContent(
                error_text: "No Image was Selected",
                appreciation: "",
                icon: Icons.error,
                sec: 1,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            );
          });
    } else {
      try {
        croppedFile = await ImageCropper().cropImage(
          sourcePath: _image.path,
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.square,
          //   CropAspectRatioPreset.ratio3x2,
          //   CropAspectRatioPreset.original,
          //   CropAspectRatioPreset.ratio4x3,
          //   CropAspectRatioPreset.ratio16x9
          // ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Free Rishtey Wala',
                toolbarColor: mainColor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false,
                activeControlsWidgetColor: mainColor,
                statusBarColor: Colors.white),
          ],
        );
      } catch (e) {
        print(e);
      }
      if (croppedFile != null) {
        setState(() {
          imagepicked = true;
        });

        setState(() {
          imgPath = File(croppedFile!.path);
        });
        print(croppedFile);
        StorageRepo().uploadImage(
          croppedFile,
        );

        Future.delayed(const Duration(seconds: 1), () {
          imagepicked = false;
        });
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                content: SnackBarContent(
                  error_text: "No Image was Selected",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 1,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      }
    }
    // print("something is happening");
  }

  Future<XFile?> urlToXFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = await getTemporaryDirectory();
        final filePath =
            '${directory.path}/filename.png'; // Set the desired file name and extension
        File file = File(filePath);

        await file.writeAsBytes(bytes, flush: true);

        return XFile(file.path);
      }
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }

  onPressed2(String imageurl) async {
    XFile? xFile = await urlToXFile(imageurl);

    print(imageurl);
    CroppedFile? croppedFile;
    try {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: xFile!.path,
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        //   CropAspectRatioPreset.ratio3x2,
        //   CropAspectRatioPreset.original,
        //   CropAspectRatioPreset.ratio4x3,
        //   CropAspectRatioPreset.ratio16x9
        // ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Free Rishtey Wala',
              toolbarColor: mainColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              activeControlsWidgetColor: mainColor,
              statusBarColor: Colors.white),
        ],
      );
    } catch (e) {
      print(e);
    }
    if (croppedFile != null) {
      setState(() {
        imagepicked = true;
      });
      // print("cropped image path : ${croppedFile!.path}");
      setState(() {
        // imgPath = File(_image.path);
        imgPath = File(croppedFile!.path);
      });
      print(croppedFile);
      StorageRepo().replaceImage(croppedFile, num);
      // print("cropped image name : ");
      // StorageRepo().uploadImage(croppedFile);

      Future.delayed(const Duration(seconds: 1), () {
        imagepicked = false;
      });
    }
  }

  deleteImg() async {
    SharedPref sharedPref = SharedPref();

    print("deleting image");

    try {
      ImageUrls().deleteLink(num);
      NotificationService().addtoadminnotification(
          userid: userSave.uid!,
          subtitle: "EDIT PROFILE",
          useremail: userSave.email!,
          userimage: userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
          title:
              "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} DELETE PHOTO SUCCESFULLY ");
      NotificationService().addtonotification(
          email: userSave.email!, title: "DELETE PHOTO SUCCESSFULLY");
      if (userSave.imageUrls != null && userSave.imageUrls!.isNotEmpty) {
        // userSave.imageUrls!.removeAt(num);

        sharedPref.save("user", userSave);

        // NotificationService().addtonotification(
        //   email: userSave.email!,
        //   title: "PHOTO DELETED SUCCESSFULLY",
        // );
      }
    } catch (Excepetion) {
      print(Excepetion);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ImageUrls(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          final urls = value as List<String>;
          var imageCount = imageurls.length;
          var url = (imageurls.imageUrl(atIndex: num) == null)
              ? ""
              : imageurls.imageUrl(atIndex: num);

          return (!imagepicked)
              ? (imageCount <= num)
                  ? Container(
                      height: 100,
                      width: 100,
                      child:
                          //(imageUrl == "")
                          //     ?
                          SizedBox(
                        height: 100,
                        width: 100,
                        child: FloatingActionButton(
                          heroTag: "btn$num",
                          onPressed: onPressed,
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF888888),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ))
                  : SizedBox(
                      height: 100,
                      width: 100,
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            // child: Image.network(url!, fit: BoxFit.cover)
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: NetworkImage(url!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: ClipRRect(
                              // make sure we apply clip it properly
                              child: widget.isBlur == true
                                  ? BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 2, sigmaY: 2),
                                      child: Container(
                                        alignment: Alignment.center,
                                        color: Colors.grey
                                            .withOpacity(0.1), // Slight overlay
                                        child: Icon(
                                          Icons.lock, // Lock icon
                                          size: 30, // Icon size
                                          color: mainColor, // Icon color
                                        ),
                                      ),
                                    )
                                  : Center(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      onPressed2(url!);
                                    },
                                    child: Image.asset("images/icons/edit.png")

                                    // Icon(
                                    //   Icons.edit_square,
                                    //   color: Colors.white,
                                    //   size: 18,
                                    //   shadows: <Shadow>[
                                    //     Shadow(
                                    //         color: Colors.black, blurRadius: 15.0)
                                    //   ],
                                    // ),
                                    ),
                                GestureDetector(
                                    onTap: deleteImg,
                                    child:
                                        Image.asset("images/icons/delete.png")
                                    //  Icon(
                                    //   Icons.delete,
                                    //   size: 18,
                                    //   color: Colors.white,
                                    //   shadows: <Shadow>[
                                    //     Shadow(
                                    //         color: Colors.black, blurRadius: 15.0)
                                    //   ],
                                    // ),
                                    )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
              : SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(mainColor)),
                );
        });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ristey/assets/image.dart';
import 'package:ristey/common/widgets/custom_button.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/data_collection/custom_img.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';

import '../../models/shared_pref.dart';

class AddPics extends StatefulWidget {
  const AddPics({Key? key}) : super(key: key);

  @override
  State<AddPics> createState() => _ReligionState();
}

class _ReligionState extends State<AddPics> {
  int value = 0;
  User userSave = User();
  @override
  void initState() {
    super.initState();
    setData();
  }

  UserService userService = Get.put(UserService());
  setData() async {
    SharedPref sharedPref = SharedPref();

    // final json2 = await sharedPref.read("uid");
    var json3;
    try {
      json3 = await sharedPref.read("user");
    } catch (e) {
      print(e);
    }
    // print(json3.toString());
    setState(() {
      userSave = User.fromJson(json3);
    });
    ImageUrls imageUrls = ImageUrls();
    imageUrls.clear();
    for (var i = 0; i < userSave.imageUrls!.length; i++) {
      imageUrls.add(
        imageurl: userSave.imageUrls![i],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageurls = ImageUrls();
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100), // Adjust AppBar height
          child: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: mainColor,
                size: 25,
              ),
            ),
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(
                  top: 10), // Adjust padding for alignment
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: mainColor),
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DefaultTextStyle(
                      style: TextStyle(
                        color: mainColor,
                        fontFamily: 'Sans-serif',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                      child: Text("Upload Pics"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "93% User Visit the Profile",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "After Seen Profile Picture",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // BlocBuilder<ImagesBloc, ImageState>(
                            //     builder: (context, state) {
                            //   if (state is ImageLoading) {
                            //     return Center(
                            //       child: CircularProgressIndicator(),
                            //     );
                            //   } else if (state is ImageLoaded) {
                            // return Column(

                            ValueListenableBuilder(
                              valueListenable: ImageUrls(),
                              builder: (BuildContext context, dynamic value,
                                  Widget? child) {
                                final urls = value as List<String>;
                                var imageCount = imageurls.length;
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        (imageCount > 0)
                                            ? CustomImageContainer(
                                                isBlur: false,
                                                imageUrl: imageurls.imageUrl(
                                                    atIndex: 0),
                                                num: 0)
                                            : const CustomImageContainer(
                                                num: 0,
                                                isBlur: false,
                                              ),
                                        (imageCount > 1)
                                            ? CustomImageContainer(
                                                isBlur: false,
                                                imageUrl: imageurls.imageUrl(
                                                    atIndex: 1),
                                                num: 1)
                                            : const CustomImageContainer(
                                                num: 1,
                                                isBlur: false,
                                              ),
                                        (imageCount > 2)
                                            ? CustomImageContainer(
                                                isBlur: false,
                                                imageUrl: imageurls.imageUrl(
                                                    atIndex: 2),
                                                num: 2)
                                            : const CustomImageContainer(
                                                num: 2,
                                                isBlur: false,
                                              ),
                                        // CustomImageContainer(),
                                        // CustomImageContainer(),
                                        // CustomImageContainer(),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        (imageCount > 3)
                                            ? CustomImageContainer(
                                                isBlur: false,
                                                imageUrl: imageurls.imageUrl(
                                                    atIndex: 3),
                                                num: 3)
                                            : const CustomImageContainer(
                                                isBlur: false,
                                                num: 3,
                                              ),
                                        (imageCount > 4)
                                            ? CustomImageContainer(
                                                isBlur: false,
                                                imageUrl: imageurls.imageUrl(
                                                    atIndex: 4),
                                                num: 4)
                                            : const CustomImageContainer(
                                                num: 4,
                                                isBlur: false,
                                              ),
                                        (imageCount > 5)
                                            ? CustomImageContainer(
                                                isBlur: false,
                                                imageUrl: imageurls.imageUrl(
                                                    atIndex: 5),
                                                num: 5)
                                            : const CustomImageContainer(
                                                num: 5,
                                                isBlur: false,
                                              ),

                                        // CustomImageContainer(),
                                        // CustomImageContainer(),
                                        // CustomImageContainer(),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            // } else {
                            //   return Text("Something went wrong.");
                            // }
                            // }),
                          ],
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              "Upload Your Best Pics",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "To",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "Get Instant Match",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        // new SizedBox(
                        //   height: 50,
                        //   width: 300,
                        //   child: ElevatedButton(
                        //       onPressed: () async {
                        //         Navigator.of(context).push(MaterialPageRoute(
                        //             builder: (context) => Congo(
                        //                   userS: userSave,
                        //                 )));
                        //       },
                        //       child: Text(
                        //         "Continue",
                        //         style: TextStyle(
                        //           fontSize: 20,
                        //           color: Colors.black,
                        //         ),
                        //       ),
                        //       style: ButtonStyle(
                        //           shape:
                        //               MaterialStateProperty.all<RoundedRectangleBorder>(
                        //                   RoundedRectangleBorder(
                        //                       borderRadius: BorderRadius.circular(30.0),
                        //                       side: BorderSide(color: Colors.black))),
                        //           backgroundColor:
                        //               MaterialStateProperty.all<Color>(Colors.white))),
                        // ),
                      ],
                    ),
                  ],
                ),
                  CustomButton(
                        text: "Continue",
                        onPressed: () async{
                         setState(() {
                          color_done2 = true;
                        });
                        // Shared
                        print(userSave.email);
                        //  print(userService.userdata['name']);
                        UserService().deleteincompleteuser(userSave.email!);
                        int statusCode =
                            await UserService().finduser(userSave.email!);
                        if (statusCode == 200) {
                          HomeService()
                              .deleteuseraccount(email: userSave.email!)
                              .whenComplete(() {
                            userService.createappuser(
                                aboutme: userService.userdata["aboutme"] ?? "",
                                puid: userService.userdata["puid"],
                                lat: userService.userdata['lat'] ?? 0.0,
                                lng: userService.userdata['lng'] ?? 0.0,
                                age: userService.userdata["age"] ?? "18",
                                diet: userService.userdata["diet"] ?? "",
                                disability:
                                    userService.userdata["disability"] ?? "",
                                drink: userService.userdata["drink"] ?? "",
                                education:
                                    userService.userdata["education"] ?? "",
                                height: userService.userdata["height"] ?? "",
                                income:
                                    userService.userdata["incomestatus"] ?? "",
                                patnerprefs:
                                    userService.userdata["patnerpref"] ?? "",
                                smoke: userService.userdata["smoke"] ?? "",
                                displayname: userService.userdata["name"] ?? "",
                                email: userSave.email!,
                                religion:
                                    userService.userdata["religion"] ?? "",
                                name: userService.userdata["name"] ?? "",
                                surname: userService.userdata["surname"] ?? "",
                                phone: userService.userdata["phone"] ?? "",
                                gender: userService.userdata["gender"] ?? "",
                                kundalidosh:
                                    userService.userdata["kundalidosh"] ?? "",
                                martialstatus:
                                    userService.userdata["maritalstatus"] ?? "",
                                profession:
                                    userService.userdata["profession"] ?? "",
                                location:
                                    userService.userdata["location"] ?? "",
                                city: userService.userdata["city"] ?? "",
                                state: userService.userdata["state"] ?? "",
                                placeofbirth:
                                    userService.userdata['placeofbirth'],
                                timeofbirth:
                                    userService.userdata['timeofbirth'],
                                imageurls: imageurls.value
                                    .map((str) => str as dynamic)
                                    .toList(),
                                blocklists: [],
                                reportlist: [],
                                shortlist: [],
                                country: userService.userdata["country"] ?? "",
                                token: userSave.token!,
                                dob: userService.userdata["dob"]);
                          });
                        } else {
                          userService.createappuser(
                              aboutme: userService.userdata["aboutme"] ?? "",
                              puid: userService.userdata["puid"],
                              lat: userService.userdata['lat'] ?? 0.0,
                              lng: userService.userdata['lng'] ?? 0.0,
                              age: userService.userdata["age"] ?? "18",
                              diet: userService.userdata["diet"] ?? "",
                              disability:
                                  userService.userdata["disability"] ?? "",
                              drink: userService.userdata["drink"] ?? "",
                              education:
                                  userService.userdata["education"] ?? "",
                              height: userService.userdata["height"] ?? "",
                              income:
                                  userService.userdata["incomestatus"] ?? "",
                              patnerprefs:
                                  userService.userdata["patnerpref"] ?? "",
                              smoke: userService.userdata["smoke"] ?? "",
                              displayname: userService.userdata["name"] ?? "",
                              email: userSave.email!,
                              religion: userService.userdata["religion"] ?? "",
                              name: userService.userdata["name"] ?? "",
                              surname: userService.userdata["surname"] ?? "",
                              phone: userService.userdata["phone"] ?? "",
                              gender: userService.userdata["gender"] ?? "",
                              kundalidosh:
                                  userService.userdata["kundalidosh"] ?? "",
                              martialstatus:
                                  userService.userdata["maritalstatus"] ?? "",
                              profession:
                                  userService.userdata["profession"] ?? "",
                              location: userService.userdata["location"] ?? "",
                              city: userService.userdata["city"] ?? "",
                              state: userService.userdata["state"] ?? "",
                              placeofbirth:
                                  userService.userdata['placeofbirth'],
                              timeofbirth: userService.userdata['timeofbirth'],
                              imageurls: imageurls.value
                                  .map((str) => str as dynamic)
                                  .toList(),
                              blocklists: [],
                              reportlist: [],
                              shortlist: [],
                              country: userService.userdata["country"] ?? "",
                              token: userSave.token!,
                              dob: userService.userdata["dob"]);
                        }
                        },
                        mainColor: mainColor,
                        colorDone: color_done2,
                      ),
               
              ],
            ),
          ),
        ),
      ),
    );
    // );
  }

  bool color_done2 = false;
}

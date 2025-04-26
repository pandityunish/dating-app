import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';

class MannualEducationUpdate extends StatefulWidget {
  const MannualEducationUpdate({super.key});

  @override
  State<MannualEducationUpdate> createState() => _MannualEducationState();
}

class _MannualEducationState extends State<MannualEducationUpdate> {
  TextEditingController name = TextEditingController();
  final _focusNode1 = FocusNode();
  UserService userService = Get.put(UserService());

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MyProfile(profilepercentage: 50),
                    ));
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: mainColor,
                size: 25,
              ),
            ),
            middle: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIcon(
                  const AssetImage('images/icons/education.png'),
                  size: 15,
                  color: mainColor,
                ),
                // Icon(
                //   Icons.temple_buddhist,
                //   size: 30,),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  // margin: EdgeInsets.only(right: 12),
                  child: const DefaultTextStyle(
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Sans-serif',
                          fontWeight: FontWeight.w700,
                          fontSize: 24),
                      child: Text("Other Education")),
                )
              ],
            ),
            previousPageTitle: "",
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Center(
                    child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: SizedBox(
                              height: 60,
                              child: CupertinoTextField(
                                // height: 20.0,
                                maxLength: 10,

                                maxLengthEnforcement: MaxLengthEnforcement
                                    .enforced, // show error message
                                // maxLengthEnforcedMessage: 'You have reached the maximum character limit of 50',
                                placeholder: "Enter Education",
                                cursorColor: mainColor,
                                cursorWidth: 2,
                                focusNode: _focusNode1,
                                controller: name,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _focusNode1.hasFocus
                                        ? mainColor
                                        : Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                textInputAction: TextInputAction.done,
                                onChanged: (name) => {},
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.5,
                        ),
                        SizedBox(
                          // margin: EdgeInsets.only(left: 15),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shadowColor: WidgetStateColor.resolveWith(
                                      (states) => Colors.black),
                                  padding: WidgetStateProperty.all<
                                          EdgeInsetsGeometry?>(
                                      const EdgeInsets.symmetric(vertical: 17)),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                          side: const BorderSide(
                                            color: Colors.white,
                                          ))),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.white)),
                              onPressed: () async {
                                if (name.text.isEmpty) {
                                  await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: SnackBarContent(
                                            appreciation: "",
                                            error_text: "Please Enter Data",
                                            icon: Icons.error,
                                            sec: 2,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                        );
                                      });
                                } else {
                                  HomeService().updateeducation(
                                      email: userSave.email!,
                                      mes: name.text.trim());
                                  userSave.Education = name.text.trim();
                                  HomeService().createeditprofile(
                                      userid: userSave.email!,
                                      isBlur: false,
                                      editname: userSave.name!,
                                      aboutme: userSave.About_Me!,
                                      mypreference: userSave.Partner_Prefs!,
                                      imageurls: userSave.imageUrls!);
                                  HomeService()
                                      .updateeditstatus(email: userSave.email!);
                                  SupprotService().deletesendlink(
                                      email: userSave.email!,
                                      value: "To Save Education Manually");
                                  NotificationService().addtoadminnotification(
                                      userid: userSave.uid!,
                                      useremail: userSave.email!,
                                      subtitle: "ONLINE PROFILES",
                                      userimage: userSave.imageUrls!.isEmpty
                                          ? ""
                                          : userSave.imageUrls![0],
                                      title:
                                          "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} UPDATE EDUCATION MANNUALY");
                                  await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: SnackBarContent(
                                            appreciation: "",
                                            error_text: "Update Successfully",
                                            icon: Icons.check,
                                            sec: 2,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                        );
                                      });
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 0),
                                          reverseTransitionDuration:
                                              const Duration(milliseconds: 0),
                                          pageBuilder: (_, __, ___) =>
                                              MainAppContainer(
                                                notiPage: false,
                                              )));
                                  // }
                                }
                                // print(birthPlaceController.text);
                              },
                              child: const Text(
                                "Update",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Serif'),
                              )),
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          )),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';

class MannulProfessionUpdate extends StatefulWidget {
  const MannulProfessionUpdate({super.key});

  @override
  State<MannulProfessionUpdate> createState() => _MannulProfessionState();
}

class _MannulProfessionState extends State<MannulProfessionUpdate> {
  TextEditingController name = TextEditingController();
  final _focusNode1 = FocusNode();
  UserService userService = Get.put(UserService());
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
          appBar: CustomAppBar(
              title: "Profession",
              iconImage: 'images/icons/profession_suitcase.png'),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                    child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          child: SizedBox(
                            height: 65,
                            child: TextField(
                              // height: 20.0,

                              maxLength: 15,
                              maxLines: 1,

                              maxLengthEnforcement: MaxLengthEnforcement
                                  .enforced, // show error message
                              // maxLengthEnforcedMessage: 'You have reached the maximum character limit of 50',

                              focusNode: _focusNode1,
                              controller: name,
                              cursorColor: mainColor,
                              cursorWidth: 2,
                              decoration: InputDecoration(
                                hintText: "Enter Profession",
                                contentPadding:
                                    const EdgeInsets.only(left: 20, bottom: 10),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: _focusNode1.hasFocus
                                        ? mainColor
                                        : Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: _focusNode1.hasFocus
                                        ? mainColor
                                        : Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              onChanged: (name) => {},
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
                                      const EdgeInsets.symmetric(vertical: 12)),
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
                                  HomeService().updateprofession(
                                      email: userSave.email!,
                                      mes: name.text.trim());
                                  SupprotService().deletesendlink(
                                      email: userSave.email!,
                                      value: "To Save Profession Manually");
                                  userSave.Profession = name.text.trim();
                                  HomeService().createeditprofile(
                                      userid: userSave.email!,
                                      isBlur: false,
                                      editname: userSave.name!,
                                      aboutme: userSave.About_Me!,
                                      mypreference: userSave.Partner_Prefs!,
                                      imageurls: userSave.imageUrls!);
                                  HomeService()
                                      .updateeditstatus(email: userSave.email!);
                                  NotificationService().addtoadminnotification(
                                      userid: userSave.uid!,
                                      useremail: userSave.email!,
                                      subtitle: "ONLINE PROFILES",
                                      userimage: userSave.imageUrls!.isEmpty
                                          ? ""
                                          : userSave.imageUrls![0],
                                      title:
                                          "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} UPDATE PROFESSION MANUALLY");
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
                                "Submit",
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

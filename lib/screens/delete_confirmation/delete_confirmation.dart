import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/new_save_pref.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/send_utils/noti_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_collection/custom_appbar.dart';

class DeleteConfirm extends StatefulWidget {
  const DeleteConfirm({Key? key}) : super(key: key);

  @override
  State<DeleteConfirm> createState() => _DeleteConfirmState();
}

class _DeleteConfirmState extends State<DeleteConfirm> {
  TextEditingController _deleteReason = TextEditingController();
  double _currentSliderValue = 0;
  double _startValue = 20.0;
  double _endValue = 90.0;
  bool value = false;
  bool deleterunning = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
        appBar:CustomAppBar(title: "Delete Profile", iconImage: 'images/icons/delete_bin.png') ,
   
            // CupertinoNavigationBar(
            //   leading: GestureDetector(
            //     onTap: () {
            //       Navigator.of(context).pop();
            //     },
            //     child: Icon(
            //       Icons.arrow_back_ios_new,
            //       color: mainColor,
            //       size: 25,
            //     ),
            //   ),
            //   middle: Row(
            //     children: [
            //       // Icon(
            //       //   Icons.chevron_left,
            //       //   size: 45,
            //       //   color: Colors.black,
            //       // ),
            //       BigText(
            //         text: "Delete My Profile",
            //         size: 20,
            //         color: mainColor,
            //         fontWeight: FontWeight.w700,
            //       )
            //     ],
            //   ),
            //   previousPageTitle: "",
            // ),
            body: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(left: 10, right: 15,bottom: 10),
                // child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 15,),
                            child: Text(
                              "Why Are You Deleting Your Profile?",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 15, top: 6, bottom: 10),
                            child: Text(
                              "Please Tell us Why are You leaving us.\nWe are Always looking to Improve Us for Our Users",
                              style: GoogleFonts.poppins(
                                  decoration: TextDecoration.none,
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                         Container(
                          height: Get.height*0.2,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: TextField(
                        controller: _deleteReason,
                        minLines: 5,
                        maxLines: 10,
                        maxLength: 300,

                        cursorColor: mainColor,
                        style:
                            TextStyle(fontFamily: 'Sans-serif', fontSize: 17),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: new BorderSide(color: mainColor)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: mainColor)),
                          // labelText: 'Write Here',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 20),
                      width: 200,
                      height:200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          image: DecorationImage(
                              image:
                                  AssetImage("images/icons/delete_bin.png",),fit: BoxFit.cover)),
                    ),
                      ],
                    ),
                   
                    SizedBox(
                      width: Get.width*0.85,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shadowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                    EdgeInsets.symmetric(vertical: 13)),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        side: BorderSide(
                                          color: (value == false)
                                              ? Colors.white
                                              : mainColor,
                                        ))),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white)),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            fontFamily: 'Serif',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: deleterunning
                            ? null
                            : () async {
                                if (mounted) {
                                  setState(() {
                                    deleterunning = true;
                                  });
                                }

                                if (_deleteReason.text.isEmpty) {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: SnackBarContent(
                                            appreciation: "",
                                            sec: 3,
                                              error_text: "Please Enter Reason",
                                            
                                              icon: Icons.error),
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                        );
                                      });
                                } else {
                                  HomeService().createeditprofile(
                                      userid: userSave.email!,
                                      isBlur: false,
                                      editname: "Deleted by ${userSave.name}",
                                      aboutme: (userSave.About_Me == null ||
                                              userSave.About_Me == "")
                                          ? "Welcome to my profile. I'm here to find someone who appreciates authenticity and kindness. Hope you find what you're looking for."
                                          : userSave.About_Me!,
                                      mypreference: (userSave.Partner_Prefs ==
                                                  null ||
                                              userSave.Partner_Prefs == "")
                                          ? "I am looking for a meaningful connection based on mutual respect, trust and shared values. Someone who is ready to grow and learn with me on this journey I would like to Connect"
                                          : userSave.Partner_Prefs!,
                                      imageurls: userSave.imageUrls!);
                                  NotificationService().addtoadminnotification(
                                      userid: userSave.puid!,
                                      useremail: userSave.email!,
                                      subtitle: "DELETE",
                                      userimage: userSave.imageUrls!.isEmpty
                                          ? ""
                                          : userSave.imageUrls![0],
                                      title:
                                          "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} DELETE PROFILE ${_deleteReason.text}");
                                  NotificationFunction.setNotification(
                                    "admin",
                                    "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} DELETE PROFILE More",
                                    'accountdelete',
                                  );
                                  DatabaseReference dbref =
                                      FirebaseDatabase.instance.ref();
                                  dbref = dbref.child("onlineStatus");
                                  dbref.child(userSave.uid!).remove();
                                  await NotificationFunction.setOnlineStatus(
                                      userSave.uid!, "Offline");
                                  HomeService()
                                      .deleteaccount(
                                          email: userSave.email!,
                                          reasontodeleteuser:
                                              _deleteReason.text)
                                      .whenComplete(() async {
                                    await showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            content: SnackBarContent(
                                              appreciation: "",
                                              error_text:
                                                  "Profile Deleted Successfully",
                                              icon: Icons.check_circle,
                                              sec: 2,
                                            ),
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                          );
                                        });
                                    logout(
                                        context: context,
                                        noti: false,
                                        isLogout: true);
                                  });

                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.clear();
                                  sharedPreferences.setString("email", "");
                                  sharedPreferences.setString("location", "");
                                  Get.find<HomeService>().saveprefdata.value =
                                      NewSavePrefModel(
                                          email: "",
                                          ageList: [],
                                          citylocation: [],
                                          statelocation: [],
                                          id: "",
                                          v: 0,
                                          religionList: [],
                                          kundaliDoshList: [],
                                          maritalStatusList: [],
                                          dietList: [],
                                          drinkList: [],
                                          smokeList: [],
                                          disabilityList: [],
                                          heightList: [],
                                          educationList: [],
                                          professionList: [],
                                          incomeList: [],
                                          location: []);
                                  final user =
                                      FirebaseAuth.instance.currentUser;

                                  await user?.delete();
                                }
                                if (mounted) {
                                  setState(() {
                                    deleterunning = false;
                                  });
                                }
                              },
                      ),
                    ),
                  ],
                ),
                // ),
              ),
            )),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/shared_pref.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/data_collection/add_photos.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import '../../global_vars.dart' as glb;

class AboutMe extends StatefulWidget {
  const AboutMe({Key? key}) : super(key: key);

  @override
  State<AboutMe> createState() => _ReligionState();
}

class _ReligionState extends State<AboutMe> {
  int value = 0;
  var aboutMe = TextEditingController();
  var partnerPref = TextEditingController();
  String? puid;

  void setpuid() async {
    puid = await createPuid(userService.userdata["gender"]);

    setState(() {});
    print(puid);
  }

  @override
  void initState() {
    super.initState();
    setpuid();
  }

  // dynamic setData() async{
  //   // print(IncomeStatus);
  //   final docUser = FirebaseFirestore.instance
  //       .collection('user_data')
  //       .doc(uid);
  //   final prefs = await SharedPreferences.getInstance();
  //   final json = {
  //     'About_Me': aboutMe.text,
  //     'Partner_Prefs': partnerPref.text,
  //     // 'dob': dob
  //   };
  //   await prefs.setString('aboutme', aboutMe.text);
  //   await docUser.update(json).catchError((error) => print(error));
  // }
  dynamic setData() async {
    SharedPref sharedPref = SharedPref();
    final json2 = await sharedPref.read("uid");
    var uid = json2['uid'];

    // print(Kundali_Dosh);
    final docUser = FirebaseFirestore.instance.collection('user_data').doc(uid);
    try {
      User? userSave = User.fromJson(await sharedPref.read("user"));
      print(userSave.toString());
      userSave.puid = await createPuid(userSave.gender);
      userSave.About_Me = aboutMe.text;
      userSave.Partner_Prefs = partnerPref.text;
      print(userSave.toJson().toString());
      final json = userSave.toJson();
      await sharedPref.save("user", userSave);
      setState(() {
        glb.userSave = userSave;
      });
      await docUser.update(json).catchError((error) => print(error));
    } catch (Excepetion) {
      print(Excepetion);
    }
  }

  UserService userService = Get.put(UserService());
  createPuid(gender) {
    int time = DateTime.now().millisecondsSinceEpoch - 1640975400000;
    String res = "";
    while (time > 0) {
      int temp = time % 36;
      if (temp < 10) {
        res = temp.toString() + res;
      } else {
        res = String.fromCharCode('A'.codeUnitAt(0) + temp - 10) + res;
      }
      time = time ~/ 36;
    }

    if (gender == 'male') {
      return 'FRWM$res';
    } else {
      return 'FRWF$res';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: CustomAppBar(
            title: "Detail In Brief",
            iconImage: 'images/icons/user_rounded.png'),
        body: Material(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  /*crossAxisAlignment: CrossAxisAlignment.start,*/
                  children: [
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "About Me",
                              style: TextStyle(
                                  fontFamily: 'Sans-serif',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            TextField(
                              controller: aboutMe,
                              maxLength: 300,
                              // maxLengthEnforcement: MaxLengthEnforcement
                              // .enforced, // show error message
                              // maxLengthEnforcedMessage: 'You have reached the maximum character limit of 50',
                              minLines: 5,
                              maxLines: 7,
                              cursorColor: mainColor,
                              cursorWidth: 2,
                              style: TextStyle(
                                  fontFamily: 'Sans-serif', fontSize: 14),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: glb.mainColor)),
                                // hintText: 'User Name',
                                focusColor: mainColor,
                                floatingLabelStyle: TextStyle(color: mainColor),
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(color: Colors.grey),
                                label: Text(
                                  'Please Describe in Brief about yourself like \nOccupation,Education,Hobby,Interest,Family \nBackground Etc.\n(Note: Do Not Share Contact Detail Here)',
                                  //  style: TextStyle(color: newtextColor),
                                ),
                                // hintText:
                              ),
                              // decoration: InputDecoration(
                              //   border: OutlineInputBorder(
                              //       borderSide: new BorderSide(color: glb.main_color)),
                              //   focusedBorder: OutlineInputBorder(
                              //       borderSide: new BorderSide(color: glb.main_color)),
                              //   // labelText: 'Write Here',
                              // ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Partner Preference",
                              style: TextStyle(
                                  fontFamily: 'Sans-serif',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            TextField(
                              minLines: 5,
                              maxLines: 7,
                              cursorColor: mainColor,
                              cursorWidth: 2,
                              maxLength: 300,
                              // maxLengthEnforcement: MaxLengthEnforcement.enforced, // show error message
                              // maxLengthEnforcedMessage: 'You have reached the maximum character limit of 50',
                              style: TextStyle(
                                  fontFamily: 'Sans-serif', fontSize: 14),
                              controller: partnerPref,

                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: glb.mainColor)),
                                border: OutlineInputBorder(),
                                // hintText: 'Partner preference',r
                                //  labelStyle: TextStyle(color: main_color),
                                focusColor: mainColor,
                                floatingLabelStyle: TextStyle(color: mainColor),
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(color: Colors.grey),
                                label: Text(
                                  'Please Describe in Brief about Partner Preference \nLike Occupation,Education,Hobby,Interest,Family \nBackground, Location Etc. \n(Note: Do Not Share Contact Detail Here).',
                                  //  style: TextStyle(color: newtextColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.28,
                        // ),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.32,
                        // ),
                      ],
                    ),
                    SizedBox(
                      // margin: EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shadowColor: WidgetStateColor.resolveWith(
                                  (states) => Colors.black),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry?>(
                                      const EdgeInsets.symmetric(vertical: 17)),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60.0),
                                      side: BorderSide(
                                        color: (color_done2 == false)
                                            ? Colors.white
                                            : glb.mainColor,
                                      ))),
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.white)),
                          onPressed: () async {
                            setState(() {
                              color_done2 = true;
                            });
                            // setData();
                            userService.userdata.addAll({
                              "aboutme": aboutMe.text,
                              "patnerpref": partnerPref.text,
                              "puid": puid
                            });
                            print(userService.userdata);
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 0),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 0),
                                    pageBuilder: (_, __, ___) =>
                                        const AddPics()));
                          },
                          child: Text(
                            "Continue",
                            style: (color_done2 == false)
                                ? const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Serif',
                                    fontWeight: FontWeight.w700)
                                : TextStyle(
                                    color: glb.mainColor,
                                    fontSize: 20,
                                    fontFamily: 'Serif',
                                    fontWeight: FontWeight.w700),
                          )),
                    ),
                  ])),
        ),
      ),
    );
  }

  bool color_done2 = false;
}

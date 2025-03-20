import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/data_collection/mannual_education.dart';
import 'package:ristey/screens/data_collection/profession.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';

import '../../models/shared_pref.dart';

import '../notification/Widget_Notification/ads_bar.dart';

String? EducationStatus;

class Education extends StatefulWidget {
  const Education({Key? key}) : super(key: key);

  @override
  State<Education> createState() => _ReligionState();
}

class _ReligionState extends State<Education> {
  int value = 0;
  List<AdsModel> allads = [];
  void getallads() async {
    allads = await AdsService().getallusers(adsid: "3");
    setState(() {});
  }

  @override
  void initState() {
    getallads();
    super.initState();
  }

  UserService userService = Get.put(UserService());
  Widget CustomRadioButton(String text, int index) {
    return ElevatedButton(
      onPressed: () {
        if (text == "Other") {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 0),
                  reverseTransitionDuration: const Duration(milliseconds: 0),
                  pageBuilder: (_, __, ___) => const MannualEducation()));
          if (allads.isNotEmpty) {
            showadsbar(context, allads, () {
              Navigator.pop(context);
            });
          }
        } else {
          setState(() {
            EducationStatus = text;
            value = index;
          });
          // setData();
          userService.userdata.addAll({"education": EducationStatus});
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 0),
                  reverseTransitionDuration: const Duration(milliseconds: 0),
                  pageBuilder: (_, __, ___) => const Profession()));
        }
      },
      style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
              const EdgeInsets.symmetric(vertical: 15)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0),
                  side: BorderSide(
                      color: (value == index) ? mainColor : Colors.white))),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white)),
      child: Text(
        text,
        style: TextStyle(
          color: (value == index) ? mainColor : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
          appBar:CustomAppBar(title: "Education", iconImage: 'images/icons/education.png'),
          body: SingleChildScrollView(
            child: Column(
              children: [
               
                Center(
                    child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("No Education", 1)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Secondary", 2)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Senior Secondary", 3)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Diploma", 11)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Graduation", 4)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Post Graduation", 5)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("B.Ed", 6)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("M.Phil", 7)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Ph.D", 8)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("MBBS", 9)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Other", 10)),
                        const SizedBox(
                          height: 10,
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

dynamic setData() async {
  SharedPref sharedPref = SharedPref();
  final json2 = await sharedPref.read("uid");
  var uid = json2['uid'];
  print(EducationStatus);
  final docUser = FirebaseFirestore.instance.collection('user_data').doc(uid);
  try {
    User? userSave = User.fromJson(await sharedPref.read("user"));
    print(userSave.toString());

    userSave.Education = EducationStatus;
    print(userSave.toJson().toString());
    final json = userSave.toJson();
    await sharedPref.save("user", userSave);
    await docUser.update(json).catchError((error) => print(error));
  } catch (Excepetion) {
    print(Excepetion);
  }
}

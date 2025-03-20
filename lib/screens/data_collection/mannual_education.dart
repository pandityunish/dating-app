import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/data_collection/profession.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';

import '../notification/Widget_Notification/ads_bar.dart';

class MannualEducation extends StatefulWidget {
  const MannualEducation({super.key});

  @override
  State<MannualEducation> createState() => _MannualEducationState();
}

class _MannualEducationState extends State<MannualEducation> {
  TextEditingController name = TextEditingController();
  final _focusNode1 = FocusNode();
  UserService userService = Get.put(UserService());
  List<AdsModel> allads = [];
  void getallads() async {
    allads = await AdsService().getallusers(adsid: "4");
    setState(() {});
  }

  @override
  void initState() {
    getallads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
          appBar:CustomAppBar(title: "Other Education", iconImage: 'images/icons/education.png'), 
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                 
                    Center(
                        child: Container(
                      // height: MediaQuery.of(context).size.height * 0.85,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                           Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: TextField(
                                  // height: 20.0,
                                  
                                  maxLength: 15,
                                maxLines: 1,
                                                                
                                  maxLengthEnforcement: MaxLengthEnforcement
                                      .enforced, // show error message
                                  // maxLengthEnforcedMessage: 'You have reached the maximum character limit of 50',
                                  
                                  focusNode: _focusNode1,
                                  controller: name,
                                  decoration: InputDecoration(
                                    hintText: "Enter Education",
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
                                  onChanged: (name) => {
                                   
                                  },
                                ),
                              ),
                            SizedBox(
                              height: Get.height * 0.5,
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  // margin: EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.black),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
                              const EdgeInsets.symmetric(vertical: 17)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60.0),
                                      side: const BorderSide(
                                        color: Colors.white,
                                      ))),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      onPressed: () async {
                        if (name.text.isEmpty) {
                          await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: SnackBarContent(
                                    appreciation: "",
                                    error_text: "Please Enter Education",
                                    icon: Icons.error,
                                    sec: 2,
                                  ),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                );
                              });
                        } else {
                          userService.userdata.addAll({"education": name.text});
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 0),
                                  reverseTransitionDuration:
                                      const Duration(milliseconds: 0),
                                  pageBuilder: (_, __, ___) =>
                                      const Profession()));
                          if (allads.isNotEmpty) {
                            showadsbar(context, allads, () {
                              Navigator.pop(context);
                            });
                          }
                        }
                        // if(key.currentState!.validate()){

                        // if(landmarkssug.contains(birthPlaceController.text)){
                        //   print(birthPlaceController.text);
                        // }
                        // if(key.currentState!.validate()){
                        // print(phone_num.length);
                        // onpressed();
                        // }

                        // print(phone_num.length);
                        //              selectedhours="Hours";
                        //  selectedminutes="Minutes";

                        // }

                        // print(birthPlaceController.text);
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Serif'),
                      )),
                ),
              ],
            ),
          )),
    );
  }
}

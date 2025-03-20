import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/data_collection/kundali_dosh.dart';
import 'package:ristey/screens/data_collection/lets_start.dart';
import 'package:ristey/screens/data_collection/maritial_status.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';

import '../../models/shared_pref.dart';

String? religion_text;

class Religion extends StatefulWidget {
  final String User_Name;
  final String User_SurName;
  final String age;
  final String timeofbirth;
  final String phone_num;
  final String placeofbirth;
  final String gender;
  final int dob;
  const Religion(
      {Key? key,
      required this.User_Name,
      required this.User_SurName,
      required this.age,
      required this.timeofbirth,
      required this.phone_num,
      required this.placeofbirth,
      required this.gender,
      required this.dob})
      : super(key: key);

  @override
  State<Religion> createState() => _ReligionState();
}

class _ReligionState extends State<Religion> {
  int value = 0;
  UserService userService = Get.put(UserService());
  Widget CustomRadioButton(String text, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          religion_text = text;
          value = index;
          // setData();
          userService.userdata.addAll({
            "religion": religion_text,
            "name": widget.User_Name,
            "surname": widget.User_SurName,
            "age": widget.age,
            "phone": widget.phone_num,
            "dob": widget.dob,
            "gender": widget.gender,
            "timeofbirth": widget.timeofbirth,
            "placeofbirth": widget.placeofbirth
          });
          print(widget.timeofbirth);
          // print(text);
          selectedhours = "Hours";
          selectedminutes = "Minutes";
        });
        UserService().createincompleteprofilebyregister(
            aboutme: "",
            diet: "",
            disability: "",
            drink: "",
            education: "",
            height: "",
            income: "",
            patnerprefs: "",
            smoke: "",
            displayname: widget.User_Name,
            email: userSave.email!,
            religion: religion_text!,
            name: widget.User_Name,
            surname: widget.User_SurName,
            phone: widget.phone_num,
            gender: widget.gender,
            kundalidosh: "",
            martialstatus: "",
            profession: "",
            location: "Ghazni",
            city: "Ghazni",
            state: "Afghanistan",
            imageurls: [],
            blocklists: [],
            reportlist: [],
            shortlist: [],
            country: "",
            token: "",
            age: "",
            lat: 33.5471303,
            lng: 68.4221352,
            timeofbirth: widget.timeofbirth,
            placeofbirth: widget.placeofbirth,
            puid: "",
            dob: 32323);
        if (text == "Hindu") {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 0),
                  reverseTransitionDuration: const Duration(milliseconds: 0),
                  pageBuilder: (_, __, ___) => const Kundali_Dosh()));
        } else {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 0),
                  reverseTransitionDuration: const Duration(milliseconds: 0),
                  pageBuilder: (_, __, ___) => const MStatus()));
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
        
         appBar: PreferredSize(
  preferredSize: const Size.fromHeight(115), // Adjust AppBar height
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
      padding: const EdgeInsets.only(top: 0), // Adjust padding for alignment
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              const AssetImage('images/icons/religion.png'),
              size: 30,
              color: mainColor,
            ),
            const SizedBox(
              height: 8,
            ),
             DefaultTextStyle(
              style: TextStyle(
                color: mainColor,
                fontFamily: 'Sans-serif',
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
              child: Text("Religion"),
            ),
          ],
        ),
      ),
    ),
  ),
),

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
                            child: CustomRadioButton("Hindu", 1)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Muslim", 2)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Sikh", 3)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Christian", 4)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Buddhist", 5)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Jewish", 6)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Parsi", 7)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Atheist", 8)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Non Religious", 9)),
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

dynamic Run(text) {
  if (text == "Hindu") {
    // Navigator.of(context).push(MaterialPageRoute(builder: (builder) => Kundali_Dosh()));
  }
}

dynamic setData() async {
  SharedPref sharedPref = SharedPref();
  final json2 = await sharedPref.read("uid");
  var uid = json2['uid'];

  print(religion_text);
  final docUser = FirebaseFirestore.instance.collection('user_data').doc(uid);

  // final json = {
  //   'religion': religion_text,
  //   // 'dob': dob
  // };
  // User? userSave;
  try {
    User? userSave = User.fromJson(await sharedPref.read("user"));
    print(userSave.toString());

    userSave.religion = religion_text;
    print(userSave.toJson().toString());
    final json = userSave.toJson();
    userSave = userSave;
    await sharedPref.save("user", userSave);
    await docUser.update(json).catchError((error) => print(error));
  } catch (Excepetion) {
    print(Excepetion);
  }
}

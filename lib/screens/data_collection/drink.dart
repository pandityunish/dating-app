import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/data_collection/smoke.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';

import '../../models/shared_pref.dart';
import 'custom_appbar.dart';

String? DrinkStatus;

class Drink extends StatefulWidget {
  const Drink({Key? key}) : super(key: key);

  @override
  State<Drink> createState() => _ReligionState();
}

class _ReligionState extends State<Drink> {
  int value = 0;
  UserService userService = Get.put(UserService());
  Widget CustomRadioButton(String text, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          DrinkStatus = text;
          value = index;
        });
        // setData();
        userService.userdata.addAll({"drink": DrinkStatus});
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 0),
                reverseTransitionDuration: const Duration(milliseconds: 0),
                pageBuilder: (_, __, ___) => const Smoke()));
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
          appBar:CustomAppBar(title: "Drink", iconImage: 'images/icons/drink.png'), 
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
                            child: CustomRadioButton("Yes", 1)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("No", 2)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomRadioButton("Occasionally", 3)),
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
  print(DrinkStatus);
  final docUser = FirebaseFirestore.instance.collection('user_data').doc(uid);
  try {
    User? userSave = User.fromJson(await sharedPref.read("user"));
    print(userSave.toString());

    userSave.Drink = DrinkStatus;
    print(userSave.toJson().toString());
    final json = userSave.toJson();
    await sharedPref.save("user", userSave);
    await docUser.update(json).catchError((error) => print(error));
  } catch (Excepetion) {
    print(Excepetion);
  }
}

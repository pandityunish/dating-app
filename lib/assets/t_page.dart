import 'package:flutter/material.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/data_collection/diet.dart';
import 'package:ristey/screens/data_collection/disability.dart';
import 'package:ristey/screens/data_collection/drink.dart';
import 'package:ristey/screens/data_collection/education.dart';
import 'package:ristey/screens/data_collection/height.dart';
import 'package:ristey/screens/data_collection/income.dart';
import 'package:ristey/screens/data_collection/kundali_dosh.dart';
import 'package:ristey/screens/data_collection/lets_start.dart';
import 'package:ristey/screens/data_collection/location.dart';
import 'package:ristey/screens/data_collection/maritial_status.dart';
import 'package:ristey/screens/data_collection/profession.dart';
import 'package:ristey/screens/data_collection/smoke.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';

import '../models/shared_pref.dart';

class Tpage {
  static Future<void> transferPage(context, var pname) async {
    SharedPref sharedPref = SharedPref();

    print("transfer Page running ......");
    try {
      User userSave = User.fromJson(await sharedPref.read("user"));
      print("userSave : $userSave");
      if (userSave.name != "") {
        if (userSave.religion != "") {
          if (userSave.religion == "Hindu" && userSave.KundaliDosh == "") {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Kundali_Dosh()));
          } else if ((userSave.religion == "Hindu" &&
                  userSave.KundaliDosh != "") ||
              (userSave.religion != "Hindu")) {
            if (userSave.MartialStatus != "") {
              if (userSave.Diet != "") {
                if (userSave.Drink != "") {
                  if (userSave.Smoke != "") {
                    if (userSave.Disability != "") {
                      if (userSave.Height != "") {
                        if (userSave.Education != "") {
                          if (userSave.Profession != "") {
                            if (userSave.Income != "") {
                              if (userSave.Location != "") {
                                // if (userSave.About_Me != "" &&
                                //     userSave.Partner_Prefs != ""&& userSave.imageUrls!=null && userSave.imageUrls!.isEmpty) {
                                // if () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (builder) => MainAppContainer(
                                              notiPage: false,
                                            )),
                                    (route) => false);
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (builder) => Location1()));
                              }
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Income()));
                            }
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Profession()));
                          }
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Education()));
                        }
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Height()));
                      }
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Disability()));
                    }
                  } else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Smoke()));
                  }
                } else {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Drink()));
                }
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Diet()));
              }
            } else {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MStatus()));
            }
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const MStatus()));
          }
        } else {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => Religion()));
        }
      }
      if (userSave.name != null && pname != "main") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LetsStart()));
      }
    } catch (Excepetion) {
      print(Excepetion);
    }
  }
}

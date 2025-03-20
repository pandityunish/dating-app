import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/screens/search_profile/function_search.dart';
import 'package:ristey/screens/search_profile/search_dynamic_page.dart';
import 'package:ristey/send_utils/noti_function.dart';
import 'package:ristey/services/add_to_profile_service.dart';
// import 'dart:core';
import '../../Assets/Error.dart';

import '../profile/service/notification_service.dart';

class SearchPreferences extends StatefulWidget {
  const SearchPreferences({Key? key}) : super(key: key);

  @override
  State<SearchPreferences> createState() => _SearchPreferencesState();
}

class _SearchPreferencesState extends State<SearchPreferences> {
  var startValue = 0.0;
  SearchDataList sdl = SearchDataList();
  SavedPref svp = SavedPref();
  var endValue = 0.0;
  HomeService homeservice = Get.put(HomeService());
  bool isloading = false;
  void getheight() {
    isloading = true;
    setState(() {});
    if (homeservice.saveprefdata.value.heightList.isNotEmpty) {
      String minheight =
          sdl.Height.indexOf(homeservice.saveprefdata.value.heightList[0])
              .toString();
      String maxheight =
          sdl.Height.indexOf(homeservice.saveprefdata.value.heightList[1])
              .toString();
      homeservice.saveprefdata.value.heightList.clear();

      homeservice.saveprefdata.value.heightList.add(minheight);
      homeservice.saveprefdata.value.heightList.add(maxheight);
      setState(() {});
      print("${homeservice.saveprefdata.value.heightList} elkjaf;lksdj");
    }
  }

  List<AdsModel> searchads = [];
  List<AdsModel> resetsearchads = [];
  List<AdsModel> usersavedads = [];
  void getads() async {
    searchads = await AdsService().getallusers(adsid: "31");
    resetsearchads = await AdsService().getallusers(adsid: "32");
    usersavedads = adsuser.where((element) => element.adsid == "31").toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getads();
    homeservice.getusersaveprefdata().whenComplete(() {
      getheight();
      print(homeservice.saveprefdata.value.citylocation);
      if (homeservice.saveprefdata.value.location.isNotEmpty) {
        for (var i = 0;
            i < homeservice.saveprefdata.value.location.length;
            i++) {
          svp.LocatioList[0]
              .add(homeservice.saveprefdata.value.location[i].toString());
        }

        setState(() {});
      }
      if (homeservice.saveprefdata.value.statelocation.isNotEmpty) {
        for (var i = 0;
            i < homeservice.saveprefdata.value.statelocation.length;
            i++) {
          svp.LocatioList[1]
              .add(homeservice.saveprefdata.value.statelocation[i].toString());
        }
      }
      if (homeservice.saveprefdata.value.citylocation.isNotEmpty) {
        for (var i = 0;
            i < homeservice.saveprefdata.value.citylocation.length;
            i++) {
          svp.LocatioList[2]
              .add(homeservice.saveprefdata.value.citylocation[i].toString());
        }
      }
      selectedCity!.clear();
      selectedCounty!.clear();
      selectedState!.clear();
      for (var i = 0;
          i < homeservice.saveprefdata.value.citylocation.length;
          i++) {
        selectedCity!
            .add({"name": homeservice.saveprefdata.value.citylocation[i]});
      }
      for (var i = 0; i < homeservice.saveprefdata.value.location.length; i++) {
        selectedCounty!
            .add({"name": homeservice.saveprefdata.value.location[i]});
      }
      for (var i = 0;
          i < homeservice.saveprefdata.value.statelocation[0].length;
          i++) {
        selectedState!
            .add({"name": homeservice.saveprefdata.value.statelocation[i]});
      }
    });
    setState(() {});
    setsvp();

    borderColor = false;
    borderColor2 = false;
  }

  bool borderColor = false;
  bool borderColor2 = false;
  setsvp() async {
    var json = await sharedPref.read("savedPref");
    if (json != null) {
      if (!mounted) return;
      setState(() {
        svp = SavedPref.fromJson(json);
      });
    }
  }

  nameContainer(icon, String head, List<dynamic> val, List<dynamic> options) {
    //val for return value list and options for showing options in dialog
    return Padding(
     padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                ImageIcon(
                  AssetImage(icon),
                  size: 20,
                  color: mainColor,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    head,
                    style: GoogleFonts.poppins(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              var ds = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => DynamicPage(
                      icon: icon,
                      head: head,
                      options: options,
                      selectedopt: val)));
              if (ds != "cancel") {
                if (!mounted) return;
                setState(() {
                  val.clear();
                });
                for (var i = 0; i < ds.length; i++) {
                  if (!mounted) return;
                  setState(() {
                    val.add(ds[i]);
                  });
                }
              }
            },
            child: Row(
              children: [
                (val.isEmpty)
                    ? Text(
                        "Add",
                        style: GoogleFonts.poppins(
                            decoration: TextDecoration.none,
                            color: Colors.black38,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )
                    : val.contains("Any")
                        ? Text(
                            "Any",
                            style: GoogleFonts.poppins(
                                decoration: TextDecoration.none,
                                color: Colors.black38,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        : SizedBox(
                            width: 80,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      val.toString().substring(
                                          1, val.toString().length - 1),
                                      style: GoogleFonts.poppins(
                                          decoration: TextDecoration.none,
                                          color: Colors.black38,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )),
                          ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black38,
                  size: 16,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  nameContainer2(icon, String head, Function tap, List<dynamic> val) {
    // onTap = AgeDialog();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                ImageIcon(
                  AssetImage(icon),
                  size: 20,
                  color: mainColor,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    head,
                    style: const TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Sans-serif'),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              var ds = await tap(context, val);
      
              if (ds != null) {
                print("$ds kjsl");
                // if (!mounted) return;
                if (val.isNotEmpty) {
                  setState(() {
                    val.clear();
                  });
                  setState(() {
                    homeservice.saveprefdata.value.ageList.addAll(ds);
                    //  val.addAll(ds);
                  });
                } else {
                  setState(() {
                    homeservice.saveprefdata.value.ageList.addAll(ds);
                    val.addAll(ds);
                  });
                }
      
                // for (var i = 0; i < ds.length; i++) {
                //   if (!mounted) return;
                //   setState(() {
                //     val.add(ds[i]);
                //   });
                // }
              }
            },
            child: Row(
              children: [
                (val.isEmpty)
                    ? Text(
                        "Add",
                        style: GoogleFonts.poppins(
                            decoration: TextDecoration.none,
                            color: Colors.black38,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )
                    : (head == "Location")
                        ? SizedBox(
                            width: 150,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      val.toString().substring(
                                          1, val.toString().length - 1),
                                      style: GoogleFonts.poppins(
                                          decoration: TextDecoration.none,
                                          color: Colors.black38,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )),
                          )
                        : SizedBox(
                            width: 65,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      "${val[0]} - ${val[1]}",
                                      style: GoogleFonts.poppins(
                                          decoration: TextDecoration.none,
                                          color: Colors.black38,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )),
                          ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black38,
                  size: 16,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  nameContainer3(icon, String head, Function tap, List<dynamic> val) {
    // onTap = AgeDialog();
    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                ImageIcon(
                  AssetImage(icon),
                  size: 20,
                  color: mainColor,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    head,
                    style: const TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Sans-serif'),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              var ds = await tap(context, val);
              print(ds.toString());
              if (ds != null) {
                if (!mounted) return;
                setState(() {
                  val.clear();
                });
                for (var element in ds) {
                  if (!mounted) return;
                  setState(() {
                    val.add(element);
                  });
                }
                // setState(() {
                //   val.add(ds[]);
                // });
                // }
              }
            },
            child: Row(
              children: [
                (val[0].isEmpty && val[1].isEmpty && val[2].isEmpty)
                    ? const Text(
                        "Add",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black38,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Sans-serif'),
                      )
                    : (val[0].isNotEmpty &&
                            val[1].isNotEmpty &&
                            val[2].isNotEmpty)
                        ? SizedBox(
                            width: Get.width * 0.2,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                "${val[0][0].toString()} ${val[0].length > 1 ? " +${val[0].length - 1}" : ""},${val[1][0].toString()}${val[1].length > 1 ? " +${val[1].length - 1}" : ""},${val[2][0].toString()}${val[2].length > 1 ? " +${val[2].length - 1}" : ""}",
                                style: GoogleFonts.poppins(
                                  decoration: TextDecoration.none,
                                  color: Colors.black38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          )
                        : (val[0].isNotEmpty && val[1].isNotEmpty)
                            ? SizedBox(
                                width: Get.width * 0.2,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    "${val[0][0].toString()},${val[1][0].toString()}",
                                    style: GoogleFonts.poppins(
                                      decoration: TextDecoration.none,
                                      color: Colors.black38,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              )
                            : (val[0].isNotEmpty && val[2].isNotEmpty)
                                ? SizedBox(
                                    width: Get.width * 0.2,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        "${val[0][0].toString()},${val[2][0].toString()}",
                                        style: GoogleFonts.poppins(
                                          decoration: TextDecoration.none,
                                          color: Colors.black38,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  )
                                : (val[0].isNotEmpty)
                                    ? Text(
                                        (val[0].length > 1)
                                            ? "${val[0][0].toString()} +${val[0].length - 1}"
                                            : val[0][0].toString(),
                                        style: GoogleFonts.poppins(
                                          decoration: TextDecoration.none,
                                          color: Colors.black38,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    : (val[1].isNotEmpty)
                                        ? Text(
                                            (val[1].length > 1)
                                                ? "${val[1][0].toString()} +${val[1].length - 1}"
                                                : val[1][0].toString(),
                                            style: GoogleFonts.poppins(
                                                decoration: TextDecoration.none,
                                                color: Colors.black38,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : Text(
                                            (val[2].length > 1)
                                                ? "${val[2][0].toString()} +${val[2].length - 1}"
                                                : val[2][0].toString(),
                                            style: GoogleFonts.poppins(
                                                decoration: TextDecoration.none,
                                                color: Colors.black38,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black38,
                  size: 16,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  nameContainerHeight(icon, String head, Function tap, List<dynamic> val,
      List<String> options) {
    // onTap = AgeDialog();
    return Padding(
     padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                ImageIcon(
                  AssetImage(icon),
                  size: 20,
                  color: mainColor,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    head,
                    style: const TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Sans-serif'),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              var ds = await tap(context, val);
              print("$ds hello");
              if (ds != null) {
                // setState(() {
                val.clear();
                // });
                svp.HeightList.addAll(ds);
                print(svp.HeightList);
                for (var i = 0; i < ds.length; i++) {
                  setState(() {
                    val.add(ds[i]);
                  });
                }
              }
            },
            child: Row(
              children: [
                (val.isEmpty)
                    ? Text(
                        "Add",
                        style: GoogleFonts.poppins(
                            decoration: TextDecoration.none,
                            color: Colors.black38,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )
                    : (head == "Location")
                        ? SizedBox(
                            width: 150,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      val.toString().substring(
                                          1, val.toString().length - 1),
                                      style: GoogleFonts.poppins(
                                          decoration: TextDecoration.none,
                                          color: Colors.black38,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )),
                          )
                        : SizedBox(
                            width: 110,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      "${options[int.parse(val[0])].substring(0, 4)}-${options[int.parse(val[1])]}",
                                      style: GoogleFonts.poppins(
                                          decoration: TextDecoration.none,
                                          color: Colors.black38,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )),
                          ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black38,
                  size: 16,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void addvalue() {
    selectedCity!.clear();
    selectedCounty!.clear();
    selectedState!.clear();
    for (var i = 0; i < svp.LocatioList[2].length; i++) {
      selectedCity!.add({"name": svp.LocatioList[2][i]});
    }
    for (var i = 0; i < svp.LocatioList[0].length; i++) {
      selectedCounty!.add({"name": svp.LocatioList[0][i]});
    }
    for (var i = 0; i < svp.LocatioList[1].length; i++) {
      selectedState!.add({"name": svp.LocatioList[1][i]});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
//     List<String> stringList = homeservice.saveprefdata.value.ageList
//         .map((dynamic item) => item.toString())
//         .toList();
    print(svp.LocatioList);
    //  addvalue();
    print(svp.AgeList);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
          appBar:CustomAppBar(title: "Saved Preference", iconImage: "images/icons/filter.png") ,
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 10, right: 15),
              child: isloading == false
                  ? SizedBox(
                      height: Get.height,
                      width: Get.width,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      ),
                    )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       
                       Expanded(
                         child: Column(
                          
                          children: [
                             nameContainer2(
                              'images/icons/calender.png',
                              "Age",
                              functions().AgeDialog,
                              homeservice.saveprefdata.value.ageList),
                          nameContainer(
                              'images/icons/religion.png',
                              "Religion",
                              homeservice.saveprefdata.value.religionList,
                              sdl.Religion),
                          (userSave.religion == "Hindu")
                              ? nameContainer(
                                  'images/icons/kundli.png',
                                  "Kundli Dosh",
                                  homeservice
                                      .saveprefdata.value.kundaliDoshList,
                                  sdl.KundaliDosh)
                              : Container(),
                          nameContainer(
                              'images/icons/marital_status.png',
                              "Marital Status",
                              homeservice.saveprefdata.value.maritalStatusList,
                              sdl.MaritalStatus),
                          nameContainer(
                              'images/icons/food.png',
                              "Diet",
                              homeservice.saveprefdata.value.dietList,
                              sdl.Diet),
                          nameContainer(
                              'images/icons/smoke.png',
                              "Smoke",
                              homeservice.saveprefdata.value.smokeList,
                              sdl.Smoke),
                          nameContainer(
                              'images/icons/drink.png',
                              "Drink",
                              homeservice.saveprefdata.value.drinkList,
                              sdl.Drink),
                          nameContainer(
                              'images/icons/disability.png',
                              "Disability With Person",
                              homeservice.saveprefdata.value.disabilityList,
                              sdl.Disability),
                          nameContainerHeight(
                              'images/icons/height.png',
                              "Height",
                              functions().HeightDialog,
                              homeservice.saveprefdata.value.heightList,
                              sdl.Height),
                         
                          nameContainer(
                              'images/icons/education.png',
                              "Education",
                              homeservice.saveprefdata.value.educationList,
                              sdl.Education),
                          nameContainer(
                              'images/icons/profession_suitcase.png',
                              "Profession",
                              homeservice.saveprefdata.value.professionList,
                              sdl.Profession),
                          nameContainer(
                              'images/icons/hand_rupee.png',
                              "Annual Income",
                              homeservice.saveprefdata.value.incomeList,
                              sdl.Income),
                          nameContainer3(
                              'images/icons/location.png',
                              "Location",
                              functions().LocationDialog,
                              svp.LocatioList),
                          ],
                         ),
                       ),
                        // SizedBox(
                        //   height: 100,
                        // ),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shadowColor: WidgetStateColor.resolveWith(
                                      (states) => Colors.black),
                                  // padding:
                                  //     MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                  //         EdgeInsets.symmetric(vertical: 17)),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                          side: BorderSide(
                                            color: borderColor
                                                ? mainColor
                                                : Colors.white,
                                          ))),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.white)),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                  fontFamily: 'Serif',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () async {
                                borderColor2 = true;
                                if (svp.LocatioList[2]
                                    .contains("United States")) {
                                  svp.LocatioList[2].clear();
                                  svp.LocatioList[2].add("USA");
                                  setState(() {});
                                }
                                //
                                NotificationService().addtonotification(
                                    email: userSave.email!,
                                    title: "SAVED PREFERENCE SUCCESSFULLY");
                                NotificationService().addtoadminnotification(
                                    userid: userSave.uid!,
                                    subtitle: "Profile Create",
                                    useremail: userSave.email!,
                                    userimage: userSave.imageUrls!.isEmpty
                                        ? ""
                                        : userSave.imageUrls![0],
                                    title:
                                        "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SAVED PREFERENCE SUCCESSFULLY ");
                                print(homeservice
                                    .saveprefdata.value.statelocation);
                                homeservice.createsavepref(
                                    ageList: homeservice
                                        .saveprefdata.value.ageList,
                                    religionList: homeservice
                                        .saveprefdata.value.religionList,
                                    citylocation: svp.LocatioList[2].isEmpty
                                        ? homeservice
                                            .saveprefdata.value.citylocation
                                        : svp.LocatioList[2],
                                    statelocation: svp.LocatioList[1].isEmpty
                                        ? homeservice
                                            .saveprefdata.value.statelocation
                                        : svp.LocatioList[1],
                                    kundaliDoshList: homeservice
                                        .saveprefdata.value.kundaliDoshList,
                                    maritalStatusList: homeservice
                                        .saveprefdata.value.maritalStatusList,
                                    heightList: homeservice.saveprefdata.value
                                            .heightList.isEmpty
                                        ? []
                                        : [
                                            "${sdl.Height[int.parse(homeservice.saveprefdata.value.heightList[0])].substring(0, 4)}Feet",
                                            (sdl.Height[int.parse(homeservice
                                                .saveprefdata
                                                .value
                                                .heightList[1])])
                                          ],
                                    smokeList: homeservice
                                        .saveprefdata.value.smokeList,
                                    drinkList: homeservice
                                        .saveprefdata.value.drinkList,
                                    disabilityList: homeservice
                                        .saveprefdata.value.disabilityList,
                                    dietList: homeservice
                                        .saveprefdata.value.dietList,
                                    educationList: homeservice
                                        .saveprefdata.value.educationList,
                                    professionList: homeservice
                                        .saveprefdata.value.professionList,
                                    incomeList: homeservice
                                        .saveprefdata.value.incomeList,
                                    location: svp.LocatioList[0].isEmpty
                                        ? homeservice
                                            .saveprefdata.value.location
                                        : svp.LocatioList[0]);
                                AddToProfileService().addtosavedprefprofile(
                                    ageList: homeservice
                                        .saveprefdata.value.ageList,
                                    name: userSave.name!,
                                    religionList: homeservice
                                        .saveprefdata.value.religionList,
                                    citylocation: svp.LocatioList[2].isEmpty
                                        ? homeservice
                                            .saveprefdata.value.citylocation
                                        : svp.LocatioList[2],
                                    statelocation: svp.LocatioList[1].isEmpty
                                        ? homeservice
                                            .saveprefdata.value.statelocation
                                        : svp.LocatioList[1],
                                    kundaliDoshList: homeservice
                                        .saveprefdata.value.kundaliDoshList,
                                    maritalStatusList: homeservice
                                        .saveprefdata.value.maritalStatusList,
                                    heightList: homeservice.saveprefdata.value
                                            .heightList.isEmpty
                                        ? []
                                        : [
                                            "${sdl.Height[int.parse(homeservice.saveprefdata.value.heightList[0])].substring(0, 4)}Feet",
                                            (sdl.Height[int.parse(homeservice
                                                .saveprefdata
                                                .value
                                                .heightList[1])])
                                          ],
                                    smokeList: homeservice
                                        .saveprefdata.value.smokeList,
                                    drinkList: homeservice
                                        .saveprefdata.value.drinkList,
                                    disabilityList: homeservice
                                        .saveprefdata.value.disabilityList,
                                    dietList: homeservice
                                        .saveprefdata.value.dietList,
                                    educationList: homeservice
                                        .saveprefdata.value.educationList,
                                    professionList: homeservice
                                        .saveprefdata.value.professionList,
                                    incomeList: homeservice
                                        .saveprefdata.value.incomeList,
                                    location: svp.LocatioList[0].isEmpty
                                        ? homeservice
                                            .saveprefdata.value.location
                                        : svp.LocatioList[0]);
              
                                await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        content: SnackBarContent(
                                          error_text:
                                              "Preference Save Successfully",
                                          appreciation: "",
                                          icon: Icons.check,
                                          sec: 3,
                                        ),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      );
                                    });
                                SupprotService().deletesendlink(
                                    email: userSave.email!,
                                    value: "To Save Preference");
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MainAppContainer(
                                              notiPage: false,
                                            )),
                                    (route) => false);
                                if (searchads.isNotEmpty) {
                                  showadsbar(context, searchads, () async {
                                    Get.back();
                                  });
                                } else if (usersavedads.isNotEmpty) {
                                  showadsbar(context, usersavedads, () async {
                                    Get.back();
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shadowColor: WidgetStateColor.resolveWith(
                                      (states) => Colors.black),
                                  // padding:
                                  //     MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                  //         EdgeInsets.symmetric(vertical: 17)),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                          side: BorderSide(
                                            color: borderColor
                                                ? mainColor
                                                : Colors.white,
                                          ))),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.white)),
                              child: const Text(
                                "Reset",
                                style: TextStyle(
                                  fontFamily: 'Serif',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () async {
                                NotificationService().addtonotification(
                                    email: userSave.email!,
                                    title: "RESET PREFERENCE SUCCESSFULLY");
                                NotificationService().addtoadminnotification(
                                    userid: userSave.uid!,
                                    subtitle: "Profile Create",
                                    useremail: userSave.email!,
                                    userimage: userSave.imageUrls!.isEmpty
                                        ? ""
                                        : userSave.imageUrls![0],
                                    title:
                                        "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} PREFERENCE RESET SUCCESSFULLY ");
                                if (!mounted) return;
                                setState(() {
                                  svp = SavedPref();
                                });
                                // saveData();
                                print(svp.ReligionList);
                                homeservice.createsavepref(
                                    ageList: [],
                                    religionList: [],
                                    kundaliDoshList: [],
                                    maritalStatusList: [],
                                    citylocation: [],
                                    statelocation: [],
                                    heightList: [],
                                    smokeList: [],
                                    drinkList: [],
                                    disabilityList: [],
                                    dietList: [],
                                    educationList: [],
                                    professionList: [],
                                    incomeList: [],
                                    location: []);
                                AddToProfileService().addtosavedprefprofile(
                                    ageList: [],
                                    religionList: [],
                                    citylocation: [],
                                    statelocation: [],
                                    name: "${userSave.name} reset",
                                    kundaliDoshList: [],
                                    maritalStatusList: [],
                                    heightList: [],
                                    smokeList: [],
                                    drinkList: [],
                                    disabilityList: [],
                                    dietList: [],
                                    educationList: [],
                                    professionList: [],
                                    incomeList: [],
                                    location: []);
                                await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        content: SnackBarContent(
                                          error_text:
                                              "Preference Reset Successfully",
                                          appreciation: "",
                                          icon: Icons.check,
                                          sec: 3,
                                        ),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      );
                                    });
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MainAppContainer(
                                              notiPage: false,
                                            )),
                                    (route) => false);
                                if (resetsearchads.isNotEmpty) {
                                  showadsbar(context, resetsearchads,
                                      () async {
                                    Get.back();
                                  });
                                } else {}
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
            ),
          )),
    );
  }

  saveData() async {
    sharedPref.save("savedPref", svp);
    var json = svp.toJson();
    try {
      final docUser = await FirebaseFirestore.instance
          .collection('block_list')
          .doc(uid)
          .get();

      if (docUser.exists) {
        FirebaseFirestore.instance
            .collection("saved_pref")
            .doc(uid)
            .update(json)
            .then((value) async {});

        Navigator.of(context).pop();
        if (!mounted) return;
        setState(() {
          borderColor = false;
          borderColor2 = false;
        });
      } else {
        FirebaseFirestore.instance
            .collection("saved_pref")
            .doc(uid)
            .set(json)
            .then((value) async {});
        // await showDialog(
        //     context: context,
        //     builder: (context) {
        //       return const AlertDialog(
        //         content: SnackBarContent(
        //             error_text: "Preference Saved Successfully",
        //             appreciation: "",
        //             icon: Icons.check),
        //         backgroundColor: Colors.transparent,
        //         elevation: 0,
        //       );
        //     });

        // Navigator.of(context).pop();
        if (!mounted) return;
        setState(() {
          borderColor = false;
          borderColor2 = false;
        });
        // ignore: use_build_context_synchronously
        //  Navigator.of(context).pushAndRemoveUntil(
        //                         MaterialPageRoute(
        //                             builder: (builder) => SlideProfile(notiPage: false,)),
        //                         (route) => false);
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainAppContainer(notiPage: true,)));
      }

      FirebaseFirestore.instance.collection("saved_pref").doc(uid).update(json);
      NotificationFunction.setNotification(
        "admin",
        "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SAVED PREFERENCE",
        'savepreference',
      );
      NotificationFunction.setNotification(
        "user1",
        "PREFERENCE SAVED SUCCESSFULLY ",
        'savepreference',
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}

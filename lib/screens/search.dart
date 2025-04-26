import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/error/search_profile_error.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/screens/search_profile/function_search.dart';
import 'package:ristey/screens/search_profile/search_dynamic_page.dart';
import 'package:ristey/screens/search_profile/user_search_profile.dart';
import 'package:ristey/services/add_to_profile_service.dart';
import 'package:ristey/services/search_service.dart';
import 'package:ristey/small_functions/profile_completion.dart';

import 'profile/service/notification_service.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // ignore: prefer_final_fields
  TextEditingController _searchController = TextEditingController();
  // ignore: prefer_final_fields, unused_field
  RangeValues _currentRangeValues = const RangeValues(40, 80);
  double _currentSliderValue = 0;
  // ignore: unused_field, prefer_final_fields
  double _startValue = 20.0;
  // ignore: unused_field, prefer_final_fields
  double _endValue = 90.0;
  var startValue = 0.0;
  var endValue = 0.0;
  bool searchingbool = false;

  late String profileSearch = "";
  SearchDataList sdl = SearchDataList();

  nameContainer2(icon, String head, Function tap, List<String> val) {
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
                // setState(() {
                val.clear();
                // });
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
                    ? const Text(
                        "Add",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black38,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Sans-serif'),
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
                                "${val[0][0].toString()},${val[1][0].toString()},${val[2][0].toString()}",
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

  List<AdsModel> searchads = [];
  List<AdsModel> usersearchads = [];
  List<AdsModel> distanceads = [];
  List<AdsModel> userdistanceads = [];
  List<AdsModel> citeriaads = [];
  List<AdsModel> userciteriaads = [];
  void getads() async {
    searchads = await AdsService().getallusers(adsid: "27");
    usersearchads = adsuser.where((element) => element.adsid == "27").toList();
    userdistanceads =
        adsuser.where((element) => element.adsid == "28").toList();
    userciteriaads = adsuser.where((element) => element.adsid == "28").toList();

    distanceads = await AdsService().getallusers(adsid: "28");
    citeriaads = await AdsService().getallusers(adsid: "29");
    setState(() {});
  }

  nameContainerHeight(
      icon, String head, Function tap, List<String> val, List<String> options) {
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
                    ? const Text(
                        "Add",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black38,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Sans-serif'),
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

  bool forIos = false;
  SavedPref svp = SavedPref();
// List<String> heading = [
  List<String> AgeList = [];
  List<String> ReligionList = [];
  List<String> KundaliDoshList = [];
  List<String> MaritalStatusList = [];
  List<String> dietList = [];
  List<String> DrinkList = [];
  List<String> SmokeList = [];
  List<String> DisabilityList = [];
  List<String> HeightList = [];
  List<String> EducationList = [];
  List<String> ProfessionList = [];
  List<String> IncomeList = [];
  List<String> LocatioList = [];
  // ];
  nameContainer(icon, String head, List<String> val, List<String> options) {
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
                      style: const TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Sans-serif'),
                    ))
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
      
              if (ds != null) {
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
                    ? const Text(
                        "Add",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black38,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Sans-serif'),
                      )
                    : val.contains("Any")
                        ? Text(
                            "Any",
                            textAlign: TextAlign.end,
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
                                          fontSize: 18,
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

  int profilepercentage = 0;
  ProfileCompletion profile = ProfileCompletion();

  void getprecentage() async {
    profilepercentage = await profile.profileComplete();
    setState(() {});
  }

  @override
  void initState() {
    getprecentage();
    getads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
          appBar: CustomAppBar(
            title: "Search Profile",
            iconImage: 'images/icons/search.png',
            onBackButtonPressed: () {
              selectedCity!.clear();
              selectedCounty!.clear();
              selectedState!.clear();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyProfile(profilepercentage: profilepercentage),
                  ));
            },
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 10, right: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                // SizedBox(width:5,),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Search By Profile ID",
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: mainColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Sans-serif'),
                                  ),
                                ),
                                // const SizedBox(
                                //   width: 5,
                                // ),
                                 const SizedBox(
                                        width: 10,
                                      ),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.36,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(70)),
                                        child: Material(
                                          color: Colors.white,
                                          child: TextField(
                                            controller: _searchController,
                                            cursorColor: mainColor,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.only(
                                                        top: 5, left: 10),
                                                hintText: 'Enter Profile ID',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    borderSide: BorderSide(
                                                        color: mainColor)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    borderSide: BorderSide(
                                                        color: mainColor)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    borderSide: BorderSide(
                                                        color: mainColor))),
                                            onChanged: (String) {
                                              profileSearch =
                                                  _searchController.text;
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (_searchController.text == "") {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return const AlertDialog(
                                                    content: SnackBarContent(
                                                      error_text:
                                                          "Please Enter Profile ID",
                                                      appreciation: "",
                                                      icon: Icons.error,
                                                      sec: 2,
                                                    ),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                  );
                                                });
                                          } else {
                                            AddToProfileService().addtosearchprofile(
                                                searchprofile:
                                                    _searchController.text,
                                                searchDistance:
                                                    _currentSliderValue
                                                        .toString(),
                                                age: svp.AgeList.toString(),
                                                religion: svp.ReligionList
                                                    .toString(),
                                                kundalidosh: svp.KundaliDoshList
                                                    .toString(),
                                                marital_status:
                                                    svp.MaritalStatusList
                                                        .toString(),
                                                citylocation:
                                                    svp.LocatioList[2],
                                                location1: svp.LocatioList[0],
                                                statelocation:
                                                    svp.LocatioList[1],
                                                diet: svp.dietList.toString(),
                                                smoke:
                                                    svp.SmokeList.toString(),
                                                drink:
                                                    svp.DrinkList.toString(),
                                                disability: svp.DisabilityList
                                                    .toString(),
                                                height:
                                                    svp.HeightList.toString(),
                                                education: svp.EducationList
                                                    .toString(),
                                                profession:
                                                    svp.ProfessionList.toString(),
                                                income: svp.IncomeList.toString(),
                                                location: svp.LocatioList.toString());
                                            getProfileSearchByProfile();
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: mainColor),
                                          child: const Icon(
                                            Icons.search,
                                            size: 30.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text("Search By Distance",
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: mainColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Sans-serif')),
                                ),
                                // Container(
                                //   margin: const EdgeInsets.only(right: 10),
                                //   child: Text(
                                //     "$_currentSliderValue Km",
                                //     style: TextStyle(
                                //         decoration: TextDecoration.none,
                                //         color: mainColor,
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w400,
                                //         fontFamily: 'Sans-serif'),
                                //   ),
                                // )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text("0km"), Text("200km")],
                              ),
                            ),
                        
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Within",
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: mainColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Sans-serif'),
                                  ),
                                ),
                              ],
                            ),
                        
                            Column(
                              children: [
                                Material(
                                  color: Colors.white,
                                  child:SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                     rangeThumbShape: const CircleThumbShape(
          thumbRadius: 10.0, // Size of the thumb
        ),
                                        thumbColor: Colors.transparent, // Transparent fill for hollow center
                                        overlayColor: Colors.transparent, // No overlay when thumb is pressed
                                        activeTrackColor: mainColor, // Track color for selected range
                                        inactiveTrackColor: mainColor.withOpacity(0.3), // Track color for unselected range
                                        trackHeight: 4.0, // Thickness of the track
                                      
                                      ),
                                      child: RangeSlider(
                                        activeColor: mainColor,
                                        values: _currentRangeValues,
                                        min: 0,
                                        max: 200,
                                        divisions: 10,
                                        labels: RangeLabels(
                                          _currentRangeValues.start.round().toString(),
                                          _currentRangeValues.end.round().toString(),
                                        ),
                                        onChanged: forIos
                                            ? (RangeValues values) {
                                                if (!mounted) return;
                                  
                                                setState(() {
                                                  // Adjust values to maintain a minimum gap of 20
                                                  double newStart = values.start;
                                                  double newEnd = values.end;
                                  
                                                  // If the range is less than 20, adjust the appropriate thumb
                                                  if (newEnd - newStart < 20) {
                                                    // If the user is moving the start thumb
                                                    if ((values.start - _currentRangeValues.start).abs() >
                                                        (values.end - _currentRangeValues.end).abs()) {
                                                      newEnd = newStart + 20;
                                                      if (newEnd > 200) {
                                                        newEnd = 200;
                                                        newStart = 200 - 20;
                                                      }
                                                    }
                                                    // If the user is moving the end thumb
                                                    else {
                                                      newStart = newEnd - 20;
                                                      if (newStart < 0) {
                                                        newStart = 0;
                                                        newEnd = 20;
                                                      }
                                                    }
                                                  }
                                  
                                                  _currentRangeValues = RangeValues(newStart, newEnd);
                                                });
                                              }
                                            : null,
                                      ),
                                    ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 35,
                                      width: 55,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black12),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Track
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            decoration: BoxDecoration(
                                              color: forIos
                                                  ? mainColor
                                                  : Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            width: 55,
                                            height: 35,
                                          ),
                                          // Thumb with text
                                          Align(
                                            alignment: forIos
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  forIos = !forIos;
                                                });
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  forIos ? "On" : "Off",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "Search By Category",
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: mainColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Sans-serif'),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                        
                            nameContainer2('images/icons/calender.png', "Age",
                                functions().AgeDialog, svp.AgeList),
                            const SizedBox(
                              height: 2,
                            ),
                            nameContainer('images/icons/religion.png',
                                "Religion", svp.ReligionList, sdl.Religion),
                            const SizedBox(
                              height: 2,
                            ),
                            (userSave.religion == "Hindu")
                                ? nameContainer(
                                    'images/icons/kundli.png',
                                    "Kundli Dosh",
                                    svp.KundaliDoshList,
                                    sdl.KundaliDosh)
                                : Container(),
                            const SizedBox(
                              height: 2,
                            ),
                            nameContainer(
                                'images/icons/marital_status.png',
                                "Marital Status",
                                svp.MaritalStatusList,
                                sdl.MaritalStatus),
                            const SizedBox(
                              height: 2,
                            ),
                            nameContainer('images/icons/food.png', "Diet",
                                svp.dietList, sdl.Diet),
                            const SizedBox(
                              height: 2,
                            ),
                            nameContainer('images/icons/smoke.png', "Smoke",
                                svp.SmokeList, sdl.Smoke),
                            const SizedBox(
                              height: 2,
                            ),
                            nameContainer('images/icons/drink.png', "Drink",
                                svp.DrinkList, sdl.Drink),
                            const SizedBox(
                              height: 2,
                            ),
                            nameContainer(
                                'images/icons/disability.png',
                                "Disability With Person",
                                svp.DisabilityList,
                                sdl.Disability),
                            const SizedBox(
                              height: 2,
                            ),
                            nameContainerHeight(
                                'images/icons/height.png',
                                "Height",
                                functions().HeightDialog,
                                svp.HeightList,
                                sdl.Height),
                            // HeightList, sdl.Height),
                            const SizedBox(
                              height: 1,
                            ),
                            nameContainer(
                                'images/icons/education.png',
                                "Education",
                                svp.EducationList,
                                sdl.Education),
                            const SizedBox(
                              height: 1,
                            ),
                            nameContainer(
                                'images/icons/profession_suitcase.png',
                                "Profession",
                                svp.ProfessionList,
                                sdl.Profession),
                            const SizedBox(
                              height: 1,
                            ),
                            nameContainer('images/icons/hand_rupee.png',
                                "Annual Income", svp.IncomeList, sdl.Income),
                            const SizedBox(
                              height: 1,
                            ),
                            nameContainer3(
                                'images/icons/location.png',
                                "Location",
                                functions().LocationDialog,
                                svp.LocatioList),
                            const SizedBox(
                              height: 1,
                            ),
                          ],
                        ),
                      ),
                      (searchingbool)
                          ? SizedBox(
                              height: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  mainColor))),
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.black),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            //side: BorderSide(color: Colors.black)
                          )),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      child: const Text(
                        "Search",
                        style: TextStyle(
                          fontFamily: 'Serif',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        AddToProfileService().addtosearchprofile(
                            searchprofile: _searchController.text,
                            searchDistance: _currentSliderValue.toString(),
                            age: svp.AgeList.toString(),
                            religion: svp.ReligionList.toString(),
                            kundalidosh: svp.KundaliDoshList.toString(),
                            marital_status: svp.MaritalStatusList.toString(),
                            diet: svp.dietList.toString(),
                            smoke: svp.SmokeList.toString(),
                            drink: svp.DrinkList.toString(),
                            disability: svp.DisabilityList.toString(),
                            height: svp.HeightList.isEmpty
                                ? [].toString()
                                : "${sdl.Height[int.parse(svp.HeightList[0])].substring(0, 4)}-${sdl.Height[int.parse(svp.HeightList[1])]}",
                            education: svp.EducationList.toString(),
                            profession: svp.ProfessionList.toString(),
                            citylocation: svp.LocatioList[2],
                            location1: svp.LocatioList[0],
                            statelocation: svp.LocatioList[1],
                            income: svp.IncomeList.toString(),
                            location:
                                "${svp.LocatioList[0].isEmpty ? "" : svp.LocatioList[0][0]} ${svp.LocatioList[1].isEmpty ? "" : svp.LocatioList[1][0]} ${svp.LocatioList[2].isEmpty ? "" : svp.LocatioList[2][0]}");

                        if (forIos == false) {
                          _currentSliderValue = 0;
                          setState(() {});
                          getProfileSearch();
                        } else {
                          searchByDistance();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          )),
    );
  }

  List<NewUserModel> searchuserlist = [];
  getProfileSearchByProfile() async {
    try {
      var a;
      // var fireStore = FirebaseFirestore.instance;
      if (profileSearch != "") {
        searchuserlist = await Searchservice()
            .getuserdatabyid(puid: profileSearch, email: userSave.email!);
        setState(() {});
        if (searchuserlist.isNotEmpty) {
          NotificationService().addtoadminnotification(
              userid: userSave.uid!,
              useremail: userSave.email!,
              subtitle: "ONLINE PROFILES",
              userimage:
                  userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
              title:
                  "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEARCH PROFILE $profileSearch BY PROFILE ID");
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MainAppContainer(
                    notiPage: true,
                    user_data: searchuserlist,
                  )));
          if (usersearchads.isNotEmpty) {
            showadsbar(context, usersearchads, () {
              Navigator.pop(context);
            });
          } else {
            if (searchads.isNotEmpty) {
              showadsbar(context, searchads, () {
                Navigator.pop(context);
              });
            }
          }
        } else {
          NotificationService().addtoadminnotification(
              userid: userSave.uid!,
              useremail: userSave.email!,
              subtitle: "ONLINE PROFILES",
              userimage:
                  userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
              title:
                  "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEARCH PROFILE $profileSearch BY PROFILE ID (WRONG)");
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: SnackBarContent(
                    error_text: "Please Enter Valid Profile ID",
                    appreciation: "",
                    icon: Icons.error,
                    sec: 2,
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                );
              }).whenComplete(() {
            if (searchads.isNotEmpty) {
              showadsbar(context, searchads, () {
                Navigator.pop(context);
              });
            }
          });
        }
      }
    } catch (e) {}
  }

  getProfileSearch() async {
    if (!mounted) return;
    setState(() {
      searchingbool = true;
    });

    try {
      // var fireStore = FirebaseFirestore.instance;
      // var abc;
      // var a, b, c, d, e, f, g, h, i, j, k, l, m;
      String gen;

      if (userSave.gender == "male") {
        gen = "female";
      } else {
        gen = "male";
      }

      // List<User> finalquery = [];
      // List<User> temp = [];
      print(gen);
      print(svp.LocatioList[0]);
      // print(sdl.Height[int.parse(svp.HeightList[1])]);
      if (svp.AgeList.isNotEmpty ||
          svp.ReligionList.isNotEmpty ||
          svp.KundaliDoshList.isNotEmpty ||
          svp.dietList.isNotEmpty ||
          svp.MaritalStatusList.isNotEmpty ||
          svp.SmokeList.isNotEmpty ||
          svp.DisabilityList.isNotEmpty ||
          svp.HeightList.isNotEmpty ||
          svp.EducationList.isNotEmpty ||
          svp.ProfessionList.isNotEmpty ||
          svp.IncomeList.isNotEmpty ||
          svp.DrinkList.isNotEmpty ||
          //  svp.LocatioList.isNotEmpty||
          svp.LocatioList[0].isNotEmpty ||
          svp.LocatioList[1].isNotEmpty ||
          svp.LocatioList[2].isNotEmpty ||
          _currentSliderValue != 0.0) {
        if (svp.LocatioList[0].contains("United States")) {
          svp.LocatioList[0].clear();
          svp.LocatioList[0].add("USA");
          setState(() {});
        }

        List<NewUserModel> allusers = await Searchservice().searchuserdata(
            gender: gen,
            email: userSave.email!,
            religion: userSave.email!,
            page: 1,
            maxDistanceKm: (_currentSliderValue).toInt(),
            ages: svp.AgeList,
            religionList: svp.ReligionList,
            kundaliDoshList: svp.KundaliDoshList,
            maritalStatusList: svp.MaritalStatusList,
            dietList: svp.dietList,
            drinkList: svp.DrinkList,
            smokeList: svp.SmokeList,
            disabilityList: svp.DisabilityList,
            heightList: svp.HeightList.isEmpty
                ? []
                : [
                    sdl.Height[int.parse(svp.HeightList[0])],
                    sdl.Height[int.parse(svp.HeightList[1])]
                  ],
            educationList: svp.EducationList,
            citylocation: svp.LocatioList[2],
            statelocation: svp.LocatioList[1],
            professionList: svp.ProfessionList,
            incomeList: svp.IncomeList,
            location: svp.LocatioList[0]);
        print(allusers);
        //  print()
        if (allusers.isEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SearchProfileError(
                    issearchempty: false,
                  )));
          if (userciteriaads.isNotEmpty) {
            showadsbar(context, userciteriaads, () {
              Navigator.pop(context);
            });
          } else {
            if (citeriaads.isNotEmpty) {
              showadsbar(context, citeriaads, () {
                Navigator.pop(context);
              });
            }
          }
        } else {
          NotificationService().addtoadminnotification(
              userid: userSave.uid!,
              useremail: userSave.email!,
              subtitle: "ONLINE PROFILES",
              userimage:
                  userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
              title:
                  "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEARCH BY PARAMETERS");
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserSearchSlideProfile(
                    profilepercentage: profilepercentage,
                    notiPage: true,
                    ages: svp.AgeList,
                    religionList: svp.ReligionList,
                    kundaliDoshList: svp.KundaliDoshList,
                    maritalStatusList: svp.MaritalStatusList,
                    dietList: svp.dietList,
                    drinkList: svp.DrinkList,
                    smokeList: svp.SmokeList,
                    disabilityList: svp.DisabilityList,
                    heightList: svp.HeightList.isEmpty
                        ? []
                        : [
                            sdl.Height[int.parse(svp.HeightList[0])],
                            sdl.Height[int.parse(svp.HeightList[1])]
                          ],
                    educationList: svp.EducationList,
                    professionList: svp.ProfessionList,
                    incomeList: svp.IncomeList,
                    citylocation: svp.LocatioList[2],
                    statelocation: svp.LocatioList[1],
                    location: svp.LocatioList[0],
                    currentSliderValue: _currentSliderValue.toInt(),
                    forIos: forIos,
                    user_data: allusers,
                    user_list: allusers,
                  )));
          if (citeriaads.isNotEmpty) {
            showadsbar(context, citeriaads, () {
              Navigator.pop(context);
            });
          }
        }
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              // Future.delayed(const Duration(seconds: 1), () {
              //   Navigator.of(context).pop(true);
              // });
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Please Enter Data",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      }
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      searchingbool = false;
    });
    // ProfilePage(userSave: User.fromdoc(element))));
    // num = userlist.length;
    // }
    // );
    // }
    // );
  }

  searchByDistance() async {
    String gen;

    if (userSave.gender == "male") {
      gen = "female";
    } else {
      gen = "male";
    }

    // List<User> finalquery = [];
    // List<User> temp = [];
    // print(gen);
    List<NewUserModel> allusers = await Searchservice().searchuserdata(
        gender: gen,
        email: userSave.email!,
        religion: userSave.religion!,
        page: 1,
        maxDistanceKm: (_currentSliderValue).toInt(),
        ages: [],
        religionList: [],
        citylocation: [],
        statelocation: [],
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
    //   List<NewUserModel> allusers = await Searchservice().searchuserdata(
    // gender: gen,
    // email: userSave.email!,
    // religion: userSave.email!,
    // page: 1,
    // maxDistanceKm: (_currentSliderValue).toInt(),
    // ages: svp.AgeList,
    // religionList: svp.ReligionList,
    // citylocation: svp.LocatioList[1],
    // statelocation: svp.LocatioList[0],
    // kundaliDoshList: svp.KundaliDoshList,
    // maritalStatusList: svp.MaritalStatusList,
    // dietList: svp.dietList,
    // drinkList: svp.DrinkList,
    // smokeList: svp.SmokeList,
    // disabilityList: svp.DisabilityList,
    // heightList: svp.HeightList,
    // educationList: svp.EducationList,
    // professionList: svp.ProfessionList,
    // incomeList: svp.IncomeList,
    // location: [svp.LocatioList[0]]);
    print("hello number");
    print(allusers.length);
    //  print()

    if (allusers.isEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SearchProfileError(
                issearchempty: false,
              )));
      if (userdistanceads.isNotEmpty) {
        showadsbar(context, userdistanceads, () {
          Navigator.pop(context);
        });
      } else {
        if (distanceads.isNotEmpty) {
          showadsbar(context, distanceads, () {
            Navigator.pop(context);
          });
        }
      }
    } else {
      NotificationService().addtoadminnotification(
          userid: userSave.uid!,
          useremail: userSave.email!,
          subtitle: "ONLINE PROFILES",
          userimage: userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
          title:
              "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEARCH PROFILE BY DISTANCE $_currentSliderValue");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserSearchSlideProfile(
                profilepercentage: profilepercentage,
                notiPage: true,
                ages: svp.AgeList,
                religionList: svp.ReligionList,
                kundaliDoshList: svp.KundaliDoshList,
                maritalStatusList: svp.MaritalStatusList,
                dietList: svp.dietList,
                drinkList: svp.DrinkList,
                smokeList: svp.SmokeList,
                disabilityList: svp.DisabilityList,
                heightList: svp.HeightList.isEmpty
                    ? []
                    : [
                        sdl.Height[int.parse(svp.HeightList[0])],
                        sdl.Height[int.parse(svp.HeightList[1])]
                      ],
                educationList: svp.EducationList,
                professionList: svp.ProfessionList,
                incomeList: svp.IncomeList,
                citylocation: svp.LocatioList[2],
                statelocation: svp.LocatioList[1],
                location: svp.LocatioList[0],
                currentSliderValue: _currentSliderValue.toInt(),
                forIos: forIos,
                user_data: allusers,
                user_list: allusers,
              )));
      if (distanceads.isNotEmpty) {
        showadsbar(context, distanceads, () {
          Navigator.pop(context);
        });
      }
    }
  }

  queryintersect(List<User> a, List<User> b) {
    Set<User> set1 = a.toSet();
    Set<User> set2 = b.toSet();
    Set<User> intersection;
    // if (a.isNotEmpty && b.isNotEmpty) {
    intersection = set1.intersection(set2);
    // }
    List<User> result = intersection.toList();
    return result;
  }

  getLocationSearch() async {
    var fireStore = FirebaseFirestore.instance;
    var userData = await fireStore
        .collection("user_data")
        .where('uid', isEqualTo: profileSearch)
        .get();
    // await fireStore
    //     .collection("user_data")
    //     .where("gender" == "male")
    //     .limit(10)
    //     .snapshots();
    // print();
    if (!mounted) return;
    setState(() {
      // userlist=user_data.docs.map((e) => e.data())()
      userData.docs.forEach((element) {
        // print(element..toString());
        // profilelist.add(User.fromdoc(element));
        // num = userlist.length;
      });
    });
  }
}

class _CustomRangeThumbShape extends RangeSliderThumbShape {
  final Color borderColor;
  final double borderWidth;

  const _CustomRangeThumbShape({
    required this.borderColor,
    this.borderWidth = 2.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(8.0); // Matches enabledThumbRadius
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    bool? isPressed,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
  }) {
    final Canvas canvas = context.canvas;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Draw hollow circle (border only)
    canvas.drawCircle(
      center,
      sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width / 2,
      borderPaint,
    );
  }
}

// Custom track shape to avoid drawing under thumbs



class CircleThumbShape extends RangeSliderThumbShape {
  final double thumbRadius;

  const CircleThumbShape({
    this.thumbRadius = 6.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    bool? isPressed,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
  }) {
    final Canvas canvas = context.canvas;

    final fillPaint = Paint()
      ..color = Colors.white // White fill for the thumb's center
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue // Border color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw filled circle (white background)
    canvas.drawCircle(center, thumbRadius, fillPaint);
    // Draw border circle
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}
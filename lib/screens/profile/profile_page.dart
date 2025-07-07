// ignore: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ristey/Assets/box.dart';
import 'package:ristey/assets/profile_match.dart';
import 'package:ristey/assets/send_message.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/country.dart';
import 'package:ristey/models/match_modal.dart';
import 'package:ristey/models/match_modal_2.dart';
import 'package:ristey/models/new_save_pref.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/navigation/kundali_match_data.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/buttons.dart';
import 'package:ristey/screens/profile/components/kundali_circle.dart';
import 'package:ristey/screens/profile/image_slider.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/send_utils/noti_function.dart';
import 'package:ticker_text/ticker_text.dart';

import '../../Assets/Error.dart';

import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../global_vars.dart' as glb;

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  ProfilePage(
      {super.key,
      this.index,
      required this.userSave,
      required this.pushchat,
      this.controller,
      this.type = ""});
  NewUserModel? userSave;
  var index;
  String type;
  Function pushchat;
  var controller;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  // ignore: prefer_typing_uninitialized_variables
  var matchValue;
  bool expaned = false;
  var age;
  var city;
  var country;
  // ignore: prefer_typing_uninitialized_variables
  var galleryItems;
  // User userSave = User();
  ProfileMatch pm = ProfileMatch();
  SavedPref userSp = SavedPref();
  late DatabaseReference _dbref;
  late DatabaseReference _dbref5;
  SavedPref defaultSp = SavedPref();
  var data;
  var connectivity = '';
  var token = '';
  var tempImage = [
    "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/impImage%2Fnoimage.jpg?alt=media&token=4c0d4bc9-761e-48af-b947-4a05a0eaa6d2"
  ];
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  Match1? match;
  Match2? match2;

  void getmatch() async {
    DateTime dateofbirth = DateTime.fromMillisecondsSinceEpoch(userSave.dob!);

    String boydob = DateFormat('dd/MM/yyyy').format(dateofbirth);
    DateTime dateofbirth1 =
        DateTime.fromMillisecondsSinceEpoch(widget.userSave!.dob);
    String girldob = DateFormat('dd/MM/yyyy').format(dateofbirth1);
    String timeofbirhthofboy =
        userSave.timeofbirth!.replaceAll("Am", "").replaceAll("Pm", "");
    String timeofbirhthofgirl =
        widget.userSave!.timeofbirth.replaceAll("Am", "").replaceAll("Pm", "");

    match2 = await HomeService().getusermatch2(
      boydob: boydob,
      boytob: timeofbirhthofboy,
      boylat: userSave.latitude!,
      boyon: userSave.longitude!,
    );
  }

  get R => null;

  SendMessage sendMessage = SendMessage();
  void getallusermatch() async {
    if (userSave.gender == "male") {
      DateTime dateofbirth = DateTime.fromMillisecondsSinceEpoch(userSave.dob!);

      String mDay = dateofbirth.day.toString();
      String mMonth = dateofbirth.month.toString();
      String mYear = dateofbirth.year.toString();
      DateTime dateofbirth1 =
          DateTime.fromMillisecondsSinceEpoch(widget.userSave!.dob);
      String fDay = dateofbirth1.day.toString();
      String fMonth = dateofbirth1.month.toString();
      String fYear = dateofbirth1.year.toString();
      List<String> mParts = userSave.timeofbirth!.split(':');
      int mHours = int.parse(mParts[0]);

      List<String> minuteAndAmPm = mParts[1].split(' ');
      int mMinutes = int.parse(minuteAndAmPm[0]);
      List<String> fParts = widget.userSave!.timeofbirth.split(':');

      int fHours = int.parse(fParts[0]);

      List<String> fminuteAndAmPm = fParts[1].split(' ');
      int fMinutes = int.parse(fminuteAndAmPm[0]);

      var url = Uri.parse(
          'https://api.kundali.astrotalk.com/v1/combined/match_making');

      var payload = {
        "m_detail": {
          "day": mDay,
          "hour": mHours,
          "lat": userSave.latitude,
          "lon": userSave.longitude,
          "min": mMinutes,
          "month": mMonth,
          "name": userSave.name,
          "tzone": "5.5",
          "year": mYear,
          "gender": "male",
          "place": userSave.Location,
          "sec": 0
        },
        "f_detail": {
          "day": fDay,
          "hour": fHours,
          "lat": widget.userSave!.lat,
          "lon": widget.userSave!.lng,
          "min": fMinutes,
          "month": fMonth,
          "name": widget.userSave!.name,
          "tzone": "5.5",
          "year": fYear,
          "gender": "female",
          "place": widget.userSave!.location,
          "sec": 0
        },
        "languageId": 1
      };

      var body = json.encode(payload);

      var response = await http
          .post(url, body: body, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          data = json.decode(response.body);
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } else {
      DateTime dateofbirth =
          DateTime.fromMillisecondsSinceEpoch(widget.userSave!.dob);

      String mDay = dateofbirth.day.toString();
      String mMonth = dateofbirth.month.toString();
      String mYear = dateofbirth.year.toString();
      DateTime dateofbirth1 =
          DateTime.fromMillisecondsSinceEpoch(userSave.dob!);
      String fDay = dateofbirth1.day.toString();
      String fMonth = dateofbirth1.month.toString();
      String fYear = dateofbirth1.year.toString();
      List<String> mParts = widget.userSave!.timeofbirth.split(':');
      int mHours = int.parse(mParts[0]);

      List<String> minuteAndAmPm = mParts[1].split(' ');
      int mMinutes = int.parse(minuteAndAmPm[0]);
      List<String> fParts = userSave.timeofbirth!.split(':');
      int fHours = int.parse(fParts[0]);

      List<String> fminuteAndAmPm = fParts[1].split(' ');
      int fMinutes = int.parse(fminuteAndAmPm[0]);
      var url = Uri.parse(
          'https://api.kundali.astrotalk.com/v1/combined/match_making');

      var payload = {
        "m_detail": {
          "day": mDay,
          "hour": mHours,
          "lat": widget.userSave!.lat,
          "lon": widget.userSave!.lng,
          "min": mMinutes,
          "month": mMonth,
          "name": widget.userSave!.name,
          "tzone": "5.5",
          "year": mYear,
          "gender": "male",
          "place": widget.userSave!.location,
          "sec": 0
        },
        "f_detail": {
          "day": fDay,
          "hour": fHours,
          "lat": userSave.latitude,
          "lon": userSave.longitude,
          "min": fMinutes,
          "month": fMonth,
          "name": userSave.name,
          "tzone": "5.5",
          "year": fYear,
          "gender": "female",
          "place": userSave.Location,
          "sec": 0
        },
        "languageId": 1
      };

      var body = json.encode(payload);

      var response = await http
          .post(url, body: body, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          data = json.decode(response.body);
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  }

  _moreNoti() {
    try {
      NotificationService().addtoadminnotification(
          userid: userSave.uid!,
          useremail: userSave.email!,
          subtitle: "ONLINE PROFILES",
          userimage: userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
          title:
              "${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid} SEEN PHOTO ${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} PROFILE ");
      sendMessage.sendPushMessage(
          "VIEWED PROFILE BY ${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid}",
          "VIEWED PROFILE",
          userSave.uid!,
          "profilepage",
          widget.userSave!.token);
    } catch (e) {
      print(e);
    }
    expaned = true;
  }

  void setStatus(status) async {
    NotificationFunction.setOnlineStatus(userSave.uid!, status);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Resumed");
    }
  }

  List<AdsModel> sliderads = [];
  List<AdsModel> aboutads = [];
  List<AdsModel> prefads = [];
  List<AdsModel> usersliderads = [];
  List<AdsModel> useraboutads = [];
  List<AdsModel> userprefads = [];
  void getads() async {
    usersliderads = adsuser.where((element) => element.adsid == "13").toList();
    useraboutads = adsuser.where((element) => element.adsid == "11").toList();
    userprefads = adsuser.where((element) => element.adsid == "12").toList();

    sliderads = await AdsService().getallusers(adsid: "13");
    aboutads = await AdsService().getallusers(adsid: "11");
    prefads = await AdsService().getallusers(adsid: "12");
    if (mounted) {
      setState(() {});
    }
  }

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  animateOurBlinking() {
    Color startColor;
    Color endColor;

    if (connectivity == "Online") {
      startColor = const Color(0xFF00FF19);
      endColor = const Color(0xFF00B214); // Slightly darker green for blinking
    } else if (connectivity == "Resumed") {
      // print("machiknecondolado ${connectivity.length} ${connectivity}");

      startColor = const Color.fromARGB(255, 255, 208, 0);
      endColor = const Color.fromARGB(
          255, 255, 242, 179); // Slightly darker yellow for blinking
    } else {
      startColor = const Color(0xFFBDBDBD);
      endColor = const Color(0xFF8D8D8D); // Slightly darker grey for blinking
    }

    _colorAnimation =
        ColorTween(begin: startColor, end: endColor).animate(_controller);
  }

  @override
  initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    animateOurBlinking();
    getads();

    getallusermatch();
    getdefaultpreference();
    // getmatch();

    // checkBlockedStatus();
    didChangeAppLifecycleState(AppLifecycleState.resumed);
    super.initState();

    _dbref = FirebaseDatabase.instance.ref();
    _dbref5 = FirebaseDatabase.instance.ref();
    setconnection();
    matchValue = pm.profileMatch(widget.userSave).toString();
    setState(() {
      galleryItems = (widget.userSave!.imageurls.isEmpty)
          ? []
          : (widget.userSave!.imageurls.length > 6)
              ? widget.userSave!.imageurls.sublist(0, 6)
              : widget.userSave!.imageurls;
    });
    setLocation();
    // setSavedPreferences();

    setDefaultPreference();
    getdistance();
  }

  setLocation() {
    // if (widget.userSave!.location != "" && widget.userSave!.location != null) {
    try {
      setState(() {
        city = widget.userSave!.city;
      });
    } catch (e) {
      city = "";
    }
    try {
      setState(() {
        country = widget.userSave!.location
            .split(' ')[widget.userSave!.location.split(' ').length - 1];
      });

      print(countryCode(country).toLowerCase());
    } catch (e) {
      country = "India";
    }
    // } else {
    //   setState(() {
    //     city = "";
    //     country = "India";
    //   });
    // }
    setState(() {});
  }

  Future<double> getDistanceBetweenLocations(
      double startLat, double startLong, double endLat, double endLong) async {
    double distanceInMeters =
        Geolocator.distanceBetween(startLat, startLong, endLat, endLong);
    double distanceInKm = distanceInMeters / 1000;
    return distanceInKm;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371.0; // Earth radius in kilometers

    double toRadians(double degrees) {
      return degrees * pi / 180.0;
    }

    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(toRadians(lat1)) *
            cos(toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  setconnection() {
    _dbref = _dbref.child("onlineStatus");
    _dbref5 = _dbref5.child("token");
    _dbref.child(widget.userSave!.id).onValue.listen((event) {
      try {
        var res = event.snapshot.child('status').value;
        setState(() {
          connectivity = res.toString();
        });
        animateOurBlinking();
      } catch (e) {
        print(e);
      }
    });
    _dbref5.child(widget.userSave!.id).onValue.listen((event) {
      try {
        var res = event.snapshot.child('token').value;
        setState(() {
          token = res.toString();
        });
      } catch (e) {
        print(e);
      }
    });
  }

  // Future<void> setSavedPreferences() async {
  //   var doc = await FirebaseFirestore.instance
  //       .collection("saved_pref")
  //       .doc(widget.userSave!.aboutme)
  //       .get();
  //   setState(() {
  //     userSp = SavedPref.fromdoc(doc);
  //   });
  // }
  NewSavePrefModel? newSavePrefModel;
  void getdefaultpreference() async {
    newSavePrefModel = await HomeService().getsavepref(widget.userSave!.email);
    setState(() {});
  }

  String? distance;
  setDefaultPreference() async {
    DateTime dob = DateTime.fromMillisecondsSinceEpoch(widget.userSave!.dob);
    var temp = calculateAge(dob);
    setState(() {
      age = temp;
    });
    if (widget.userSave!.gender == 'male') {
      if (age <= 24) {
        defaultSp.AgeList.add('18');
        defaultSp.AgeList.add(age.toString());
      } else {
        defaultSp.AgeList.add((age - 6).toString());
      }
      defaultSp.AgeList.add(age.toString());
    } else {
      if (age >= 21) {
        defaultSp.AgeList.add(age.toString());
        defaultSp.AgeList.add((age + 6).toString());
      } else {
        defaultSp.AgeList.add('21');
        defaultSp.AgeList.add('26');
      }
    }
    if (widget.userSave!.disability == "Normal") {
      defaultSp.DisabilityList.add("Normal");
    } else {
      defaultSp.DisabilityList.add("Any");
    }
    if (widget.userSave!.diet == "Vegetarian") {
      defaultSp.dietList.add("Vegetarian");
    } else {
      defaultSp.dietList.add("Any");
    } //forheight list
    var highttemp = widget.userSave!.height.split(" ");
    double ft;
    double inc;
    if (highttemp[0] == "ft") {
      inc = double.parse(highttemp[2]);
    } else {
      highttemp = widget.userSave!.height.split(".");
      inc = double.parse(highttemp[0].split(" ")[0]);
    }
    ft = double.parse(highttemp[0]);

    // var height = ft + inc / 12;
    var height = double.parse(widget.userSave!.height.split(" ")[0]);
    print("*************");
    print(widget.userSave!.height.split(" ")[0]);
    print("*************");
    if (widget.userSave!.gender == 'male') {
      if (ft < 3.6) {
        defaultSp.HeightList.add("3.0");
      } else {
        defaultSp.HeightList.add((height - 0.6).toStringAsFixed(2));
      }
      defaultSp.HeightList.add(height.toStringAsFixed(1));
    } else {
      defaultSp.HeightList.add(height.toStringAsFixed(1));
      if (height > 7.4) {
        defaultSp.HeightList.add("8.0");
      } else {
        defaultSp.HeightList.add((height + 0.6).toStringAsFixed(1));
      }
    }
    defaultSp.ReligionList.add(widget.userSave!.religion.toString());

// defaultSp.HeightList.add('${newFeet}.${newInches.toString().padLeft(2, '0')}');
    defaultSp.KundaliDoshList.add("Any");

    if (widget.userSave!.martialstatus == "Unmarried") {
      defaultSp.MaritalStatusList.add("Unmarried");
    } else {
      defaultSp.MaritalStatusList.add("Any");
    }

    defaultSp.EducationList.add("Any");
    defaultSp.HeightList.add("Any");
    defaultSp.IncomeList.add("Any");
    defaultSp.LocatioList.add(["Any"]);
    defaultSp.ProfessionList.add("Any");
    defaultSp.DrinkList.add("Any");
    defaultSp.SmokeList.add("Any");
    defaultSp.HeightList.add("Any");
  }

  void getdistance() async {
    var dist = await getDistanceBetweenLocations(
        userSave.latitude!,
        userSave.longitude!,
        widget.userSave!.lat.toDouble(),
        widget.userSave!.lng.toDouble());
    var distance1 = calculateDistance(userSave.latitude!, userSave.longitude!,
        widget.userSave!.lat.toDouble(), widget.userSave!.lng.toDouble());
    distance = distance1.toStringAsFixed(2);
    setState(() {});
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  savedPrefCard(boxname, imgicon, defaultText) {
    return Box(
      currentusertext: "",
      box_text: (boxname.isEmpty)
          ? (defaultText.length > 1)
              ? "${defaultText[0]} +${defaultText.length - 1}}"
              : defaultText[0]
          : (boxname.length > 1)
              ? "${boxname[0]} +${boxname.length - 1}"
              : boxname[0],
      icon: imgicon,
    );
  }

  locationCard(boxname, imgicon, defaultText) {
    return Container(
        margin: const EdgeInsets.only(bottom: 1.5, right: 2),
        height: MediaQuery.of(context).size.height * 0.024,

        // width: (width == null) ? box_text.length * 8 + 32.0 : width,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(33.0),
          border: Border.all(color: mainColor, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                ImageIcon(
                  AssetImage(imgicon),
                  size: 16,
                  color: mainColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                boxname.contains("1")
                    ? Text(
                        "Any",
                        // textScaleFactor: 1.0,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: mainColor,
                        ),
                      )
                    : Text(
                        boxname,
                        // textScaleFactor: 1.0,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: mainColor,
                        ),
                      )
              ],
            ),
          ),
        ));
    //  Box(
    //   box_text: ( boxname.isEmpty)
    //       ? "Any"
    //       : (boxname[0].isEmpty)
    //           ? (boxname[1].isEmpty)
    //               ? (boxname[2].length > 1)
    //                   ? "${boxname[2][0]} +${boxname[2].length - 1}"
    //                   : boxname[2][0]
    //               : (boxname[1].length > 1)
    //                   ? "${boxname[1][0]} +${boxname[1].length - 1}"
    //                   : boxname[1][0]
    //           : (boxname[0].length > 1)
    //               ? "${boxname[0][0]} +${boxname[0].length - 1}"
    //               : boxname[0][0],
    //   icon: imgicon,
    // );
  }

  ageCard(boxname, imgicon, defaultText, usertext) {
    return Box(
      currentusertext: "",
      box_text: (boxname.isEmpty)
          ? (defaultText.length > 1)
              ? "${defaultText[0]} - ${defaultText[1]} "
              : ""
          : (boxname.length > 1)
              ? "${boxname[0]} - ${boxname[1]}"
              : '',
      icon: imgicon,
    );
  }

  heightard(boxname, imgicon, defaultText) {
    return Box(
      currentusertext: "",
      box_text: (boxname.isEmpty)
          ? (defaultText.length > 1)
              ? "${defaultText[0]} - ${defaultText[1]}  "
              : ""
          : (boxname.length > 1)
              ? "${boxname[0]} - ${boxname[1]} "
              : '',
      icon: imgicon,
    );
  }

  var _selectedDate;
  var _age;

  // void _showDatePicker() async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(1900),
  //       lastDate: DateTime.now());
  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //       _age = calculateAge(_selectedDate);
  //     });
  //   }
  // }

  // int calculateAge(DateTime birthDate) {
  //   DateTime today = DateTime.now();
  //   int age = today.year - birthDate.year;
  //   if (today.month < birthDate.month ||
  //       (today.month == birthDate.month && today.day < birthDate.day)) {
  //     age--;
  //   }
  //   return age;
  // }

  bool isExpanded = false;
  // connectivityCheck() async {
  //   try {
  //     final result = await InternetAddress.lookup('example.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       // ignore: avoid_print
  //     }
  //   } on SocketException catch (_) {
  //     showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (context) {
  //           return const AlertDialog(
  //             content: SnackBarContent(
  //               error_text: "No Internet Connection",
  //               appreciation: "",
  //               icon: Icons.error,
  //               sec: 2,
  //             ),
  //             backgroundColor: Colors.transparent,
  //             elevation: 0,
  //           );
  //         });
  //   }
  // }

  int numindex = 0;
  List<Widget> _createImgList() {
    if (galleryItems == null) {
      return [const Text("image not found")];
    } else {
      return List<Widget>.generate(galleryItems.length, (int index) {
        return widget.userSave!.isBlur == true
            ? SizedBox(
                height: 25,
                width: 25,
                child: ClipRRect(
                  // Clipping the child widget
                  borderRadius: BorderRadius.circular(
                      10.0), // Optional: Add border radius if needed
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        galleryItems[index],
                        fit: BoxFit.cover,
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.black.withOpacity(
                              0), // Required to make BackdropFilter work
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("images/lock.png"),
                      SizedBox(height: 10,),
                      Text("Locked",style: TextStyle(color: mainColor),)
                    ],)
                    ],
                  ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: galleryItems[index],
                fit: BoxFit.cover,
                // progressIndicatorBuilder: (context, url, downloadProgress) =>
                //     CircularProgressIndicator(
                //         value: downloadProgress.progress, color: mainColor),
              );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.white),
                child: Stack(children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(children: [
                          SizedBox(
                            // height:
                            // MediaQuery.of(context).size.height * 0.42,
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width,
                            child: GestureDetector(
                              child: widget.userSave!.imageurls.isEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: tempImage[0],
                                      fit: BoxFit.cover,
                                    )
                                  : ImageSlideshow(
                                      indicatorRadius: 4,

                                      // indicatorRightPadding: 10,
                                      indicatorBottomPadding: 10,
                                      initialPage: 0,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      width: MediaQuery.of(context).size.width,
                                      onPageChanged: (value) {
                                        numindex = value;
                                        setState(() {});
                                        if (userSave.status == "approved") {
                                          NotificationFunction.setNotification(
                                            "admin",
                                            "${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid} SEEN PHOTO ${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} PROFILE ",
                                            'profileseen',
                                          );
                                          NotificationService().addtoactivities(
                                              email: widget.userSave!.email,
                                              title:
                                                  "VIEWED PROFILE BY ${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid}",
                                              username: glb.userSave.name!,
                                              userimage:
                                                  userSave.imageUrls!.isEmpty
                                                      ? ""
                                                      : userSave.imageUrls![0],
                                              userid: glb.userSave.uid!);

                                          NotificationService()
                                              .addtoadminnotification(
                                                  userid: userSave.uid!,
                                                  useremail: userSave.email!,
                                                  subtitle: "ONLINE PROFILES",
                                                  userimage: userSave
                                                          .imageUrls!.isEmpty
                                                      ? ""
                                                      : userSave.imageUrls![0],
                                                  title:
                                                      "${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid} SEEN  ${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} PROFILE BY PROFILE PHOTO");
                                          // _moreNoti();

                                          try {
                                            sendMessage.sendPushMessage(
                                                "VIEWED PROFILE BY ${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid}",
                                                "VIEWED PROFILE",
                                                userSave.uid!,
                                                "profilepage",
                                                widget.userSave!.token);
                                          } catch (e) {}
                                        } else {
                                          HomeService().addtounapproveacitvites(
                                              email: userSave.email!,
                                              reciveuserid: widget.userSave!.id,
                                              token: widget.userSave!.token,
                                              useremail: widget.userSave!.email,
                                              title:
                                                  "VIEWED PROFILE BY ${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid}",
                                              userimage:
                                                  userSave.imageUrls!.isEmpty
                                                      ? ""
                                                      : userSave.imageUrls![0]);
                                        }
                                      },

                                      /// The color to paint the indicator.
                                      indicatorColor: glb.mainColor,
                                      isLoop: (_createImgList().length > 1),
                                      children: _createImgList()
                                      // .map((url) =>
                                      //     CachedNetworkImageProvider(url))
                                      // .map((provider) =>
                                      //     Image(image: provider))
                                      // .toList(),
                                      //returns list of images
                                      ),
                              onTap: () {
                                if (userSave.status == "approved") {
                                  NotificationFunction.setNotification(
                                    "admin",
                                    "${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid} SEEN PHOTO ${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} PROFILE ",
                                    'profileseen',
                                  );
                                  NotificationService().addtoactivities(
                                      email: widget.userSave!.email,
                                      title:
                                          "VIEWED PROFILE BY ${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid}",
                                      username: glb.userSave.name!,
                                      userimage: userSave.imageUrls!.isEmpty
                                          ? ""
                                          : userSave.imageUrls![0],
                                      userid: glb.userSave.uid!);
                                  NotificationFunction.setNotification(
                                      "user2",
                                      "VIEWED PROFILE BY ${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid}",
                                      'profileseen',
                                      useruid: userSave.uid!);
                                  // _moreNoti();
                                  NotificationService().addtoadminnotification(
                                      userid: userSave.uid!,
                                      useremail: userSave.email!,
                                      subtitle: "ONLINE PROFILES",
                                      userimage: userSave.imageUrls!.isEmpty
                                          ? ""
                                          : userSave.imageUrls![0],
                                      title:
                                          "${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid} SEEN ${userSave.name!.substring(0, 1).toUpperCase()} ${userSave.surname!.toUpperCase()} ${userSave.puid} PROFILE BY PROFILE PHOTO");
                                  try {
                                    sendMessage.sendPushMessage(
                                        "VIEWED PROFILE BY ${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid}",
                                        "VIEWED PROFILE",
                                        userSave.uid!,
                                        "profilepage",
                                        widget.userSave!.token);
                                  } catch (e) {
                                    print(e);
                                  }
                                } else {
                                  HomeService().addtounapproveacitvites(
                                      email: userSave.email!,
                                      reciveuserid: widget.userSave!.id,
                                      token: widget.userSave!.token,
                                      useremail: widget.userSave!.email,
                                      title:
                                          "VIEWED PROFILE BY ${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid}",
                                      userimage: userSave.imageUrls!.isEmpty
                                          ? ""
                                          : userSave.imageUrls![0]);
                                }
                                if(widget.userSave!.isBlur==false){
                                if (galleryItems[0] != tempImage[0]) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ImageSliderPopUp(
                                        currentindex: numindex,
                                        galleryItems: galleryItems,
                                      ),
                                    ),
                                  );
                                }}
                              },
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 8,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "${widget.userSave!.name.substring(0, 1).toUpperCase()} ${widget.userSave!.surname.substring(0, 1).toUpperCase() + widget.userSave!.surname.substring(1).toLowerCase()}",
                                          // "${widget. userSave!.name!.substring(0, 1).toUpperCase()} ${widget.userSave!.surname.substring(0, 1).toUpperCase()}",
                                          style: const TextStyle(
                                            fontFamily: "Sans-serif",
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            shadows: <Shadow>[
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 33.0)
                                            ],
                                          ),
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   width: 2,
                                      // ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          left: 10,
                                          bottom: 2,
                                        ),
                                        child: Text(
                                          calculateAge(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      widget.userSave!.dob))
                                              .toString(),
                                          style: const TextStyle(
                                            fontFamily: "Sans-serif",
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            shadows: <Shadow>[
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 33.0)
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 2),
                                            child: Image.asset(
                                              'assets/flags/${countryCode(country).toLowerCase()}.png',
                                              package: 'intl_phone_field',
                                              width: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          (widget.userSave!.verifiedstatus ==
                                                  "verified")
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 2),
                                                  child: Icon(
                                                    Icons.verified_user,
                                                    color: glb.mainColor,
                                                    size: 16,
                                                  ),
                                                )
                                              : Container(),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 18,
                                          color: Color(0xFF38B9F4),
                                          shadows: <Shadow>[
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 5.0)
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 2),
                                          child: Text(
                                            (distance != null ||
                                                    distance != 0.0)
                                                ? "$distance Km"
                                                : "70Km",
                                            style: const TextStyle(
                                              fontFamily: "Sans-serif",
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                              shadows: <Shadow>[
                                                Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 5.0)
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: TickerText(
                                            // default values
                                            scrollDirection: Axis.horizontal,
                                            speed: 20,
                                            startPauseDuration:
                                                const Duration(seconds: 1),
                                            endPauseDuration:
                                                const Duration(seconds: 1),
                                            returnDuration: const Duration(
                                                milliseconds: 800),
                                            primaryCurve: Curves.linear,
                                            returnCurve: Curves.easeOut,
                                            child: Text(
                                              widget.userSave!.location,
                                              style: const TextStyle(
                                                fontFamily: "Sans-serif",
                                                fontSize: 12,
                                                color: Colors.white,
                                                // color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                shadows: <Shadow>[
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 5.0)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            AnimatedBuilder(
                                              animation: _colorAnimation,
                                              builder: (context, child) {
                                                return ClipOval(
                                                  child: Container(
                                                    width: 9,
                                                    height: 9,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          _colorAnimation.value,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(
                                              height: 2.5,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),

                                        // Column(
                                        //   children: [
                                        //     ClipOval(
                                        //       child: Container(
                                        //         // padding: EdgeInsets.all(30),
                                        //         width: 9,
                                        //         height: 9,
                                        //         decoration: BoxDecoration(
                                        //             color: (connectivity ==
                                        //                     "Online")
                                        //                 ? const Color(
                                        //                     0xFF00FF19)
                                        //                 : (connectivity ==
                                        //                         "Resumed")
                                        //                     ? const Color
                                        //                         .fromARGB(255,
                                        //                         255, 208, 0)
                                        //                     : const Color(
                                        //                         0xFFBDBDBD)
                                        //             // color: Color(0xFF33D374)),
                                        //             // color: if(userSave.connectivity == "Online"){Color(0xFF00FF19)}else if(userSave.connectivity == "Offline"){Color(0xFFBDBDBD)} else{Color(0xFFDBFF00)}
                                        //             ),
                                        //       ),
                                        //     ),
                                        //     const SizedBox(
                                        //       height: 2.5,
                                        //     )
                                        //   ],
                                        // ),
                                        // const SizedBox(
                                        //   width: 10,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          Positioned(
                            bottom: 5,
                            left: Get.width * 0.55,
                            child: userSave.religion == "Hindu"
                                ? Column(
                                    children: [
                                      (userSave.uid != glb.uid)
                                          ? InkWell(
                                              onTap: () {
                                                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HoroScopePage(match1: match!,),), (route) => false);
                                                DateTime dateofbirth = DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        userSave.dob!);

                                                String boydob =
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(dateofbirth);
                                                DateTime dateofbirth1 = DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        widget.userSave!.dob);
                                                String girldob =
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(dateofbirth1);
                                                String timeofbirhthofboy =
                                                    userSave.timeofbirth!
                                                        .replaceAll("Am", "")
                                                        .replaceAll("Pm", "");
                                                String timeofbirhthofgirl =
                                                    widget.userSave!.timeofbirth
                                                        .replaceAll("Am", "")
                                                        .replaceAll("Pm", "");
                                                NotificationService()
                                                    .addtoadminnotification(
                                                        userid: userSave.uid!,
                                                        subtitle:
                                                            "Profile Create",
                                                        useremail:
                                                            userSave.email!,
                                                        userimage: userSave
                                                                .imageUrls!
                                                                .isEmpty
                                                            ? ""
                                                            : userSave
                                                                .imageUrls![0],
                                                        title:
                                                            "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEEN ${widget.userSave!.name.substring(0, 1).toUpperCase()} ${widget.userSave!.surname.toUpperCase()} ${widget.userSave!.puid} PROFILE BY MATCHING SCORE (${data['ashtkoot']['total']['received_points']}/36 & $matchValue/100)");

                                                if (userSave.gender == "male") {
                                                  DateTime dateofbirth = DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          userSave.dob!);

                                                  String mDay = dateofbirth.day
                                                      .toString();
                                                  String mMonth = dateofbirth
                                                      .month
                                                      .toString();
                                                  String mYear = dateofbirth
                                                      .year
                                                      .toString();
                                                  DateTime dateofbirth1 = DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          widget.userSave!.dob);
                                                  String fDay = dateofbirth1.day
                                                      .toString();
                                                  String fMonth = dateofbirth1
                                                      .month
                                                      .toString();
                                                  String fYear = dateofbirth1
                                                      .year
                                                      .toString();
                                                  List<String> mParts = userSave
                                                      .timeofbirth!
                                                      .split(':');
                                                  int mHours =
                                                      int.parse(mParts[0]);

                                                  List<String> minuteAndAmPm =
                                                      mParts[1].split(' ');
                                                  int mMinutes = int.parse(
                                                      minuteAndAmPm[0]);
                                                  List<String> fParts = widget
                                                      .userSave!.timeofbirth
                                                      .split(':');

                                                  int fHours =
                                                      int.parse(fParts[0]);

                                                  List<String> fminuteAndAmPm =
                                                      fParts[1].split(' ');
                                                  int fMinutes = int.parse(
                                                      fminuteAndAmPm[0]);

                                                  var url = Uri.parse(
                                                      'https://api.kundali.astrotalk.com/v1/combined/match_making');

                                                  var payload = {
                                                    "m_detail": {
                                                      "day": mDay,
                                                      "hour": mHours,
                                                      "lat": userSave.latitude,
                                                      "lon": userSave.longitude,
                                                      "min": mMinutes,
                                                      "month": mMonth,
                                                      "name": userSave.name,
                                                      "tzone": "5.5",
                                                      "year": mYear,
                                                      "gender": "male",
                                                      "place":
                                                          userSave.Location,
                                                      "sec": 0
                                                    },
                                                    "f_detail": {
                                                      "day": fDay,
                                                      "hour": fHours,
                                                      "lat":
                                                          widget.userSave!.lat,
                                                      "lon":
                                                          widget.userSave!.lng,
                                                      "min": fMinutes,
                                                      "month": fMonth,
                                                      "name":
                                                          widget.userSave!.name,
                                                      "tzone": "5.5",
                                                      "year": fYear,
                                                      "gender": "female",
                                                      "place": widget
                                                          .userSave!.location,
                                                      "sec": 0
                                                    },
                                                    "languageId": 1
                                                  };

                                                  Get.to(KundaliMatchDataScreen(
                                                    m_name: userSave.name,
                                                    f_name:
                                                        widget.userSave!.name,
                                                    m_month: mMonth,
                                                    f_month: fMonth,
                                                    f_surname: widget
                                                        .userSave!.surname,
                                                    m_surname: userSave.surname,
                                                    m_day: mDay,
                                                    f_day: fDay,
                                                    m_year: mYear,
                                                    f_year: fYear,
                                                    m_hour: mHours,
                                                    f_hour: fHours,
                                                    m_min: mMinutes,
                                                    f_min: fMinutes,
                                                    m_place: userSave.Location,
                                                    f_place: widget
                                                        .userSave!.location,
                                                    m_gender: "Male",
                                                    f_gender: "Female",
                                                    m_lat: userSave.latitude,
                                                    m_lon: userSave.longitude,
                                                    f_lat: widget.userSave!.lat,
                                                    f_lon: widget.userSave!.lng,
                                                    m_sec: 0,
                                                    f_sec: 0,
                                                    m_tzone: "5.5",
                                                    f_tzone: "5.5",
                                                  ));
                                                  if (usersliderads
                                                      .isNotEmpty) {
                                                    showadsbar(
                                                        context, usersliderads,
                                                        () {
                                                      Navigator.pop(context);
                                                    });
                                                  } else {
                                                    if (sliderads.isNotEmpty) {
                                                      showadsbar(
                                                          context, sliderads,
                                                          () {
                                                        // Get.back();
                                                        Navigator.pop(context);
                                                        // Navigator.of(context).pop();
                                                      });
                                                    }
                                                  }
                                                } else {
                                                  DateTime dateofbirth = DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          widget.userSave!.dob);

                                                  String mDay = dateofbirth.day
                                                      .toString();
                                                  String mMonth = dateofbirth
                                                      .month
                                                      .toString();
                                                  String mYear = dateofbirth
                                                      .year
                                                      .toString();
                                                  DateTime dateofbirth1 = DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          userSave.dob!);
                                                  String fDay = dateofbirth1.day
                                                      .toString();
                                                  String fMonth = dateofbirth1
                                                      .month
                                                      .toString();
                                                  String fYear = dateofbirth1
                                                      .year
                                                      .toString();
                                                  List<String> mParts = widget
                                                      .userSave!.timeofbirth
                                                      .split(':');
                                                  int mHours =
                                                      int.parse(mParts[0]);

                                                  List<String> minuteAndAmPm =
                                                      mParts[1].split(' ');
                                                  int mMinutes = int.parse(
                                                      minuteAndAmPm[0]);
                                                  List<String> fParts = userSave
                                                      .timeofbirth!
                                                      .split(':');
                                                  int fHours =
                                                      int.parse(fParts[0]);

                                                  List<String> fminuteAndAmPm =
                                                      fParts[1].split(' ');
                                                  int fMinutes = int.parse(
                                                      fminuteAndAmPm[0]);

                                                  Get.to(KundaliMatchDataScreen(
                                                    m_name:
                                                        widget.userSave!.name,
                                                    f_name: userSave.name,
                                                    m_month: mMonth,
                                                    f_month: fMonth,
                                                    f_surname: widget
                                                        .userSave!.surname,
                                                    m_surname: userSave.surname,
                                                    m_day: mDay,
                                                    f_day: fDay,
                                                    m_year: mYear,
                                                    f_year: fYear,
                                                    m_hour: mHours,
                                                    f_hour: fHours,
                                                    m_min: mMinutes,
                                                    f_min: fMinutes,
                                                    m_place: widget
                                                        .userSave!.location,
                                                    f_place: userSave.Location,
                                                    m_gender: "Male",
                                                    f_gender: "Female",
                                                    m_lat: widget.userSave!.lat,
                                                    m_lon: widget.userSave!.lng,
                                                    f_lat: userSave.latitude,
                                                    f_lon: userSave.longitude,
                                                    m_sec: 0,
                                                    f_sec: 0,
                                                    m_tzone: "5.5",
                                                    f_tzone: "5.5",
                                                  ));

                                                  if (usersliderads
                                                      .isNotEmpty) {
                                                    showadsbar(
                                                        context, usersliderads,
                                                        () {
                                                      Navigator.pop(context);
                                                    });
                                                  } else {
                                                    if (sliderads.isNotEmpty) {
                                                      showadsbar(
                                                          context, sliderads,
                                                          () {
                                                        // Get.back();
                                                        Navigator.pop(context);
                                                        // Navigator.of(context).pop();
                                                      });
                                                    }
                                                  }
                                                }
                                              },
                                              child: KundaliCircle(
                                                percentage: int.parse(
                                                    matchValue.toString()),
                                                match: data == null
                                                    ? 0
                                                    : double.parse(data[
                                                                    'ashtkoot']
                                                                ['total']
                                                            ['received_points']
                                                        .toString()),
                                              ))
                                          : Container(),
                                      const SizedBox(
                                        height: 2.5,
                                      ),
                                    ],
                                  )
                                : const Center(),
                          )
                        ]),
                        SizedBox(
                          // height: MediaQuery.of(context).size.height * 0.49,
                          height: MediaQuery.of(context).size.height * 0.42,
                          // color: Colors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "About ${widget.userSave!.name.substring(0, 1).toUpperCase()} ${widget.userSave!.surname.substring(0, 1).toUpperCase() + widget.userSave!.surname.substring(1).toLowerCase()}",
                                        style: TextStyle(
                                          fontFamily: "Sans-serif",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: glb.mainColor,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onLongPress: () {
                                          Clipboard.setData(ClipboardData(
                                                text: widget.userSave!.puid))
                                            .then((value) {
                                          //only if ->
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Copied successfully")));
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 12),
                                        child: Text(
                                          "Profile ID- ${widget.userSave!.puid}",
                                          style: const TextStyle(
                                            fontFamily: "Sans-serif",
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF38B9F4),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: MediaQuery.of(context).size.height *
                              //       0.007,
                              // ),
SizedBox(height: 5,),
                              Stack(
                                  //expandable text
                                  children: [
                                    Container(
                                      // width: MediaQuery.of(context).size.width * 1,
                                      margin: const EdgeInsets.only(
                                        left: 12,
                                        right: 0,
                                        top: 3
                                      ),
                                      child: Wrap(
                                        // alignment:WrapAlignment.spaceBetween,
                                        spacing: 4,
                                        runSpacing: 4,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          GestureDetector(
                                            onTap: () async {},
                                            child: Box(
                                                // width: userSave.religion!.length * 15.5,
                                                box_text:
                                                    widget.userSave!.religion,
                                                currentusertext:
                                                    userSave.religion!,
                                                icon:
                                                    'images/icons/religion.png'),
                                          ),
                                          (widget.userSave!.religion == "Hindu")
                                              ? Box(
                                                  box_text: widget
                                                      .userSave!.kundalidosh,
                                                  currentusertext:
                                                      userSave.KundaliDosh!,
                                                  icon:
                                                      'images/icons/kundli.png',
                                                )
                                              : Container(
                                                  width: 0,
                                                ),
                                          Box(
                                            // width: userSave.MartialStatus!.length * 15.5,
                                            box_text:
                                                widget.userSave!.martialstatus,
                                            currentusertext:
                                                userSave.MartialStatus!,

                                            icon:
                                                'images/icons/marital_status.png',
                                          ),
                                             Box(
                                            // width: userSave.Diet!.length * 15.5,
                                            box_text: widget.userSave!.diet,
                                            currentusertext: userSave.Diet!,

                                            icon: 'images/icons/food.png',
                                          ),
                                             Box(
                                            currentusertext: userSave.Drink!,
                                            // width: userSave.Profession!.length * 15.5,
                                            box_text: widget.userSave!.drink,
                                            icon: 'images/icons/drink.png',
                                          ),
                                               Box(
                                            currentusertext: userSave.Smoke!,

                                            // width: userSave.Profession!.length * 15.5,
                                            box_text: widget.userSave!.smoke,
                                            icon: 'images/icons/smoke.png',
                                          ),
                                          (widget.userSave!.disability ==
                                                  'Normal')
                                              ? Container(width: 0)
                                              : Box(
                                                  currentusertext:
                                                      userSave.Disability!,

                                                  // width: userSave.Profession!.length * 15.5,
                                                  box_text: widget
                                                      .userSave!.disability,
                                                  icon:
                                                      'images/icons/disability.png',
                                                ),
                                          Box(
                                            // width: userSave.Height!.length * 15.5,
                                            box_text: widget.userSave!.height,
                                            currentusertext: userSave.Height!,

                                            icon: 'images/icons/height.png',
                                          ),
                                       
                                          Box(
                                            // width: userSave.Education!.length * 15.5,
                                            currentusertext:
                                                userSave.Education!,

                                            box_text: capitalize(
                                                widget.userSave!.education),
                                            icon: 'images/icons/education.png',
                                          ),
                                          Box(
                                            currentusertext:
                                                userSave.Profession!,

                                            // width: userSave.Profession!.length * 15.5,
                                            box_text: capitalize(
                                                widget.userSave!.profession),
                                            icon:
                                                'images/icons/profession_suitcase.png',
                                          ),
                                          // Box(
                                          //   currentusertext: (widget.userSave!
                                          //                   .location ==
                                          //               null ||
                                          //           widget.userSave!.location ==
                                          //               "")
                                          //       ? ""
                                          //       : widget.userSave!.location
                                          //           .split(' ')[0]
                                          //           .substring(
                                          //               0,
                                          //               widget.userSave!
                                          //                       .location
                                          //                       .split(' ')[0]
                                          //                       .length -
                                          //                   1),
                                          //   box_text: (widget.userSave!
                                          //                   .location ==
                                          //               null ||
                                          //           widget.userSave!.location ==
                                          //               "")
                                          //       ? ""
                                          //       : widget.userSave!.location
                                          //           .split(' ')[0]
                                          //           .substring(
                                          //               0,
                                          //               widget.userSave!
                                          //                       .location
                                          //                       .split(' ')[0]
                                          //                       .length -
                                          //                   1),
                                          //   icon:
                                          //       'images/icons/location_home.png',
                                          // ),
                                       
                                     
                                          
                                          Box(
                                            currentusertext: userSave.Income!,
                                            // width: userSave.Profession!.length * 15.5,
                                            box_text: widget.userSave!.income,
                                            icon: 'images/icons/hand_rupee.png',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Container(
                                        // width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            boxShadow: const [
                                              BoxShadow(blurRadius: 0.05)
                                            ]),
                                        margin: const EdgeInsets.only(
                                          left: 12,
                                          right: 0,
                                        ),
                                        padding: const EdgeInsets.only(
                                            left: 7,
                                            right: 7,
                                            top: 7,
                                            bottom: 7),
                                        child: ExpandableText(
                                          (widget.userSave!.aboutme == "")
                                              ? "Welcome to my profile. I'm here to find someone who appreciates authenticity and kindness. Hope you find what you're looking for."
                                              : (widget.userSave!.aboutme
                                                          .length <
                                                      100)
                                                  ? "${widget.userSave!.aboutme} ................................................................................................................."
                                                  : widget.userSave!.aboutme,
                                          collapseText: 'Less',
                                          style: TextStyle(
                                              fontSize: 10),
                                          linkColor: glb.mainColor,
                                          onExpandedChanged: (value) {
                                            if (useraboutads.isNotEmpty &&
                                                numberofabout >= 5) {
                                              showadsbar(context, useraboutads,
                                                  () {
                                                numberofabout = 0;
                                                Navigator.pop(context);
                                              });
                                            } else {
                                              if (aboutads.isNotEmpty &&
                                                  numberofabout == 5) {
                                                showadsbar(context, aboutads,
                                                    () {
                                                  numberofabout = 0;
                                                  Navigator.pop(context);
                                                });
                                              }
                                            }
                                            numberofabout++;
                                            setState(() {});
                                            if (userSave.status == "approved") {
                                              NotificationService().addtoactivities(
                                                  email: widget.userSave!.email,
                                                  title:
                                                      "VIEWED PROFILE BY ${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid}",
                                                  username: glb.userSave.name!,
                                                  userimage: userSave
                                                          .imageUrls!.isEmpty
                                                      ? ""
                                                      : userSave.imageUrls![0],
                                                  userid: glb.userSave.uid!);
                                              _moreNoti();
                                            } else {
                                              HomeService().addtounapproveacitvites(
                                                  email: userSave.email!,
                                                  reciveuserid:
                                                      widget.userSave!.id,
                                                  useremail:
                                                      widget.userSave!.email,
                                                  token: widget.userSave!.token,
                                                  title:
                                                      "VIEWED PROFILE BY ${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid}",
                                                  userimage: userSave
                                                          .imageUrls!.isEmpty
                                                      ? ""
                                                      : userSave.imageUrls![0]);
                                            }
                                            isExpanded = expaned;
                                          },
                                          // linkEllipsis:false,
                                          expandText: 'More',
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ]),
SizedBox(height: 6,),

                              //interested in marraige with
                              Container(
                                margin: const EdgeInsets.only(left: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Partner Preferences",
                                      // textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: "Sans-serif",
                                          fontSize: 16,
                                          color: glb.mainColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: MediaQuery.of(context).size.height *
                              //       0.002,
                              // ),
SizedBox(height: 6,),

                              Stack(
                                children: [
                                  //expandable text
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    margin: const EdgeInsets.only(
                                      left: 12,
                                      right: 0,
                                    ),
                                    child: newSavePrefModel == null
                                        ? Center(
                                            child: Wrap(
                                              spacing: 4,
                                        runSpacing: 4,
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                ),
                                                ageCard(
                                                    [],
                                                    'images/icons/calender.png',
                                                    defaultSp.AgeList,
                                                    []),
                                                savedPrefCard([],
                                                    'images/icons/religion.png',
                                                    defaultSp.ReligionList),
                                                (widget.userSave!.religion ==
                                                        "Hindu")
                                                    ? savedPrefCard(
                                                        [],
                                                        'images/icons/kundli.png',
                                                        defaultSp
                                                            .KundaliDoshList)
                                                    : Container(width: 0),
                                                savedPrefCard(
                                                    [],
                                                    'images/icons/marital_status.png',
                                                    defaultSp
                                                        .MaritalStatusList),
                                                          savedPrefCard([],
                                                    'images/icons/food.png',
                                                    defaultSp.dietList),
                                                      savedPrefCard([],
                                                    'images/icons/drink.png',
                                                    defaultSp.DrinkList),
                                                savedPrefCard([],
                                                    'images/icons/smoke.png',
                                                    defaultSp.SmokeList),
                                                      (widget.userSave!.disability ==
                                                        "Normal")
                                                    ? Container(width: 0)
                                                    : savedPrefCard(
                                                        [],
                                                        'images/icons/disability.png',
                                                        defaultSp
                                                            .DisabilityList),
                                                heightard([],
                                                    'images/icons/height.png',
                                                    defaultSp.HeightList),
                                              
                                                savedPrefCard([],
                                                    'images/icons/education.png',
                                                    defaultSp.EducationList),
                                                savedPrefCard([],
                                                    'images/icons/profession_suitcase.png',
                                                    defaultSp.ProfessionList),
                                                savedPrefCard([],
                                                    'images/icons/hand_rupee.png',
                                                    defaultSp.IncomeList),
                                                        locationCard(
                                                    "Any ",
                                                    'images/icons/location.png',
                                                    defaultSp.LocatioList),
                                              ],
                                            ),
                                          )
                                        : Wrap(
                                          spacing: 4,
                                        runSpacing: 4,
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                              // const Box(
                                              //   // width: userSave.Profession!.length * 15.5,
                                              //   box_text: '18 - 36',
                                              //   icon: 'images/icons/calender.png',
                                              // ),
                                              ageCard(
                                                  newSavePrefModel!.ageList,
                                                  'images/icons/calender.png',
                                                  defaultSp.AgeList, []),
                                              // const Box(
                                              //   box_text: 'Hindu +2 more',
                                              //   icon: 'images/icons/religion.png',
                                              // ),
                                              savedPrefCard(
                                                  newSavePrefModel!
                                                      .religionList,
                                                  'images/icons/religion.png',
                                                  defaultSp.ReligionList),
                                              (widget.userSave!.religion ==
                                                      "Hindu")
                                                  ? savedPrefCard(
                                                      newSavePrefModel!
                                                          .religionList,
                                                      'images/icons/kundli.png',
                                                      defaultSp.KundaliDoshList)
                                                  : Container(width: 0),
                                              savedPrefCard(
                                                  newSavePrefModel!
                                                      .maritalStatusList,
                                                  'images/icons/marital_status.png',
                                                  defaultSp.MaritalStatusList),
   savedPrefCard(
                                                  newSavePrefModel!.dietList,
                                                  'images/icons/food.png',
                                                  defaultSp.dietList),
                                                      savedPrefCard(
                                                  newSavePrefModel!.smokeList,
                                                  'images/icons/smoke.png',
                                                  defaultSp.SmokeList),
                                              (widget.userSave!
                                                          .disability ==
                                                      "Normal")
                                                  ? Container(width: 0)
                                                  : savedPrefCard(
                                                      newSavePrefModel!
                                                          .disabilityList,
                                                      'images/icons/disability.png',
                                                      defaultSp.DisabilityList),
                                              heightard(
                                                  newSavePrefModel!.heightList,
                                                  'images/icons/height.png',
                                                  defaultSp.HeightList),
                                           
                                              savedPrefCard(
                                                  newSavePrefModel!
                                                      .educationList,
                                                  'images/icons/education.png',
                                                  defaultSp.EducationList),
                                              savedPrefCard(
                                                  newSavePrefModel!
                                                      .professionList,
                                                  'images/icons/profession_suitcase.png',
                                                  defaultSp.ProfessionList),
                                           
                                              savedPrefCard(
                                                  newSavePrefModel!.drinkList,
                                                  'images/icons/drink.png',
                                                  defaultSp.DrinkList),
                                          
                                              savedPrefCard(
                                                  newSavePrefModel!.incomeList,
                                                  'images/icons/hand_rupee.png',
                                                  defaultSp.IncomeList),
                                                     locationCard(
                                                  newSavePrefModel!.location
                                                              .isEmpty &&
                                                          newSavePrefModel!
                                                              .statelocation
                                                              .isEmpty &&
                                                          newSavePrefModel!
                                                              .citylocation
                                                              .isEmpty
                                                      ? "Any"
                                                      : "${newSavePrefModel!.citylocation.join(', ')}${newSavePrefModel!.statelocation.join(', ')}${newSavePrefModel!.location} ",
                                                  'images/icons/location.png',
                                                  defaultSp.LocatioList),
                                            ],
                                          ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          boxShadow: const [
                                            BoxShadow(blurRadius: 0.05)
                                          ]),
                                      margin: const EdgeInsets.only(
                                        left: 12,
                                        right: 0,
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 7, right: 7, top: 7, bottom: 7),
                                      child: ExpandableText(
                                        (widget.userSave!.patnerprefs == "")
                                            ? "I am looking for a meaningful connection based on mutual respect, trust and shared values. Someone who is ready to grow and learn with me on this journey I would like to Connect"
                                            : (widget.userSave!.patnerprefs
                                                        .length <
                                                    100)
                                                ? "${widget.userSave!.patnerprefs} ................................................................................................................."
                                                : widget.userSave!.aboutme,
                                        collapseText: 'Less',
                                        style: TextStyle(
                                            fontSize:10),
                                        onExpandedChanged: (value) {
                                          if (userprefads.isNotEmpty &&
                                              numberofpref == 5) {
                                            showadsbar(context, userprefads,
                                                () {
                                              numberofpref = 0;

                                              Navigator.pop(context);
                                            });
                                          } else {
                                            if (prefads.isNotEmpty &&
                                                numberofpref == 5) {
                                              showadsbar(context, prefads, () {
                                                numberofpref = 0;

                                                Navigator.pop(context);
                                              });
                                            }
                                          }
                                          numberofpref++;
                                          setState(() {});
                                          if (userSave.status == "approved") {
                                            NotificationService().addtoactivities(
                                                email: widget.userSave!.email,
                                                title:
                                                    "VIEWED PROFILE BY ${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid}",
                                                username: glb.userSave.name!,
                                                userimage: userSave
                                                        .imageUrls!.isEmpty
                                                    ? ""
                                                    : userSave.imageUrls![0],
                                                userid: glb.userSave.uid!);
                                            _moreNoti();
                                          } else {
                                            HomeService().addtounapproveacitvites(
                                                email: userSave.email!,
                                                reciveuserid:
                                                    widget.userSave!.id,
                                                useremail:
                                                    widget.userSave!.email,
                                                token: widget.userSave!.token,
                                                title:
                                                    "VIEWED PROFILE BY ${glb.userSave.name!.substring(0, 1).toUpperCase()} ${glb.userSave.surname!.toUpperCase()} ${glb.userSave.puid}",
                                                userimage: userSave
                                                        .imageUrls!.isEmpty
                                                    ? ""
                                                    : userSave.imageUrls![0]);
                                          }
                                        },
                                        // linkColor: Colors.red,
                                        expandText: 'More',
                                        linkColor: glb.mainColor,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.011,
                              ),

                              const SizedBox(height: 10),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ])),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.86,
              // bottom: MediaQuery.of(context).size.height * 0.005,
              child: Pbuttons(
                  profileData: widget.userSave, pushchat: widget.pushchat),
            ),
            (widget.type == 'other')
                ? Positioned(
                    left: MediaQuery.of(context).size.width * 0.05,
                    top: MediaQuery.of(context).size.height * 0.04,
                    child: IconButton(
                      icon: Icon(
                        // Icons.more_vert_outlined,//for three dots
                        Icons.arrow_back_ios, //for three lines
                        size: 25,
                        color: mainColor,
                        shadows: const <Shadow>[
                          Shadow(color: Colors.black, blurRadius: 15.0)
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                : SizedBox(width: 0, height: 0),
          ],
        ),
      ),
    );
  }
}

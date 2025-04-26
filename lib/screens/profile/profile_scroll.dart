import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ristey/assets/notification_pop_up.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:ristey/network_connectivity.dart';
import 'package:ristey/screens/error/save_pref_error.dart';
import 'package:ristey/screens/mobile_chat_screen.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/profile/profile_page.dart';
import 'package:ristey/screens/profile/service/notification_controller.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/services/audio_call.dart';
import 'package:ristey/services/audio_sharing_service.dart';
import 'package:ristey/small_functions/profile_completion.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../assets/profile_match.dart';
import '../../global_vars.dart';
import '../../models/ads_modal.dart';
import '../../models/filter_user_modal.dart';
import '../../models/user_modal.dart';
import '../../send_utils/noti_function.dart';
import '../../services/add_to_profile_service.dart';
import '../../services/call_controller.dart';
import '../error/search_profile_error.dart';
import '../navigation/service/ads_service.dart';
import '../notification/Widget_Notification/ads_bar.dart';
import '../notification/nav_home.dart';

var profiledata;

class SlideProfile extends StatefulWidget {
  SlideProfile(
      {super.key,
      this.type = "",
      this.user_data,
      this.user_list,
      required this.profilepercentage,
      required this.notiPage});
  String type;
  var user_data;
  int profilepercentage;
  bool notiPage = false;
  var user_list;
  @override
  State<SlideProfile> createState() => _SlideProfileState();
}

class _SlideProfileState extends State<SlideProfile> {
  int num = 6;
  int pagecount = 2;
  int profilepercentage = 0;
  bool load = false;
  // int _unreadCount = 0;
  // User userSave = User();
  List<User> userlist = [];
  List<User> largeuserlist = [];
  List<NewUserModel> newuserlists = [];
  bool nodata = false;
  QueryDocumentSnapshot? lastDocument;
  HomeService homeservice = Get.put(HomeService());
  ProfileCompletion profile = ProfileCompletion();
  void getalluserlists() async {
    // _unreadCount = await NotificationService().getnumberofnoti();
    HomeService().updatelogin(email: userSave.email!, mes: "true");
    HomeService().updateoffiletime(
        email: userSave.email!, time: DateTime.now().toString());
    if (widget.user_list == null || widget.user_list.isEmpty) {
      load = true;
      setState(() {});
      homeservice.getusersaveprefdata().then((value) async {
        if (homeservice.saveprefdata.value.ageList.isNotEmpty ||
            homeservice.saveprefdata.value.dietList.isNotEmpty ||
            homeservice.saveprefdata.value.disabilityList.isNotEmpty ||
            homeservice.saveprefdata.value.drinkList.isNotEmpty ||
            homeservice.saveprefdata.value.educationList.isNotEmpty ||
            homeservice.saveprefdata.value.dietList.isNotEmpty ||
            homeservice.saveprefdata.value.heightList.isNotEmpty ||
            homeservice.saveprefdata.value.incomeList.isNotEmpty ||
            homeservice.saveprefdata.value.kundaliDoshList.isNotEmpty ||
            homeservice.saveprefdata.value.location.isNotEmpty ||
            homeservice.saveprefdata.value.maritalStatusList.isNotEmpty ||
            homeservice.saveprefdata.value.professionList.isNotEmpty ||
            homeservice.saveprefdata.value.religionList.isNotEmpty ||
            homeservice.saveprefdata.value.smokeList.isNotEmpty ||
            homeservice.saveprefdata.value.citylocation.isNotEmpty ||
            homeservice.saveprefdata.value.statelocation.isNotEmpty) {
          newuserlists = await homeservice.getalluserdata(
              gender: userSave.gender == "male" ? "female" : "male",
              email: userSave.email!,
              religion: userSave.religion!,
              citylocation: homeservice.saveprefdata.value.citylocation,
              statelocation: homeservice.saveprefdata.value.statelocation,
              page: 1,
              ages: homeservice.saveprefdata.value.ageList,
              religionList: homeservice.saveprefdata.value.religionList,
              kundaliDoshList: homeservice.saveprefdata.value.kundaliDoshList,
              maritalStatusList:
                  homeservice.saveprefdata.value.maritalStatusList,
              dietList: homeservice.saveprefdata.value.dietList,
              drinkList: homeservice.saveprefdata.value.drinkList,
              smokeList: homeservice.saveprefdata.value.smokeList,
              disabilityList: homeservice.saveprefdata.value.disabilityList,
              heightList: homeservice.saveprefdata.value.heightList,
              educationList: homeservice.saveprefdata.value.educationList,
              professionList: homeservice.saveprefdata.value.professionList,
              incomeList: homeservice.saveprefdata.value.incomeList,
              location: homeservice.saveprefdata.value.location);
        } else {
          newuserlists = await homeservice.getalluserdata(
              page: 1,
              gender: userSave.gender == "male" ? "female" : "male",
              ages: ["18", "70"],
              dietList: [],
              citylocation: [],
              statelocation: [],
              disabilityList: [],
              drinkList: [],
              educationList: [],
              email: userSave.email!,
              heightList: [],
              incomeList: [],
              kundaliDoshList: [],
              location: [],
              maritalStatusList: [],
              professionList: [],
              religion: userSave.religion!,
              religionList: [userSave.religion!],
              smokeList: []);
        }
        List<NewUserModel> someusers =
            await HomeService().getaddedusers(userid: userSave.puid!);
        newuserlists.addAll(someusers);
        List<NewUserModel> invisibleusers = await NotificationService()
            .getinvisibleusers(userid: invisibleuserFriend);
        for (var i = 0; i < invisibleusers.length; i++) {
          newuserlists.remove(invisibleusers[i]);
        }

        List<Filterusermodel> usersWithDistance = newuserlists.map((user) {
          int distance = ProfileMatch().profileMatch(user);
          return Filterusermodel(matchvalue: distance, newUserModel: user!);
        }).toList();
        usersWithDistance.sort((a, b) => b.matchvalue - a.matchvalue);
        newuserlists.clear();
        for (var i = 0; i < usersWithDistance.length; i++) {
          newuserlists.add(usersWithDistance[i].newUserModel);
        }
        List<Matchusermodel> profilematch = await Future.wait(
          newuserlists.map((user) async {
            double distance = await ProfileMatch().getallusermatch(user!);
            return Matchusermodel(
                kundalimatch: distance.toInt(), newUserModel: user);
          }),
        );
        profilematch.sort((a, b) => b.kundalimatch - a.kundalimatch);
        newuserlists.clear();
        for (var i = 0; i < profilematch.length; i++) {
          newuserlists.add(profilematch[i].newUserModel);
        }
        List<NewUserModel> boostuser1 =
            await NotificationService().getboostusers(userid: boostprofileuids);
        List<NewUserModel> boostuser = boostuser1.reversed.toList();
        newuserlists.insertAll(0, boostuser);

        setState(() {});

        load = false;
      });
    } else {
      newuserlists = [];
      load = false;
      newuserlists = widget.user_list!;
      setState(() {});
    }
  }

  List<AdsModel> allads = [];
  List<AdsModel> all8ads = [];
  List<AdsModel> all25ads = [];
  List<AdsModel> all106ads = [];
  void getnewads() async {
    userkundaliads = adsuser.where((element) => element.adsid == "58").toList();
    userprofileads = adsuser.where((element) => element.adsid == "18").toList();
    userbioads = adsuser.where((element) => element.adsid == "19").toList();
    usersupportads = adsuser.where((element) => element.adsid == "67").toList();
    usermatchmakingads =
        adsuser.where((element) => element.adsid == "60").toList();
    kundaliads = await AdsService().getallusers(adsid: "58");
    chatads = await AdsService().getallusers(adsid: "42");
    logoutads = await AdsService().getallusers(adsid: "84");
    deleteads = await AdsService().getallusers(adsid: "85");
    editads = await AdsService().getallusers(adsid: "86");
    marriageloanads = await AdsService().getallusers(adsid: "65");
    profileads = await AdsService().getallusers(adsid: "34");
    searchads = await AdsService().getallusers(adsid: "26");
    shareads = await AdsService().getallusers(adsid: "66");
    bioads = await AdsService().getallusers(adsid: "19");
    supportads = await AdsService().getallusers(adsid: "67");
    matchmakingads = await AdsService().getallusers(adsid: "35");
    savePreferads = await AdsService().getallusers(adsid: "30");
    onlineads = await AdsService().getallusers(adsid: "33");
    setState(() {});
  }

  void getbirthday() async {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(userSave.dob!);

    // Get today's date
    DateTime today = DateTime.now();

    // Check if the converted date is the same as today's date
    bool isBirthday = (date.day == today.day && date.month == today.month);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    bool birthday = sharedPreferences.getBool("isBirthday") ?? false;

    if (isBirthday == true && birthday == false) {
      if (all106ads.isNotEmpty) {
        Timer.run(() {
          showadsbar(context, all106ads, () {
            sharedPreferences.setBool("isBirthday", true);
            bool birthday = sharedPreferences.getBool("isBirthday")!;
            Navigator.pop(context);
          });
        });
      }
    } else {
      if (all8ads.isNotEmpty && is8Ads == true) {
        Timer.run(() {
          showadsbar(context, all8ads, () {
            Navigator.pop(context);
            is8Ads = false;
          });
        });
      } else if (allads.isNotEmpty && is9Ads == true) {
        Timer.run(() {
          showadsbar(context, allads, () {
            Navigator.pop(context);
            is9Ads = false;
          });
        });
      }
      if (userhomeads.isNotEmpty && is25Ads == true) {
        Timer.run(() {
          showadsbar(context, userhomeads, () {
            Navigator.pop(context);
            is25Ads = false;
          });
        });
      } else {
        if (all25ads.isNotEmpty && is25Ads == true) {
          Timer.run(() {
            showadsbar(context, all25ads, () {
              Navigator.pop(context);
              is25Ads = false;
            });
          });
        }
      }
    }
    if (isBirthday == false) {
      sharedPreferences.setBool("isBirthday", false);
    }
  }

  void getallads() async {
    all106ads = await AdsService().getallusers(adsid: "105");

    allads = await AdsService().getallusers(adsid: "9");
    all8ads = await AdsService().getallusers(adsid: "8");
    all25ads = await AdsService().getallusers(adsid: "25");
    userhomeads = adsuser.where((element) => element.adsid == "25").toList();
    print("number 8 ads $is8Ads");
    setState(() {});

    getbirthday();
  }

  @override
  void initState() {
    getnewads();
    getallads();
    HomeService().addtoken(email: userSave.email!, token:deviceToken!);
    setState(() {
      load = true;
    });
Get.put(NewCallController()); 
Get.put(AudioNewCallController()); 
Get.put(AudioSharingController()); 
    super.initState();
    getads();
    homeservice.getuserdata().whenComplete(() {
      getalluserlists();
    });
  }

  String? lastpage;
  pushChatPage(
    var roomid,
    var profiledata,
    var profilepic,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (maincontext) => Scaffold(
                body: MobileChatScreen(
                    roomid: roomid,
                    profileDetail: profiledata,
                    profilepic: profilepic),
              )),
    );
  }

  List<AdsModel> notiads = [];
  List<AdsModel> menuads = [];
  List<AdsModel> usermenuads = [];
  List<AdsModel> sliderads = [];
  List<AdsModel> usernotiads = [];
  List<AdsModel> usersliderads = [];
  void getads() async {
    usersliderads = adsuser.where((element) => element.adsid == "10").toList();
    usernotiads = adsuser.where((element) => element.adsid == "24").toList();
    usermenuads = adsuser.where((element) => element.adsid == "24").toList();
    notiads = await AdsService().getallusers(adsid: "90");
    sliderads = await AdsService().getallusers(adsid: "10");
    menuads = await AdsService().getallusers(adsid: "24");
    setState(() {});
  }

  int currentPage = 0;
  bool _ispageLoading = false;
  //  PageController controller = PageController(initialPage: 100,);
  PageController controller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    final NotificationController noticontroller = Get.find();
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        // key: scrollKey,
        // key: scrollKey,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              load == true
                  ? Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: mainColor,
                          ),
                          // Text(
                          //     "No data available according to preference \nKindly change your preference"),
                        ],
                      ),
                    )
                  : newuserlists.isEmpty
                      ? const SavePreferencesError(
                          isfirst: true,
                        )
                      : PageView.builder(
                          controller: controller,
                          onPageChanged: (index) async {
                            AddToProfileService().updateprofileviewer();
                            AddToProfileService().updateprofileviewed(
                                newuserlists[index]!.email);
                            if (widget.user_list == null ||
                                widget.user_list.isEmpty) {
                              if (index == newuserlists.length - 2) {
                                _ispageLoading = true;
                                setState(() {});
                                List<NewUserModel> getdata = await homeservice.getalluserdata(
                                    gender: userSave.gender == "male"
                                        ? "female"
                                        : "male",
                                    email: userSave.email!,
                                    religion: userSave.religion!,
                                    citylocation: homeservice
                                        .saveprefdata.value.citylocation,
                                    statelocation: homeservice
                                        .saveprefdata.value.statelocation,
                                    page: pagecount,
                                    ages:
                                        homeservice.saveprefdata.value.ageList,
                                    religionList: homeservice
                                        .saveprefdata.value.religionList,
                                    kundaliDoshList: homeservice
                                        .saveprefdata.value.kundaliDoshList,
                                    maritalStatusList: homeservice
                                        .saveprefdata.value.maritalStatusList,
                                    dietList:
                                        homeservice.saveprefdata.value.dietList,
                                    drinkList: homeservice
                                        .saveprefdata.value.drinkList,
                                    smokeList: homeservice
                                        .saveprefdata.value.smokeList,
                                    disabilityList: homeservice
                                        .saveprefdata.value.disabilityList,
                                    heightList: homeservice.saveprefdata.value.heightList,
                                    educationList: homeservice.saveprefdata.value.educationList,
                                    professionList: homeservice.saveprefdata.value.professionList,
                                    incomeList: homeservice.saveprefdata.value.incomeList,
                                    location: homeservice.saveprefdata.value.location);
                                List<NewUserModel> invisibleusers =
                                    await NotificationService()
                                        .getinvisibleusers(
                                            userid: invisibleuserFriend);
                                for (var i = 0;
                                    i < invisibleusers.length;
                                    i++) {
                                  getdata.remove(invisibleusers[i]);
                                }
                                List<Matchusermodel> profilematch =
                                    await Future.wait(
                                  getdata.map((user) async {
                                    double distance = await ProfileMatch()
                                        .getallusermatch(user);
                                    return Matchusermodel(
                                        kundalimatch: distance.toInt(),
                                        newUserModel: user);
                                  }),
                                );
                                profilematch.sort(
                                    (a, b) => b.kundalimatch - a.kundalimatch);

                                for (var i = 0; i < profilematch.length; i++) {
                                  newuserlists
                                      .add(profilematch[i].newUserModel);
                                }
                                pagecount++;
                                // newuserlists.addAll(getdata);
                                setState(() {});
                              }
                            }
                            _ispageLoading = false;

                            setState(() {});

                            if (index == newuserlists.length - 1) {
                              if (usersliderads.isNotEmpty) {
                                showadsbar(context, usersliderads, () {
                                  Navigator.pop(context);
                                });
                              } else {
                                if (sliderads.isNotEmpty) {
                                  showadsbar(context, sliderads, () {
                                    Navigator.pop(context);
                                  });
                                }
                              }
                              lastpage = "drink";
                              setState(() {});
                            }
                          },
                          itemBuilder: (BuildContext context, int index) {
                            if (index == newuserlists.length) {
                              // Show the SavePreferencesError widget at the end
                              return widget.notiPage == false
                                  ? const SavePreferencesError(
                                      isfirst: false,
                                    )
                                  : const SearchProfileError(
                                      issearchempty: true,
                                    );
                            } else {
                              return Column(children: <Widget>[
                                Expanded(
                                  child: ProfilePage(
                                      // list: userlist,
                                      index: index,
                                      userSave: newuserlists[index],
                                      controller: controller,
                                      pushchat: pushChatPage),
                                ),
                              ]);
                            }
                            // }
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: newuserlists.length,
                        ),
              (widget.notiPage)
                  ? Positioned(
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.04,
                      child: IconButton(
                        icon: Icon(
                          // Icons.more_vert_outlined,//for three dots
                          Icons.arrow_back_ios, //for three lines
                          size: 25,
                          color: mainColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  : Positioned(
                      left: MediaQuery.of(context).size.width * 0.0003,
                      top: MediaQuery.of(context).size.height * 0.034,
                      child: IconButton(
                        icon: const Icon(
                          Icons.menu, //for three lines
                          // FontAwesomeIcons.bars,
                          size: 25,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(color: Colors.black, blurRadius: 15.0)
                          ],
                        ),
                        onPressed: () async {
                          // HomeService()
                          //     .updatelogin(email: userSave.email!, mes: "true");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyProfile(
                                        profilepercentage:
                                            widget.profilepercentage,
                                      ))).whenComplete(() {});

                          if (usermenuads.isNotEmpty) {
                            showadsbar(context, usermenuads, () {
                              Navigator.pop(context);
                            });
                          } else {
                            if (menuads.isNotEmpty) {
                              showadsbar(context, menuads, () {
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
                      ),
                    ),
              (widget.notiPage)
                  ? const Positioned(
                      child: const SizedBox(
                      width: 0,
                      height: 0,
                    ))
                  : Positioned(
                      right: MediaQuery.of(context).size.width * 0.004,
                      top: MediaQuery.of(context).size.height * 0.04,
                      child: IconButton(
                        icon:Obx(
          () => Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              child: const Icon(
                                // Icons.more_vert_outlined,//for three dots
                                FontAwesomeIcons.bell, //for three lines
                                size: 25,
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(color: Colors.black, blurRadius: 15.0)
                                ],
                              ),
                            ),
                            if (noticontroller.unreadCount.value > 0)
                              Positioned(
                                right: 3,
                                top: 2.0,
                                child: Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 8.0,
                                    minHeight: 8.0,
                                  ),
                                  child: Center(
                                    child: Text(
                                      noticontroller.unreadCount.value.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )),
                        onPressed: () {
                          noticontroller.fetchUnreadCount();
                          setState(() {});
                          NotificationService().updatenumberofnoti();
                          NotificationService().addtoadminnotification(
                              userid: userSave.uid!,
                              useremail: userSave.email!,
                              subtitle: "",
                              userimage: userSave.imageUrls!.isEmpty
                                  ? "SEEN NOTIFICATIONS"
                                  : userSave.imageUrls![0],
                              title:
                                  "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEEN NOTIFICATIONS");
                          NotificationFunction.setNotification(
                            "admin",
                            "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SEEN NOTIFICATIONS",
                            'notificationbell',
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NavHome()));

                          if (usernotiads.isNotEmpty) {
                            showadsbar(context, usernotiads, () {
                              Navigator.pop(context);
                            });
                          } else {
                            if (notiads.isNotEmpty) {
                              showadsbar(context, notiads, () {
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
                      ),
                    ),
            ],
        ),
        ),
      ),
    );
  }
}

class MainAppContainer extends StatefulWidget {
  MainAppContainer(
      {super.key, this.user_data, this.user_list, required this.notiPage});
  final user_data;
  final user_list;
  bool notiPage = false;

  @override
  State<MainAppContainer> createState() => _MainAppContainerState();
}

class _MainAppContainerState extends State<MainAppContainer> {
  bool load = false;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  String? country;
  String? state;
  String? city;
  String? location;
  var lat;
  var lng;
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If location services are not enabled, prompt the user to enable them
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location Services Disabled"),
          content: const Text(
              "Location services are disabled. Please enable them in settings."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return; // Stop further execution
    }

    // Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // If permission is still denied, inform the user
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Permission Denied"),
            content: const Text(
                "Location permission is denied. Please enable it in settings."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
        return; // Stop further execution
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, guide the user to app settings
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permission Permanently Denied"),
          content: const Text(
              "Location permission is permanently denied. Please enable it in app settings."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings(); // Open app settings
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
      return; // Stop further execution
    }

    // Retrieve the current position
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      lat = position.latitude;
      lng = position.longitude;

      // Get address details
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      country = placemarks[0].country;
      state = placemarks[0].administrativeArea;
      city = placemarks[0].locality;

      // Construct the location string
      location =
          "${placemarks[0].locality}, ${placemarks[0].postalCode}, ${placemarks[0].country}";

      // Update the location in the backend if user details are available
      if (userSave.email != null && userSave.email!.isNotEmpty) {
        setState(() {});
        homeservice.updatelocation(
          lat: lat,
          lng: lng,
          email: userSave.email!,
          city: city!,
          country: country!,
          location: location!,
          state: state!,
        );
      }
    } catch (e) {
      // Handle any other unexpected errors
      if (kDebugMode) {
        print("Error fetching location: $e");
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to fetch location: $e"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If location services are not enabled, inform the user
      return Future.error(
          'Location services are disabled. Please enable them.');
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // If still denied, return error
        return Future.error('Location permission is denied. Please allow it.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // If permission is permanently denied, inform the user
      return Future.error(
          'Location permission is permanently denied. Please enable it in the app settings.');
    }

    // If permissions are granted, get the current position
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return Future.error('Failed to get location: $e');
    }
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Icon(
            Icons.error,
            color: mainColor,
          ),
          content: const Text('No Internet Connection'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                if (!mounted) return;
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  if (!mounted) return;
                  setState(() => isAlertSet = true);
                }
              },
              child: Text(
                'OK',
                style: TextStyle(color: mainColor),
              ),
            )
          ],
        ),
      );
  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (List<ConnectivityResult> result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            if (!mounted) return;
            setState(() => isAlertSet = true);
          }
        },
      );

  NotificationData notificationData = NotificationData();
  @override
  void initState() {
    NotificationData().requestNotificationPermission();
    NotificationData().requestNotificationPermission();

    getprecentage();
    notificationData.setupInteractMessage(context);
    getCurrentLocation();
    getuserdata();
    determinePosition();

    super.initState();
  }

  NewUserModel? usermodel;
  HomeService homeservice = Get.put(HomeService());
  void getuserdata() async {
    usermodel = await HomeService().getuserdata();
    setState(() {});
  }

  int profilepercentage = 0;
  ProfileCompletion profile = ProfileCompletion();
  void getprecentage() async {
    profilepercentage = await profile.profileComplete();
    userProfilePercentage = profilepercentage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: SlideProfile(
              user_data: usermodel,
              profilepercentage: profilepercentage,
              notiPage: widget.notiPage,
              user_list: widget.user_data,
            )));
  }
}

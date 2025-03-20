import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/error/save_pref_error.dart';
import 'package:ristey/screens/error/search_profile_error.dart';
import 'package:ristey/screens/mobile_chat_screen.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/notification/nav_home.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/profile_page.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/send_utils/noti_function.dart';
import 'package:ristey/services/search_service.dart';
import 'package:ristey/small_functions/profile_completion.dart';

var profiledata;

class UserSearchSlideProfile extends StatefulWidget {
  UserSearchSlideProfile(
      {super.key,
      this.type = "",
      this.user_data,
      this.user_list,
      this.forIos,
      this.currentSliderValue,
      required this.profilepercentage,
      required this.ages,
      required this.religionList,
      required this.kundaliDoshList,
      required this.maritalStatusList,
      required this.dietList,
      required this.drinkList,
      required this.smokeList,
      required this.disabilityList,
      required this.heightList,
      required this.educationList,
      required this.professionList,
      required this.incomeList,
      required this.statelocation,
      required this.citylocation,
      required this.location,
      required this.notiPage});
  String type;
  var user_data;
  int profilepercentage;
  bool notiPage = false;
  var user_list;
  final List<String> ages;
  bool? forIos;
  int? currentSliderValue;
  final List<dynamic> religionList;
  final List<dynamic> kundaliDoshList;
  final List<dynamic> maritalStatusList;
  final List<dynamic> dietList;
  final List<dynamic> drinkList;
  final List<dynamic> smokeList;
  final List<dynamic> disabilityList;
  final List<dynamic> heightList;
  final List<dynamic> educationList;
  final List<dynamic> professionList;
  final List<dynamic> incomeList;

  final List<dynamic> statelocation;
  final List<dynamic> citylocation;
  final List<dynamic> location;
  @override
  State<UserSearchSlideProfile> createState() => _SlideProfileState();
}

class _SlideProfileState extends State<UserSearchSlideProfile> {
  int num = 6;
  int pagecount = 2;
  int profilepercentage = 0;
  bool load = false;
  DatabaseReference? _notificationsRef;
  int _unreadCount = 0;
  // User userSave = User();
  List<User> userlist = [];
  List<User> largeuserlist = [];
  List<NewUserModel?> newuserlists = [];
  bool nodata = false;
  QueryDocumentSnapshot? lastDocument;
  HomeService homeservice = Get.put(HomeService());
  ProfileCompletion profile = ProfileCompletion();
  void getalluserlists() async {
    newuserlists = widget.user_data!;
    setState(() {});
  }

  @override
  void initState() {
    setState(() {
      load = true;
    });
    // print("Page is Running");
    super.initState();
    getads();

    getalluserlists();
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
  List<AdsModel> sliderads = [];
  List<AdsModel> usernotiads = [];
  List<AdsModel> usersliderads = [];
  void getads() async {
    usersliderads = adsuser.where((element) => element.adsid == "15").toList();
    usernotiads = adsuser.where((element) => element.adsid == "3").toList();
    notiads = await AdsService().getallusers(adsid: "15");
    sliderads = await AdsService().getallusers(adsid: "3");
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        // key: scrollKey,
        // key: scrollKey,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              // load == true
              //     ? Center(
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             CircularProgressIndicator(
              //               color: mainColor,
              //             ),
              //             // Text(
              //             //     "No data available according to preference \nKindly change your preference"),
              //           ],
              //         ),
              //       )
              //     :
              newuserlists.isEmpty
                  ?
                  // ? Center(
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: const [
                  //         // CircularProgressIndicator(),
                  //         Text(
                  //             "No data available according to preference \nKindly change your preference"),
                  //       ],
                  //     ),
                  //   )
                  SavePreferencesError(
                      isfirst: true,
                    )
                  :
//
                  PageView.builder(
                      controller: controller,
                      onPageChanged: (index) async {
                        // if (widget.user_list == null ||
                        //     widget.user_list.isEmpty) {
                        if (index == newuserlists.length - 5) {
                          print("*************");
                          print("hello");
                          print("****************");
                          _ispageLoading = true;
                          setState(() {});
                          List<NewUserModel> getdata = await Searchservice()
                              .searchuserdata(
                                  maxDistanceKm:
                                      widget.currentSliderValue!.toInt(),
                                  gender: userSave.gender == "male"
                                      ? "female"
                                      : "male",
                                  email: userSave.email!,
                                  religion: userSave.email!,
                                  page: pagecount,
                                  ages: widget.ages,
                                  religionList: widget.religionList,
                                  kundaliDoshList: widget.kundaliDoshList,
                                  maritalStatusList: widget.maritalStatusList,
                                  dietList: widget.dietList,
                                  drinkList: widget.drinkList,
                                  smokeList: widget.smokeList,
                                  disabilityList: widget.disabilityList,
                                  heightList: widget.heightList,
                                  educationList: widget.educationList,
                                  professionList: widget.professionList,
                                  incomeList: widget.incomeList,
                                  citylocation: widget.citylocation,
                                  statelocation: widget.statelocation,
                                  location: widget.location);

                          pagecount++;
                          newuserlists.addAll(getdata);
                          setState(() {});
                          // }
                        }
                        _ispageLoading = false;
                        setState(() {});

                        if (index == newuserlists.length - 1) {
                          if (sliderads.isNotEmpty) {
                            showadsbar(context, sliderads, () {
                              Navigator.pop(context);
                            });
                          }
                          if (usersliderads.isNotEmpty) {
                            showadsbar(context, usersliderads, () {
                              Navigator.pop(context);
                            });
                          }
                          lastpage = "drink";
                          setState(() {});
                        }
                      },
                      itemBuilder: (BuildContext context, int index) {
                        // if (_ispageLoading == true) {
                        //   return Center(
                        //     child: CircularProgressIndicator(
                        //       color: mainColor,
                        //     ),
                        //   );
                        // } else {
                        if (index == newuserlists.length) {
                          // Show the SavePreferencesError widget at the end
                          return widget.notiPage == false
                              ? SavePreferencesError(
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
                      itemCount: newuserlists.length + 1,
                    ),
              //               PageView.builder(

              //                   controller: controller,
              //                   onPageChanged: (index) {
              //                      if(index==newuserlists.length){
              //                       print("hi");
              //                      }
              //                   },
              //                   itemBuilder: (BuildContext context, int index) {
              //                     final userIndex = index % newuserlists.length;
              // final user = newuserlists[userIndex];
              // print("lkajsdflkj");
              // print(userIndex);
              // print(index);
              //  print("lkajsdflkj");
              //                     return Column(children: <Widget>[

              //                       Expanded(
              //                         child: ProfilePage(
              //                             // list: newuserlists,
              //                             index: index,
              //                             userSave: user,
              //                             controller: controller,
              //                             pushchat: pushChatPage),
              //                       ),

              //                     ]);
              //                   },
              //                 ),

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
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.04,
                      child: IconButton(
                        icon: const Icon(
                          // Icons.more_vert_outlined,//for three dots
                          Icons.menu, //for three lines
                          size: 20,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(color: Colors.black, blurRadius: 15.0)
                          ],
                        ),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyProfile(
                                        profilepercentage:
                                            widget.profilepercentage,
                                      )));

                          // builder: (context) => const CallSample()));

                          // Get.to(() => const MyProfile(),
                          //     transition: Transition.zoom);
                        },
                      ),
                    ),
              (widget.notiPage)
                  ? Positioned(
                      child: SizedBox(
                      width: 0,
                      height: 0,
                    ))
                  : Positioned(
                      right: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.04,
                      child: IconButton(
                        icon: Stack(
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
                            if (_unreadCount > 0)
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
                                      _unreadCount.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onPressed: () {
                          if (notiads.isNotEmpty) {
                            showadsbar(context, notiads, () {
                              Navigator.pop(context);
                              _unreadCount = 0;
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
                            });
                          }
                          if (usernotiads.isNotEmpty) {
                            showadsbar(context, usernotiads, () {
                              Navigator.pop(context);
                              _unreadCount = 0;
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
                            });
                          } else {
                            _unreadCount = 0;
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
                          }
                        },
                      ),
                    ),
              /*Positioned(
                  right: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.height * 0.08,
                  child: IconButton(
                    FontAwesomeIcons.bell,
                    size: 20,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(color: Colors.black, blurRadius: 10.0)
                    ],
    //
                  ),
                ),*/
            ],
          ),
        ),
      ),
    );
  }
}

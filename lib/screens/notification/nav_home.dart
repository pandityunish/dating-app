import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/activities_modal.dart';
import 'package:ristey/models/notification_modal.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/notification/Widget_Notification/activity_widget.dart';
import 'package:ristey/screens/notification/widget_notification/notification_widget.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/send_utils/noti_modal.dart';

class NavHome extends StatefulWidget {
  const NavHome({Key? key}) : super(key: key);

  @override
  State<NavHome> createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome> with TickerProviderStateMixin {
  DocumentSnapshot? lastDocument;
  late DatabaseReference _dbref;
  late DatabaseReference _dbref2;
  // late TabController _tabController;
  int index = 0;
  // DateTime time2 = DateTime.now();
  List<NotificationModel> notificationslist = [];
  List<ActivitiesModel> activitylist = [];
  List<NotificationModel> tempnotificationslist = [];
  List<ActivitiesModel> tempactivitylist = [];
  List<ActivitiesModel> user1activitylist = [];
  List<ActivitiesModel> user2activitylist = [];
  NotifyModel temp = NotifyModel();

  void getads() async {
    navunblockads = await AdsService().getallusers(adsid: "97");
    interestads = await AdsService().getallusers(adsid: "91");
    cancelinterestads = await AdsService().getallusers(adsid: "92");
    receiveinterestads = await AdsService().getallusers(adsid: "93");
    acceptinterestads = await AdsService().getallusers(adsid: "94");
    declineads = await AdsService().getallusers(adsid: "95");
    navblockads = await AdsService().getallusers(adsid: "96");
    navreportads = await AdsService().getallusers(adsid: "98");
    navunreportads = await AdsService().getallusers(adsid: "99");
    navsortlistads = await AdsService().getallusers(adsid: "100");
    navunsortlistads = await AdsService().getallusers(adsid: "101");

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getads();
    homeService.getuserdata().whenComplete(() {
      setlist();
    });
    // paginatedData();
    // _tabController = TabController(length: 2, vsync: this);
    _dbref = FirebaseDatabase.instance.ref();
    _dbref2 = FirebaseDatabase.instance.ref();
    _dbref = _dbref.child('user1');
    _dbref2 = _dbref2.child('user2');
  }

  HomeService homeService = Get.put(HomeService());
  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }

  setlist() async {
    await setdata();
    await setUserSeconddata();
  }

  setdata() async {
    notificationslist.addAll(notificationslists);
    notificationslist.sort(
      (a, b) => b.datetime.compareTo(a.datetime),
    );
    tempnotificationslist.addAll(notificationslist);
    setState(() {});
    print("$notificationslist hello");
  }

  setUserSeconddata() async {
    print(userSave.status);
    // if (userSave.status == "approved") {
    print("ok");
    setState(() {
      activitieslists.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
      activitieslists.removeWhere((element) => element.delete == true);
      activitylist.addAll(activitieslists);
      tempactivitylist.addAll(activitieslists);

      print(activitylist);
      activitylist.sort((b, a) => a.createdAt.compareTo(b.createdAt));
    });
    // }
    setState(() {});
    print(activitieslists);
  }

  late List<Map<dynamic, dynamic>> _searchResults = [];

  TextEditingController _searchController = TextEditingController();

  void _search(String searchText) {
    if (index == 0) {
      notificationslist.clear();
      if (searchText.isEmpty) {
        for (var element in tempnotificationslist) {
          notificationslist.add(element);
        }

        // setState(() {});
        return;
      } else {
        for (var element in tempnotificationslist) {
          if (element.title.toLowerCase().contains(searchText.toLowerCase())) {
            notificationslist.add(element);
          }
        }
      }
    } else {
      activitylist.clear();
      if (searchText.isEmpty) {
        for (var element in tempactivitylist) {
          activitylist.add(element);
        }
        return;
      } else {
        for (var element in tempactivitylist) {
          if (element.title.toLowerCase().contains(searchText.toLowerCase())) {
            activitylist.add(element);
          }
        }
      }
    }
    setState(() {});
  }

  bool isMoreData = true;
  List<Map<String, dynamic>> notification_list = [];
  void paginatedData() async {
    if (isMoreData) {
      final collectionReference =
          FirebaseFirestore.instance.collection("notifications");
      late QuerySnapshot<Map<String, dynamic>> querySnapshot;
      if (lastDocument == null) {
        querySnapshot = await collectionReference.limit(15).get();
      } else {
        querySnapshot = await collectionReference
            .limit(15)
            .startAfterDocument(lastDocument!)
            .get();
      }

      lastDocument = querySnapshot.docs.last;
      notification_list.addAll(querySnapshot.docs.map((e) => e.data()));
      setState(() {});
      if (querySnapshot.docs.length < 15) {
        isMoreData = false;
      } else {
        print("No More Data");
      }
    }
  }

  int value = 0;
  String dropdownvalue = 'ALL';
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   paginatedData();
  // }

  List<String> items = []; // list to store the fetched data from firebase
  List<String> filteredItems = []; // list to store the filtered data
  // method to filter the items based on user input

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: CupertinoPageScaffold(
          child:DefaultTabController(
                  initialIndex: 0,
                  length: 2,

                  child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(170),
                        child: AppBar(
                          flexibleSpace: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageIcon(
                                  AssetImage('images/icons/notification.png'),
                                  size: 30,
                                  color: mainColor,
                                ),

                                DefaultTextStyle(
                                  style: TextStyle(
                                    color: mainColor,
                                    fontFamily: 'Sans-serif',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                  child: Text("Notifications"),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: CupertinoSearchTextField(
                                    controller: _searchController,
                                    onSubmitted: (value) {
                                      _search(value);
                                    },
                                    // onChanged: (value) {},
                                    onSuffixTap: () {
                                      setState(() {
                                        _searchController.clear();
                                      });
                                      _search(_searchController.text);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                // actions: [CupertinoSearchTextField(
                                //   controller: _searchController,
                                //   onChanged: _search,
                                // ),],
                              ],
                            ),
                          ),
                          leading: GestureDetector(
                              onTap: () {
                                HomeService().getuserdata().whenComplete(() {
                                  Navigator.of(context).pop();
                                });
                                setState(() {});
                              },
                              child:
                                  Icon(Icons.arrow_back_ios, color: mainColor)),
                          backgroundColor: Colors.white,
                          bottom: TabBar(
                            onTap: (index) {
                              // Handle tab selection

                              setState(() {
                                this.index = index;
                              });
                              print('Selected tab index: $index');
                            },
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: mainColor,
                            tabs: <Widget>[
                              Tab(

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Notifications',
                                        style: TextStyle(
                                            color: mainColor,
                                            fontFamily: 'Sans-serif',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                    SizedBox(width: 5),
                                    Container(
                                      height: 15,
                                      width: 15,
                                      padding: EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 10.0,
                                        minHeight: 10.0,
                                      ),
                                      child: Text(
                                        '${notificationslist.length}',
                                        // '$_unreadCount',
                                        textAlign: TextAlign.center,
                                        style:const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Activities',
                                        style: TextStyle(
                                            color: mainColor,
                                            fontFamily: 'Sans-serif',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                    SizedBox(width: 5),
                                    Container(
                                      height: 15,
                                      width: 15,
                                      padding: EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 10.0,
                                        minHeight: 10.0,
                                      ),
                                      child: Text(
                                        '${activitylist.length}',
                                        // '$_unreadCount',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            labelColor: Colors.black,
                          ),
                        ),
                      ),
                      body:  notificationslist.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(
                        AssetImage('images/icons/notification.png'),
                        size: 100,
                        color: mainColor,
                      ),
                       Text(
                        "No Notification",
                        style: TextStyle(
                          color: mainColor,
                          fontFamily: 'Sans-serif',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
              :  TabBarView(children: [
                        Container(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Column(children: [
                                ListView.builder(
                                  itemCount: _searchResults.isEmpty
                                      ? notificationslist.length
                                      : _searchResults.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return NotificationWidget2(
                                      list: _searchResults.isEmpty
                                          ? notificationslist
                                          : _searchResults,
                                      index: index,
                                      notiData: NotifyModel(
                                          text: notificationslist[index].title,
                                          time: notificationslist[index]
                                              .datetime),
                                    );
                                  },
                                ),
                              ]),
                            ),
                          ),
                        ),
                        Container(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Column(children: [
                                ListView.builder(
                                    itemCount: activitylist.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return NotificationWidget3(
                                        onclick: () {
                                          NotificationService()
                                              .deleteactivities(
                                                  notiId:
                                                      activitylist[index].id,
                                                  userid: userSave.uid!);
                                          activitylist
                                              .remove(activitylist[index]);
                                          setState(() {});
                                        },
                                        activitiesModel: activitylist[index],
                                        list: _searchResults.isEmpty
                                            ? notification_list
                                            : _searchResults,
                                        index: index,
                                        adslist: activitylist[index]
                                                .title
                                                .contains("UNBLOCKED")
                                            ? navunblockads
                                            : activitylist[index]
                                                    .title
                                                    .contains("BLOCKED")
                                                ? navblockads
                                                : activitylist[index]
                                                        .title
                                                        .contains(
                                                            "INTEREST SUCCESSFULLY SENT")
                                                    ? interestads
                                                    : activitylist[index]
                                                            .title
                                                            .contains("CANCEL")
                                                        ? cancelinterestads
                                                        : activitylist[index]
                                                                .title
                                                                .contains(
                                                                    "RECEIVE")
                                                            ? receiveinterestads
                                                            : activitylist[
                                                                        index]
                                                                    .title
                                                                    .contains(
                                                                        "ACCEPT")
                                                                ? acceptinterestads
                                                                : activitylist[
                                                                            index]
                                                                        .title
                                                                        .contains(
                                                                            "DECLINE")
                                                                    ? declineads
                                                                    : activitylist[index]
                                                                            .title
                                                                            .contains("UNREPORTED")
                                                                        ? navunreportads
                                                                        : activitylist[index].title.contains("REPORTED")
                                                                            ? navreportads
                                                                            : activitylist[index].title.contains("UNSHORTLISTED")
                                                                                ? navunsortlistads
                                                                                : activitylist[index].title.contains("SHORTLISTED")
                                                                                    ? navsortlistads
                                                                                    : [],
                                        // notiData: NotifyModel(),
                                      );
                                    }),
                              ]),
                            ),
                          ),
                        )
                      ])))),
    );
  }
}

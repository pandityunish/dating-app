import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ristey/chat/screens/free_chat_screen.dart';
import 'package:ristey/chat/widget/chat_list_tile.dart';
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/chat_modal.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/navigation/fpm/components/matching_component.dart';
import 'package:ristey/screens/navigation/fpm/screens/live_astro_screen.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MobileLayoutScreen extends StatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen> {
  late List<ChatsModel> _searchResults = [];
  late List<ChatsModel> _tempres = [];

  TextEditingController _searchController = TextEditingController();
  User? Profile2;
  String nameofuser = "";
  List<String> username = [];

  List<AdsModel> matchads = [];
  List<AdsModel> astroads = [];
  List<AdsModel> userads = [];
  void getads() async {
    matchads = await AdsService().getallusers(adsid: "43");
    astroads = await AdsService().getallusers(adsid: "46");
    userads = await AdsService().getallusers(adsid: "49");
    setState(() {});
  }

  void _search(String searchText) {
    print("ok");
    // message.clear();
    // setState(() {

    // });
    if (searchText.isEmpty) {
      message.clear();
      for (var element in _tempres) {
        message.add(element);
        setState(() {});
      }

      return;
    } else {
      print(username);
      print(searchText);
      print(Profile2!.name);
      for (var element in _tempres) {
        // print(searchText.toString());
        if (nameofuser.toLowerCase().contains(searchText.toLowerCase())) {
          print(searchText);
          setState(() {
            message.add(element);
          });
        }
      }
    }

    // setState(() {});
  }

  late DatabaseReference _dbref;
  // var res = [];
  @override
  initState() {
    super.initState();
    getads();
    // print("initstate run");
    // _dbref = FirebaseDatabase.instance.ref();

    message.sort((b, a) => a.lasttime.compareTo(b.lasttime));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(message);
      connect();
      setData();
    });
  }

  setData() {
    _tempres.addAll(message);
    for (var i = 0; i < message.length; i++) {
      username.add(message[i].username);
    }
    setState(() {});
  }

  String? lastmessage;
  String? senderuid;
  int? time;
  int numberofunreadmes = 0;
  IO.Socket socket = IO.io("$baseurl/chat", <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
    'force new connection': true,
  });
  void connect() {
    // MessageModel messageModel = MessageModel(sourceId: widget.sourceChat.id.toString(),targetId: );
    socket.connect();
    print("${socket.connected} hello");
    // socket.emit("signin", widget.profileDetail.id);
    socket.emit("signin", userSave.uid);
    socket.onConnect((data) {
      print("Connected");

      socket.on("message", (mes) {
        print(mes);
        lastmessage = "";
        senderuid = "";
        time = 0;
        numberofunreadmes = 0;
        print("kc");
        lastmessage = mes["message"];
        senderuid = mes["uid"];
        time = mes["time"];
        numberofunreadmes++;
        //  message.clear();
        // HomeService().getuserdata();
        setState(() {});

        if (mes["message"] == "Block by user") {
          // blocklists.add(userSave.uid);
        }
        if (mes["message"] == "Unblock by user") {}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print()
    return DefaultTabController(
      length: 3,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
               preferredSize: const Size.fromHeight(100),
              child: AppBar(
                  flexibleSpace: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ImageIcon(
                                      AssetImage('images/icons/chat.png'),
                                      size: 25,
                                      color: mainColor,
                                    ),
              
                                    DefaultTextStyle(
                                      style: TextStyle(
                                        color: mainColor,
                                        fontFamily: 'Sans-serif',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                      child: Text("Chatnow"),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: CupertinoSearchTextField(
                                                        controller: _searchController,
                                                        onChanged: (value) {
                                                          setState(() {});
                                                        },
                                                        // onSubmitted: (value) {
                                                        //   _search(_searchController.text);
                                                        // },
                                                        onSuffixTap: () {
                                                          setState(() {
                                                            _searchController.clear();
                                                          });
                                                          _search(_searchController.text);
                                                        },
                                                      ),
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (builder) => const MyProfile(
                              profilepercentage: 50,
                            )));
                    // Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: mainColor,
                  ),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                centerTitle: true,
              
              ),
            ),
            // body: const ContactsList(),
            body: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                   
                    // ContactsList(
                    //   res: message,
                    // ),\
                
                    GestureDetector(
                        onTap: () {
                          Get.to(FreeChatScreen(
                            id: "Live Matchmaker",
                          ));
                          if (matchads.isNotEmpty) {
                            showadsbar(context, matchads, () {
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: MatchingComponents(
                          title: "Live Matchmaker",
                        )),
                    GestureDetector(
                        onTap: () {
                          Get.to(LiveAstroScreen(
                            id: "Live Astrologer",
                          ));
                          if (astroads.isNotEmpty) {
                            showadsbar(context, astroads, () {
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: MatchingComponents(
                          title: "Live Astrologer",
                        )),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      padding: const EdgeInsets.only(top: 0.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              // itemCount: info.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: message.length,
                              itemBuilder: (context, index) {
                                // print(widget.res.length);
          
                                final nameuser = message[index].username;
          
                                if (_searchController.text.isEmpty) {
                                  return ChatlistTile(
                                    res: message[index],
                                    message: lastmessage,
                                    senderuid: senderuid,
                                    time: time,
                                  );
                                } else if (nameuser.toLowerCase().contains(
                                    _searchController.text.toLowerCase())) {
                                  return ChatlistTile(res: message[index]);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

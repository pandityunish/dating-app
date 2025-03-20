import 'package:flutter/material.dart';
import 'package:ristey/models/activities_modal.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/chat_modal.dart';
import 'package:ristey/models/notification_modal.dart';
import 'package:ristey/models/shared_pref.dart';
import 'package:ristey/models/user_modal.dart';

const appBuildNo = 'v16';
BuildContext? contextmain = NavigationService.navigatorKey.currentContext;
String capitalize(String input) {
  if (input.isEmpty) return input;
  return input.split(' ').map((str) {
    if (str.isNotEmpty) {
      return str[0].toUpperCase() + str.substring(1).toLowerCase();
    } else {
      return str;
    }
  }).join(' ');
}

//step 1 : stateless widget dala
class BigText extends StatelessWidget {
  Color? color; //?--it is so that color is optional
  final String text;
  double? size;
  TextOverflow overflow;
  var fontWeight;

  BigText(
      {Key? key,
      this.color = const Color(0xFF2C3333),
      required this.text,
      this.size = 20,
      this.fontWeight = FontWeight.w400,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
          fontFamily: 'Sans-serif',
          color: color,
          fontWeight: fontWeight,
          fontSize: size),
    );
  }
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> scrollKey = GlobalKey<ScaffoldState>();

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

String? deviceToken;
bool isLogin = false;
var uid = "";
bool is9Ads = false;
bool is8Ads = false;
bool is25Ads = false;
User userSave = User();
String isLogoutString = ""; //data of user
SharedPref sharedPref = SharedPref();
List<NotificationModel> notificationslists = [];
List<ActivitiesModel> activitieslists = [];
List<ChatsModel> message = [];
List<dynamic> unseenmessages = [];
List<AdsModel> adsuser = [];
List<dynamic>? selectedCounty = [];
List<dynamic>? selectedCity = [];
List<dynamic>? selectedState = [];
List<dynamic> unapprovefriends = [];
List<dynamic> sendlinks = [];
int userProfilePercentage = 50;
List<dynamic> friends = []; //sent requests
List<dynamic> friendr = []; //received requests
List<dynamic> frienda = []; //accepted requests
List<String> friendrej = []; //rejected requests
FriendList? fl; //friend list
Blocklist? bl; //block listh
List<dynamic> blocFriend = []; //blocked users
ReportList? rl; //block list
List<dynamic> reportFriend = []; //blocked users
ReportList? sl; //block list
List<dynamic> shortFriend = []; //blocked users
List<dynamic> invisibleuserFriend = [];
List<dynamic> boostprofileuids = [];
ImageList imgDict = ImageList(imageDictionary: {});
List<AdsModel> kundaliads = [];
List<AdsModel> userkundaliads = [];
List<AdsModel> logoutads = [];
List<AdsModel> searchads = [];
List<AdsModel> savePreferads = [];
List<AdsModel> userprofileads = [];
List<AdsModel> profileads = [];
List<AdsModel> userbioads = [];
List<AdsModel> onlineads = [];
List<AdsModel> bioads = [];
List<AdsModel> usersupportads = [];
List<AdsModel> supportads = [];
List<AdsModel> chatads = [];
List<AdsModel> marriageloanads = [];
List<AdsModel> shareads = [];
List<AdsModel> deleteads = [];
List<AdsModel> editads = [];

List<AdsModel> usermatchmakingads = [];
List<AdsModel> matchmakingads = [];
List<AdsModel> userhomeads = [];
List<AdsModel> homeads = [];
List<AdsModel> sentreqads = [];
List<AdsModel> blockads = [];
List<AdsModel> reportads = [];
List<AdsModel> acceptads = [];
List<AdsModel> useracceptads = [];
List<AdsModel> unblockads = [];
List<AdsModel> unreportads = [];
List<AdsModel> unsortlistads = [];
List<AdsModel> userunblockads = [];
List<AdsModel> userunreportads = [];
List<AdsModel> userunsortlistads = [];
List<AdsModel> navunblockads = [];
List<AdsModel> interestads = [];
List<AdsModel> cancelinterestads = [];
List<AdsModel> receiveinterestads = [];
List<AdsModel> acceptinterestads = [];
List<AdsModel> declineads = [];
List<AdsModel> navblockads = [];
List<AdsModel> navreportads = [];
List<AdsModel> navunreportads = [];
List<AdsModel> navsortlistads = [];
List<AdsModel> navunsortlistads = [];
List<AdsModel> rejectads = [];
List<AdsModel> sortlistads = [];
List<AdsModel> usersentreqads = [];
List<AdsModel> userblockads = [];
List<AdsModel> userreportads = [];
List<AdsModel> usersortlistads = [];
Color mainColor = const Color(0xFF38B9F4);
Color newtextColor=const Color(0xFF999999);
SavedPref savedPref = SavedPref();
var fontSize2 = 16;
var fontSize1 = 20;
bool messageSend = false;
String lastConnectTime = "";
int numsentreq = 0;
int numberofcancelrequest = 1;
int numberofblock = 1;
int numberofreport = 1;
int numberofsortlist = 1;
int numberofunblock = 1;
int numberofunreport = 1;
int numberofunsortlist = 1;
int numberofabout = 1;
int numberofpref = 1;
String uploadimageurl = "";
String videoimageurl = "";
String audiourl = "";
List<String> yearList = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];
bool isUrl(String text) {
  final Uri? uri = Uri.tryParse(text);
  return uri != null && (uri.isAbsolute && uri.hasScheme && uri.hasAuthority);
}

bool isImageUrl(String url) {
  final RegExp imageRegExp =
      RegExp(r'\.(jpg|jpeg|png|gif|bmp|webp)$', caseSensitive: false);
  return imageRegExp.hasMatch(url);
}

bool isVideoUrl(String url) {
  final RegExp videoRegExp =
      RegExp(r'\.(mp4|avi|mov|wmv|flv|mkv|webm)$', caseSensitive: false);
  return videoRegExp.hasMatch(url);
}

bool isAudioUrl(String url) {
  final RegExp audioRegExp =
      RegExp(r'\.(mp3|wav|aac|flac|ogg|m4a)$', caseSensitive: false);
  return audioRegExp.hasMatch(url);
}

String identifyTextType(String text) {
  if (isUrl(text)) {
    if (isImageUrl(text)) {
      return "Image URL";
    } else if (isVideoUrl(text)) {
      return "Video URL";
    } else if (isAudioUrl(text)) {
      return "Audio URL";
    } else {
      return "Website URL";
    }
  } else {
    return "Simple Text";
  }
}

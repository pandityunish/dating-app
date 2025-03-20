import 'dart:convert';

import 'package:ristey/models/activities_modal.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/chat_modal.dart';
import 'package:ristey/models/notification_modal.dart';

class NewUserModel {
  String aboutme;
  String id;
  String timeofbirth;
  String placeofbirth;
  String diet;
  String disability;
  String drink;
  String education;
  String height;
  String income;
  String patnerprefs;
  String smoke;
  String displayname;
  String email;
  String religion;
  String name;
  String surname;
  String phone;
  String gender;
  String kundalidosh;
  String martialstatus;
  String profession;
  String location;
  String city;
  String state;
  List<dynamic> imageurls;
  List<dynamic> blocklists;
  List<dynamic> reportlist;
  List<dynamic> shortlist;
  List<dynamic> sendlinks;
  String country;
  String token;
  String isLogOut;
  String puid;
  int dob;
  String age;
  double lat;
  double lng;
  String verifiedstatus;
  List<dynamic> pendingreq;
  List<dynamic> sendreq;
  List<dynamic> friends;
  List<dynamic> unapprovedSendlists;
  String videolink;
  String status;
  List<NotificationModel> notifications;
  List<ActivitiesModel> activities;
  List<ChatsModel>? chats;
  List<dynamic> invisibleprofile;
  List<dynamic> boostprofile;
  // List<dynamic> unseenmessages;
  List<AdsModel> showads;
  bool? isBlur;
  NewUserModel({
    required this.aboutme,
    this.isBlur,
    required this.id,
    required this.showads,
    required this.invisibleprofile,
    required this.boostprofile,
    required this.unapprovedSendlists,
    required this.chats,
    required this.placeofbirth,
    required this.sendlinks,
    required this.timeofbirth,
    required this.diet,
    required this.disability,
    required this.drink,
    required this.isLogOut,
    required this.status,
    required this.education,
    required this.height,
    required this.income,
    required this.patnerprefs,
    required this.smoke,
    required this.displayname,
    required this.email,
    required this.religion,
    required this.name,
    required this.surname,
    required this.phone,
    required this.gender,
    required this.kundalidosh,
    required this.martialstatus,
    required this.profession,
    required this.location,
    required this.city,
    required this.state,
    required this.imageurls,
    required this.blocklists,
    required this.reportlist,
    required this.shortlist,
    required this.country,
    required this.token,
    required this.puid,
    required this.dob,
    required this.age,
    required this.lat,
    required this.lng,
    required this.verifiedstatus,
    required this.pendingreq,
    required this.sendreq,
    required this.friends,
    required this.videolink,
    required this.notifications,
    required this.activities,
    // required this.unseenmessages
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'age': age,
      'notifications': notifications,
      'aboutme': aboutme,
      'chats': chats,
      '_id': id,
      'showads': showads,
      'boostprofile': boostprofile,
      'invisibleprofile': invisibleprofile,
      'isLogOut': isLogOut,
      'status': status,
      'isBlur': isBlur,
      'pendingreq': pendingreq,
      'sendreq': sendreq,
      'puid': puid,
      'friends': friends,
      'videolink': videolink,
      'verifiedstatus': verifiedstatus,
      'diet': diet,
      'disability': disability,
      'timeofbirth': timeofbirth,
      'placeofbirth': placeofbirth,
      'lat': lat,
      'lng': lng,
      'drink': drink,
      'education': education,
      'height': height,
      'income': income,
      'patnerprefs': patnerprefs,
      'smoke': smoke,
      'displayname': displayname,
      'email': email,
      'religion': religion,
      'name': name,
      'surname': surname,
      'phone': phone,
      'gender': gender,
      'kundalidosh': kundalidosh,
      'martialstatus': martialstatus,
      'profession': profession,
      'location1': location,
      'city': city,
      'state': state,
      'imageurls': imageurls,
      'blocklists': blocklists,
      'reportlist': reportlist,
      'shortlist': shortlist,
      'country': country,
      'token': token,
      'dob': dob,
      'sendlink': sendlinks,
      'unapprovedSendlists': unapprovedSendlists
    };
  }

  factory NewUserModel.fromMap(Map<String, dynamic> map) {
    return NewUserModel(
      age: map["age"] as String,
      aboutme: map['aboutme'] as String,
      puid: map["puid"] as String,
      isLogOut: map["isLogOut"] as String,
      placeofbirth: map['placeofbirth'] as String,
      timeofbirth: map['timeofbirth'] as String,
      status: map['status'] as String,
      id: map['_id'] as String,
      verifiedstatus: map['verifiedstatus'] as String,
      videolink: map['videolink'] as String,
      diet: map['diet'] as String,
      lng: map['lng'] as double,
      lat: map['lat'] as double,
      disability: map['disability'] as String,
      isBlur: map['isBlur'] as bool,
      drink: map['drink'] as String,
      education: map['education'] as String,
      height: map['height'] as String,
      income: map['income'] as String,
      patnerprefs: map['patnerprefs'] as String,
      smoke: map['smoke'] as String,
      displayname: map['displayname'] as String,
      email: map['email'] as String,
      religion: map['religion'] as String,
      name: map['name'] as String,
      surname: map['surname'] as String,
      phone: map['phone'] as String,
      gender: map['gender'] as String,
      kundalidosh: map['kundalidosh'] as String,
      martialstatus: map['martialstatus'] as String,
      profession: map['profession'] as String,
      location: map['location1'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      sendreq: List<dynamic>.from((map['sendreq'] as List<dynamic>)),
      friends: List<dynamic>.from((map['friends'] as List<dynamic>)),
      pendingreq: List<dynamic>.from((map['pendingreq'] as List<dynamic>)),
      sendlinks: List<dynamic>.from((map['sendlink'] as List<dynamic>)),
      imageurls: List<dynamic>.from((map['imageurls'] as List<dynamic>)),
      invisibleprofile:
          List<dynamic>.from((map['invisibleprofile'] as List<dynamic>)),
      boostprofile: List<dynamic>.from((map['boostprofile'] as List<dynamic>)),
      blocklists: List<dynamic>.from((map['blocklists'] as List<dynamic>)),
      reportlist: List<dynamic>.from((map['reportlist'] as List<dynamic>)),
      shortlist: List<dynamic>.from((map['shortlist'] as List<dynamic>)),
      // unseenmessages: List<dynamic>.from((map['unseenmessages'] as List<dynamic>)),
      unapprovedSendlists:
          List<dynamic>.from((map['unapprovedSendlists'] as List<dynamic>)),
      country: map['country'] as String,
      token: map['token'] as String,
      dob: map['dob'] as int,
      showads: List<AdsModel>.from(
        (map['showads'] as List<dynamic>).map<AdsModel>(
          (x) => AdsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      chats: List<ChatsModel>.from(
        (map['chats'] as List<dynamic>).map<ChatsModel>(
          (x) => ChatsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      notifications: List<NotificationModel>.from(
        (map['notifications'] as List<dynamic>).map<NotificationModel>(
          (x) => NotificationModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      activities: List<ActivitiesModel>.from(
        (map['activities'] as List<dynamic>).map<ActivitiesModel>(
          (x) => ActivitiesModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory NewUserModel.fromJson(String source) =>
      NewUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

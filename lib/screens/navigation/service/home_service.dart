import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/admin_modal.dart';
import 'package:ristey/models/delete_modal.dart';
import 'package:ristey/models/match_modal.dart';
import 'package:ristey/models/match_modal_2.dart';
import 'package:ristey/models/new_save_pref.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:http/http.dart' as http;
import 'package:ristey/models/shared_pref.dart';
import 'package:ristey/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeService extends GetxController {
  RxMap userdata = {}.obs;
  Rx<NewSavePrefModel> saveprefdata = Rx(NewSavePrefModel(
      email: "",
      ageList: [],
      citylocation: [],
      statelocation: [],
      id: "",
      v: 0,
      religionList: [],
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
      location: []));
      void clearSavePrefData() {
        saveprefdata.value = NewSavePrefModel(
      email: "",
      ageList: [],
      citylocation: [],
      statelocation: [],
      id: "",
      v: 0,
      religionList: [],
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
      }
  Future<List<NewUserModel>> getalluserdata(
      {required String gender,
      required String email,
      required String religion,
      required int page,
      required List<dynamic> ages,
      required List<dynamic> religionList,
      required List<dynamic> kundaliDoshList,
      required List<dynamic> maritalStatusList,
      required List<dynamic> dietList,
      required List<dynamic> drinkList,
      required List<dynamic> smokeList,
      required List<dynamic> disabilityList,
      required List<dynamic> heightList,
      required List<dynamic> educationList,
      required List<dynamic> professionList,
      required List<dynamic> incomeList,
      required List<dynamic> statelocation,
      required List<dynamic> citylocation,
      required List<dynamic> location}) async {
    List<NewUserModel> allusers = [];

    try {
      http.Response res = await http.post(Uri.parse(getallusersurl),
          headers: {'Content-Type': 'Application/json'},
          body: json.encode({
            "gender": gender,
            "religion": religion,
            "page": page,
            "email": email,
            "ages": ages,
            "religionList": religionList,
            'lat': userSave.latitude,
            'lng': userSave.longitude,
            "kundaliDoshList": kundaliDoshList,
            "maritalStatusList": maritalStatusList,
            "dietList": dietList,
            "drinkList": drinkList,
            "invisiblelist": invisibleuserFriend,
            "smokeList": smokeList,
            "disabilityList": disabilityList,
            "heightList": heightList,
            "educationList": educationList,
            "professionList": professionList,
            "incomeList": incomeList,
            "statelocation": statelocation,
            "citylocation": citylocation,
            "location": location
          }));
      if (res.statusCode == 200) {
        for (var i = 0; i < jsonDecode(res.body).length; i++) {
          allusers
              .add(NewUserModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));

          // print(userdata);
        }
      } else {
        print("something went wrongyunish");
      }
    } catch (e) {
      print(e.toString());
    }
    return allusers;
  }

  Future<List<NewUserModel>> getaddedusers({
    required String userid,
  }) async {
    List<NewUserModel> allusers = [];

    try {
      http.Response res = await http.post(Uri.parse(getadminusers),
          headers: {'Content-Type': 'Application/json'},
          body: json.encode({
            "userid": userid,
          }));
      // print("${res.body} hello");
      if (res.statusCode == 200) {
        for (var i = 0; i < jsonDecode(res.body).length; i++) {
          allusers
              .add(NewUserModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
        }
      } else {
        print("something went wrongyunish");
      }
    } catch (e) {
      print(e.toString());
    }
    return allusers;
  }

  SharedPref sharedPref = SharedPref();

  Future<NewUserModel> getuserdata() async {
    NewUserModel? newUserModel;

    try {
      final email = await sharedPref.read("currentEmail");
      print("this is url --> ${"$getuserdataurl/${userSave.email}"}");

      http.Response res = await http.get(Uri.parse("$getuserdataurl/$email"),
          headers: {'Content-Type': 'Application/json'});
      print("this is status code ---> ${res.statusCode}");
      if (res.statusCode == 200) {
        newUserModel = NewUserModel.fromJson(jsonEncode(jsonDecode(res.body)));

        userdata.addAll(jsonDecode(res.body));
        userSave.email = newUserModel.email;
        userSave.gender = newUserModel.gender;
        userSave.status = newUserModel.status;
        userSave.About_Me = newUserModel.aboutme;
        userSave.Partner_Prefs = newUserModel.patnerprefs;
        userSave.phone = newUserModel.phone;
        userSave.Smoke = newUserModel.smoke;
        userSave.Profession = newUserModel.profession;
        userSave.KundaliDosh = newUserModel.kundalidosh;
        userSave.token = newUserModel.token;
        userSave.displayName = newUserModel.name;
        userSave.latitude = newUserModel.lat;
        userSave.longitude = newUserModel.lng;
        userSave.religion = newUserModel.religion;
        userSave.name = newUserModel.name;
        userSave.surname = newUserModel.surname;
        userSave.puid = newUserModel.puid;
        userSave.state = newUserModel.state;
        userSave.city = newUserModel.city;
        userSave.Height = newUserModel.height;
        userSave.Diet = newUserModel.diet;
        userSave.Drink = newUserModel.drink;
        userSave.Disability = newUserModel.disability;
        userSave.Education = newUserModel.education;
        userSave.isBlur = newUserModel.isBlur;
        sendlinks = newUserModel.sendlinks;
        userSave.Income = newUserModel.income;
        userSave.Location = newUserModel.location;
        frienda = newUserModel.friends;
        userSave.country = newUserModel.country;
        friendr = newUserModel.pendingreq;
        friends = newUserModel.sendreq;
        userSave.uid = newUserModel.id;
        userSave.city = newUserModel.city;
        unapprovefriends = newUserModel.unapprovedSendlists;
        userSave.dob = newUserModel.dob;
        blocFriend = newUserModel.blocklists;
        reportFriend = newUserModel.reportlist;
        shortFriend = newUserModel.shortlist;
        boostprofileuids = newUserModel.boostprofile;
        invisibleuserFriend = newUserModel.invisibleprofile;
        userSave.timeofbirth = newUserModel.timeofbirth;
        userSave.placeofbirth = newUserModel.placeofbirth;
        userSave.imageUrls = newUserModel.imageurls;
        userSave.videoLink = newUserModel.videolink;
        userSave.MartialStatus = newUserModel.martialstatus;
        notificationslists = newUserModel.notifications;
        message = newUserModel.chats!;
        isLogoutString = newUserModel.isLogOut;
        adsuser = newUserModel.showads;
        userSave.isLogOut = newUserModel.isLogOut;
        userSave.verifiedStatus = newUserModel.verifiedstatus;
        // unseenmessages=newUserModel.unseenmessages;
        //  print(newUserModel.notifications[0].title);
        activitieslists = newUserModel.activities;
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString("email", userSave.email!);
        sharedPreferences.setString("location", newUserModel.location);
        return newUserModel;
      } else if (res.statusCode == 400) {
        Get.offAll(() => const FirstScreen());
      } else {
        print("Something went workng");
      }
    } catch (e) {
      print("${e}3ee");
    }
    return newUserModel!;
  }

  Future getusersaveprefdata() async {
    NewSavePrefModel newUserModel;
    print("${userSave.email} hello");
    try {
      http.Response res = await http.get(
          Uri.parse("$getusersavepref/${userSave.email}"),
          headers: {'Content-Type': 'Application/json'});
      // print(res.body);
      if (res.statusCode == 200) {
        newUserModel = newSavePrefModelFromJson(res.body);

        saveprefdata.value = newUserModel;
        print(saveprefdata.value.ageList);
        return newUserModel;
      } else {
        print("something went wrong1");
      }
    } catch (e) {
      print("${e}3ee");
    }
  }

  Future<NewSavePrefModel> getsavepref(String email) async {
    NewSavePrefModel newUserModel = NewSavePrefModel(
        id: "",
        email: email,
        ageList: [],
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
        location: [],
        v: 0);
    try {
      http.Response res = await http.get(Uri.parse("$getusersavepref/$email"),
          headers: {'Content-Type': 'Application/json'});
      if (res.statusCode == 200) {
        newUserModel = newSavePrefModelFromJson(res.body);

        return newUserModel;
      } else {}
    } catch (e) {
      print("${e}3ee");
    }
    return newUserModel;
  }

  Future<void> createsavepref({
    required List<dynamic> ageList,
    required List<dynamic> religionList,
    required List<dynamic> kundaliDoshList,
    required List<dynamic> maritalStatusList,
    required List<dynamic> heightList,
    required List<dynamic> smokeList,
    required List<dynamic> drinkList,
    required List<dynamic> disabilityList,
    required List<dynamic> dietList,
    required List<dynamic> educationList,
    required List<dynamic> statelocation,
    required List<dynamic> citylocation,
    required List<dynamic> professionList,
    required List<dynamic> incomeList,
    required List<dynamic> location,
  }) async {
    try {
      print(userSave.email);
      NewSavePrefModel newSavePrefModel = NewSavePrefModel(
          id: "",
          email: userSave.email!,
          ageList: ageList,
          religionList: religionList,
          citylocation: citylocation,
          statelocation: statelocation,
          kundaliDoshList: kundaliDoshList,
          maritalStatusList: maritalStatusList,
          dietList: dietList,
          drinkList: drinkList,
          smokeList: smokeList,
          disabilityList: disabilityList,
          heightList: heightList,
          educationList: educationList,
          professionList: professionList,
          incomeList: incomeList,
          location: location,
          v: 0);
      print(newSavePrefModel.ageList);
      http.Response res = await http.post(Uri.parse(createuseravepref),
          headers: {'Content-Type': 'Application/json'},
          body:
              // newSavePrefModel.toJson()
              json.encode({
            "email": userSave.email,
            "ageList": ageList,
            "kundaliDoshList": kundaliDoshList,
            "religionList": religionList,
            "maritalStatusList": maritalStatusList,
            "dietList": dietList,
            "statelocation": statelocation,
            "citylocation": citylocation,
            "drinkList": drinkList,
            "smokeList": smokeList,
            "disabilityList": disabilityList,
            "heightList": heightList,
            "educationList": educationList,
            "professionList": professionList,
            "incomeList": incomeList,
            "location": location
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print('saved');
      } else {
        print('not saved');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addtoblock(
      {required String email,
      required String profileid,
      required String sendemail}) async {
    try {
      print(userSave.uid);
      http.Response res = await http.post(Uri.parse(addtoblockurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "senduid": profileid,
            "sendemail": sendemail,
            "uid": userSave.uid
          }));
      if (res.statusCode == 200) {
        print(res.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> unblock(
      {required String email,
      required String profileid,
      required String sendemail}) async {
    try {
      http.Response res = await http.post(Uri.parse(unblockuserurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "senduid": profileid,
            "sendemail": sendemail,
            "uid": userSave.uid
          }));
      if (res.statusCode == 200) {
        print("unblock");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> unshortlistuser(
      {required String email, required String profileid}) async {
    try {
      http.Response res = await http.post(Uri.parse(unshortlistrurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "senduid": profileid}));
      if (res.statusCode == 200) {
        print("unshortlist user successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addtosortlist(
      {required String email, required String profileid}) async {
    try {
      http.Response res = await http.post(Uri.parse(addtosorturl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "senduid": profileid}));
      if (res.statusCode == 200) {
        print("add to sortlist successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removefromreportlist(
      {required String email, required String profileid}) async {
    try {
      http.Response res = await http.post(Uri.parse(removereportlistrurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "senduid": profileid}));
      if (res.statusCode == 200) {
        print("unshortlist user successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addtounapproveblock(
      {required String email, required String profileid}) async {
    try {
      http.Response res = await http.post(Uri.parse(addtounapproveblockurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "senduid": profileid}));
      if (res.statusCode == 200) {
        print("unshortlist user successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeunapproveblock(
      {required String email, required String profileid}) async {
    try {
      print("$profileid kldjflk");

      http.Response res = await http.post(Uri.parse(removeunapproveblockurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "senduid": profileid}));
      if (res.statusCode == 200) {
        print(res.body);
        print("unshortlist user successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addtoreportlist(
      {required String email, required String profileid}) async {
    try {
      http.Response res = await http.post(Uri.parse(addtoreportuserurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "senduid": profileid}));
      if (res.statusCode == 200) {
        print("add to sortlist successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> acceptrequest(
      {required String email,
      required String sendemail,
      required String senduid,
      required String profileid}) async {
    try {
      http.Response res = await http.post(Uri.parse(acceptrequrl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "uid": profileid,
            "sendemail": sendemail,
            "senduid": senduid
          }));
      if (res.statusCode == 200) {
        print("accept request successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendrequest(
      {required String email,
      required String sendemail,
      required String senduid,
      required String profileid}) async {
    try {
      http.Response res = await http.post(Uri.parse(sendconnecturl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "uid": profileid,
            "sendemail": sendemail,
            "senduid": senduid
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("accept request successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> canclereq(
      {required String email,
      required String sendemail,
      required String senduid,
      required String profileid}) async {
    try {
      http.Response res = await http.post(Uri.parse(canclerequrl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "uid": profileid,
            "sendemail": sendemail,
            "senduid": senduid
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("cancle request successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> rejectreq(
      {required String email,
      required String sendemail,
      required String senduid,
      required String profileid}) async {
    try {
      http.Response res = await http.post(Uri.parse(rejectrequrl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "uid": profileid,
            "sendemail": sendemail,
            "senduid": senduid
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("cancle request successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> editprofile(
      {required String email,
      required String aboutme,
      required String mypreference,
      required List<dynamic> imageurls}) async {
    try {
      http.Response res = await http.post(Uri.parse(editprofileurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "patnerprefs": mypreference,
            "aboutme": aboutme,
            "imageurls": imageurls,
          }));
      print("***********1234567");
      print(res.body);
      if (res.statusCode == 200) {
        print("accept request successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteuseraccount({
    required String email,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse(deleteuseraccounturl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
          }));
      print("***********1234567");
      print(res.body);
      if (res.statusCode == 200) {
        print("accept request successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> createeditprofile(
      {required String userid,
      required String aboutme,
      required String mypreference,
      required bool isBlur,
      required String editname,
      required List<dynamic> imageurls}) async {
    try {
      print("****************");
      print(userSave.dob);
      http.Response res = await http.post(Uri.parse(createeditprofileurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "userid": userid,
            "patnerpref": mypreference,
            "aboutme": aboutme,
            "editname": editname,
            "dateofbirth": userSave.dob.toString(),
            "images": imageurls,
            "isBlur": isBlur,
            "gender": userSave.gender!,
            "phone": userSave.phone,
            "timeofbirth": userSave.timeofbirth,
            "placeofbirth": userSave.placeofbirth,
            "kundalidosh": userSave.KundaliDosh,
            "martialstatus": userSave.MartialStatus,
            "profession": userSave.Profession,
            "religion": userSave.religion,
            "location1": userSave.Location,
            "city": userSave.city,
            "state": userSave.state,
            "country": userSave.country,
            "name": userSave.name,
            "surname": userSave.surname,
            "lat": userSave.latitude,
            "lng": userSave.longitude,
            "diet": userSave.Diet,
            "age": "",
            "disability": userSave.Disability,
            "puid": userSave.puid,
            "drink": userSave.Drink,
            "education": userSave.Education,
            "height": userSave.Height,
            "income": userSave.Income
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("accept request successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> createbiodataprofile({
    required String editname,
  }) async {
    try {
      print("****************");
      print(userSave.dob);
      http.Response res = await http.post(Uri.parse(createbiodataeurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "userid": userSave.uid,
            "patnerpref": userSave.Partner_Prefs,
            "aboutme": userSave.About_Me,
            "editname": editname,
            "images": userSave.imageUrls,
            "profession": userSave.Profession,
            "education": userSave.Education,
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("accept request successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> createverifieduser({
    required String editname,
    required String videolink,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse(createverifyuserurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "userid": userSave.email,
            "videoLink": videolink,
            "name": editname
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("accept request successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteaccount(
      {required String email, required String reasontodeleteuser}) async {
    try {
      DeleteUserModel usermodel = DeleteUserModel(
        About_Me: userSave.About_Me!,
        isBlur: userSave.isBlur!,
        id: userSave.uid!,
        showads: [],
        Location: userSave.Location!,
        adminlat: userSave.latitude,
        adminlng: userSave.longitude,
        chatnow: 0,
        createdAt: "",
        downloadbiodata: false,
        editstatus: "",
        freepersonmatch: 0,
        marriageloan: 0,
        onlineuser: false,
        share: 0,
        support: 0,
        unapproveActivites: [],
        chats: [],
        placeofbirth: userSave.placeofbirth!,
        timeofbirth: userSave.timeofbirth!,
        Diet: userSave.Diet!,
        Disability: userSave.Disability!,
        Drink: userSave.Drink!,
        isLogOut: userSave.isLogOut!,
        status: userSave.status!,
        Education: userSave.Education!,
        Height: userSave.Height!,
        Income: userSave.Income!,
        Partner_Prefs: userSave.Partner_Prefs!,
        Smoke: userSave.Smoke!,
        displayname: userSave.displayName!,
        email: email,
        reasontodeleteuser: reasontodeleteuser,
        religion: userSave.religion!,
        name: userSave.name!,
        surname: userSave.surname!,
        phone: userSave.phone!,
        gender: userSave.gender!,
        KundaliDosh: userSave.KundaliDosh!,
        MartialStatus: userSave.MartialStatus!,
        Profession: userSave.Profession!,
        city: userSave.city!,
        state: userSave.state!,
        imageurls: userSave.imageUrls!,
        blocklists: [],
        reportlist: [],
        shortlist: [],
        country: userSave.country!,
        token: userSave.token!,
        puid: userSave.puid!,
        dob: userSave.dob!,
        age: "20",
        lat: userSave.latitude!,
        lng: userSave.longitude!,
        verifiedstatus: userSave.verifiedStatus!,
        pendingreq: [],
        sendreq: [],
        friends: friends,
        videolink: userSave.videoLink!,
        notifications: [],
        activities: [],
      );
      http.Response res = await http.post(Uri.parse(deleteaccounturl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "gender": userSave.gender,
            "aboutme": userSave.About_Me,
            "age": userSave.dob,
            "puid": userSave.puid,
            "diet": userSave.Diet,
            "lat": userSave.latitude,
            "lng": userSave.longitude,
            "disability": userSave.Disability,
            "drink": userSave.Drink,
            "imageurls": userSave.imageUrls,
            "placeofbirth": userSave.placeofbirth,
            "timeofbirth": userSave.timeofbirth,
            "education": userSave.Education,
            "height": userSave.Height,
            "income": userSave.Income,
            "patnerprefs": userSave.Partner_Prefs,
            "smoke": userSave.Smoke,
            "displayname": userSave.displayName,
            "email": email,
            "religion": userSave.religion,
            "name": userSave.name,
            "surname": userSave.surname,
            "phone": userSave.phone,
            "kundalidosh": userSave.KundaliDosh,
            "martialstatus": userSave.MartialStatus,
            "profession": userSave.Profession,
            "location1": userSave.Location,
            "city": userSave.city,
            "state": userSave.state,
            "country": userSave.country,
            "token": userSave.token,
            "dob": userSave.dob,
            "reasontodeleteuser": reasontodeleteuser,
            "status": userSave.status,
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("accept request successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updatelocation(
      {required double lat,
      required double lng,
      required String email,
      required String country,
      required String city,
      required String state,
      required String location}) async {
    try {
      print("$email this is new email");
      http.Response res = await http.post(Uri.parse(updatelocationurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "lat": lat,
            "lng": lng,
          }));
      // print(res.body);
      if (res.statusCode == 200) {
        // print("update location successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> cleartoken({required String email}) async {
    try {
      http.Response res = await http.post(Uri.parse(cleartokenurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
          }));
      // print(res.body);
      if (res.statusCode == 200) {
        // print("clear token successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addtoken({
    required String email,
    required String token,
  }) async {
    try {
      log("message is $token");
      http.Response res = await http.post(Uri.parse(addtokenurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "token": token}));
      print(res.body);
      if (res.statusCode == 200) {
        print("clear token successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateoffiletime({
    required String email,
    required String time,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse(updateoffiletimeurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "time": time}));
      if (res.statusCode == 200) {}
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateeditstatus({
    required String email,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse(updateeditstatusurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("clear token successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updatelogin({
    required String email,
    required String mes,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse(updateloginurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "mes": mes}));
      print("islogout1234 ${res.body}");
      if (res.statusCode == 200) {
        print("update noti  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updatesendlink() async {
    try {
      http.Response res = await http.post(Uri.parse(updatesendlinkurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": userSave.email}));

      if (res.statusCode == 200) {
        print("update noti  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addtounapproveacitvites(
      {required String email,
      required String title,
      required String reciveuserid,
      required String userimage,
      required String useremail,
      required String token}) async {
    try {
      http.Response res = await http.post(Uri.parse(addtounapproveacitvitesurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "title": title,
            "token": token,
            "senduserid": userSave.uid,
            "useremail": useremail,
            "reciveuserid": reciveuserid,
            "userimage": userimage
          }));
      print("islogout1234 ${res.body}");
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateprofession({
    required String email,
    required String mes,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse(updateprofessionurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "profession": mes}));
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateeducation({
    required String email,
    required String mes,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse(updateeducationurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "education": mes}));
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Match1?> getusermatch(
      {required String boydob,
      required String boytob,
      required String boytz,
      required double boylat,
      required double boyon,
      required String girldob,
      required String girltob,
      required String girltz,
      required double girllat,
      required double girlon}) async {
    Match1? match;
    try {
      http.Response res = await http.get(Uri.parse(
          "https://api.vedicastroapi.com/v3-json/matching/aggregate-match?boy_dob=$boydob&boy_tob=$boytob&boy_tz=$boytz&boy_lat=$boylat&boy_lon=$boyon&girl_dob=$girldob&girl_tob=$girltob&girl_tz=$girltz&girl_lat=$girllat&girl_lon=$girlon&api_key=c3c8e02b-443e-529e-bf07-9772430f8f8b&lang=en"));
      print(res.body);
      if (res.statusCode == 200) {
        match = matchFromJson(res.body);
      } else {
        print(res.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return match!;
  }

  Future<Match2?> getusermatch2({
    required String boydob,
    required String boytob,
    required double boylat,
    required double boyon,
  }) async {
    Match2? match;
    try {
      http.Response res = await http.get(Uri.parse(
          "https://api.vedicastroapi.com/v3-json/dosha/mangal-dosh?dob=$boydob&tob=$boytob&lat=$boylat&lon=$boyon&tz=5.5&api_key=c3c8e02b-443e-529e-bf07-9772430f8f8b&lang=en"));
      print(res.body);
      if (res.statusCode == 200) {
        print("matadcafd");
        match = match2FromJson(res.body);
      } else {
        print(res.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return match!;
  }

  Future getallunseennumber({required String userid}) async {
    int numUnread = 0;
    try {
      http.Response res = await http.post(Uri.parse(findallnumberofunseenurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"userid": userid}));
      print("**********************");
      print(res.body);
      print(userid);
      print("**********************");
      if (res.statusCode == 200) {
        numUnread = jsonDecode(res.body);
        // print("This is our unread msg ()=> ${numUnread}");
      }
    } catch (e) {
      print(e.toString());
    }
    return numUnread;
  }

  Future updateblur({required String email, required bool isblur}) async {
    try {
      http.Response res = await http.post(Uri.parse(updateblurprofile),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "isblur": isblur}));

      if (res.statusCode == 200) {
        print(res.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future createRating(
      {required String email,
      required int number,
      required String description}) async {
    try {
      http.Response res = await http.post(Uri.parse(createratingurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "useremail": email,
            "ratingnumber": number,
            "description": description
          }));

      if (res.statusCode == 200) {
        print(res.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<AdminModel>> getalladmins() async {
    List<AdminModel> alladmins = [];
    try {
      http.Response res = await http.get(
        Uri.parse(getadminsurl),
        headers: {'Content-Type': 'Application/json'},
      );
      // print(res.body);
      if (res.statusCode == 200) {
        for (var i = 0; i < jsonDecode(res.body).length; i++) {
          alladmins
              .add(AdminModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
        }
        return alladmins;
      } else {
        print(res.body);
      }
    } catch (e) {
      print(e);
    }
    return alladmins;
  }
}

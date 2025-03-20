import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:ristey/screens/data_collection/congo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends GetxController {
  RxMap userdata = {}.obs;
  RxMap newuserdata = {}.obs;
  Future<void> createappuser(
      {required String aboutme,
      required String diet,
      required String disability,
      required String drink,
      required String education,
      required String height,
      required String income,
      required String patnerprefs,
      required String smoke,
      required String displayname,
      required String email,
      required String religion,
      required String name,
      required String surname,
      required String phone,
      required String gender,
      required String kundalidosh,
      required String martialstatus,
      required String profession,
      required String location,
      required String city,
      required String state,
      required List<dynamic> imageurls,
      required List<dynamic> blocklists,
      required List<dynamic> reportlist,
      required List<dynamic> shortlist,
      required String country,
      required String token,
      required String age,
      required double lat,
      required double lng,
      required String timeofbirth,
      required String placeofbirth,
      required String puid,
      required int dob}) async {
    try {
      NewUserModel userModel = NewUserModel(
          aboutme: aboutme,
          status: "",
          boostprofile: [],
          showads: [],
          invisibleprofile: [],
          isLogOut: "",
          placeofbirth: placeofbirth,
          sendlinks: [],
          unapprovedSendlists: [],
          timeofbirth: timeofbirth,
          lat: lat,
          lng: lng,
          puid: puid,
          // unseenmessages: [],
          verifiedstatus: "",
          pendingreq: [],
          chats: [],
          friends: [],
          activities: [],
          isBlur: false,
          notifications: [],
          sendreq: [],
          age: age,
          id: "",
          diet: diet,
          disability: disability,
          drink: drink,
          videolink: '',
          education: education,
          height: height,
          income: income,
          patnerprefs: patnerprefs,
          smoke: smoke,
          displayname: displayname,
          email: email,
          religion: religion,
          name: name,
          surname: surname,
          phone: phone,
          gender: gender,
          kundalidosh: kundalidosh,
          martialstatus: martialstatus,
          profession: profession,
          location: location,
          city: city,
          state: state,
          imageurls: imageurls,
          blocklists: blocklists,
          reportlist: reportlist,
          shortlist: shortlist,
          country: country,
          token: token,
          dob: dob);
      http.Response res = await http.post(Uri.parse(createuser),
          headers: {'Content-Type': 'Application/json'},
          body: userModel.toJson());
      print(res.body);
      if (res.statusCode == 200) {
        userSave.email = email;
        userSave.religion = religion;
        await sharedPref.save("user", userSave);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString("email", userSave.email!);
        sharedPreferences.setString("location", location);
        print(res.body);
        Get.to(Congo());
      } else {
        print("Something went wrong");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> createappuserbyregister(
      {required String aboutme,
      required String diet,
      required String disability,
      required String drink,
      required String education,
      required String height,
      required String income,
      required String patnerprefs,
      required String smoke,
      required String displayname,
      required String email,
      required String religion,
      required String name,
      required String surname,
      required String phone,
      required String gender,
      required String kundalidosh,
      required String martialstatus,
      required String profession,
      required String location,
      required String city,
      required String state,
      required List<dynamic> imageurls,
      required List<dynamic> blocklists,
      required List<dynamic> reportlist,
      required List<dynamic> shortlist,
      required String country,
      required String token,
      required String age,
      required double lat,
      required double lng,
      required String timeofbirth,
      required String placeofbirth,
      required String puid,
      required int dob}) async {
    try {
      NewUserModel userModel = NewUserModel(
          aboutme: aboutme,
          status: "",
          boostprofile: [],
          showads: [],
          invisibleprofile: [],
          isLogOut: "",
          // unseenmessages: [],
          placeofbirth: placeofbirth,
          sendlinks: [],
          unapprovedSendlists: [],
          timeofbirth: timeofbirth,
          lat: lat,
          lng: lng,
          puid: puid,
          verifiedstatus: "",
          pendingreq: [],
          chats: [],
          friends: [],
          activities: [],
          isBlur: false,
          notifications: [],
          sendreq: [],
          age: age,
          id: "",
          diet: diet,
          disability: disability,
          drink: drink,
          videolink: '',
          education: education,
          height: height,
          income: income,
          patnerprefs: patnerprefs,
          smoke: smoke,
          displayname: displayname,
          email: email,
          religion: religion,
          name: name,
          surname: surname,
          phone: phone,
          gender: gender,
          kundalidosh: kundalidosh,
          martialstatus: martialstatus,
          profession: profession,
          location: location,
          city: city,
          state: state,
          imageurls: imageurls,
          blocklists: blocklists,
          reportlist: reportlist,
          shortlist: shortlist,
          country: country,
          token: token,
          dob: dob);
      http.Response res = await http.post(Uri.parse(createuser),
          headers: {'Content-Type': 'Application/json'},
          body: userModel.toJson());
      print(res.body);
      if (res.statusCode == 200) {
      } else {
        print("Something went wrong");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> createincompleteprofilebyregister(
      {required String aboutme,
      required String diet,
      required String disability,
      required String drink,
      required String education,
      required String height,
      required String income,
      required String patnerprefs,
      required String smoke,
      required String displayname,
      required String email,
      required String religion,
      required String name,
      required String surname,
      required String phone,
      required String gender,
      required String kundalidosh,
      required String martialstatus,
      required String profession,
      required String location,
      required String city,
      required String state,
      required List<dynamic> imageurls,
      required List<dynamic> blocklists,
      required List<dynamic> reportlist,
      required List<dynamic> shortlist,
      required String country,
      required String token,
      required String age,
      required double lat,
      required double lng,
      required String timeofbirth,
      required String placeofbirth,
      required String puid,
      required int dob}) async {
    try {
      NewUserModel userModel = NewUserModel(
          aboutme: aboutme,
          status: "",
          boostprofile: [],
          showads: [],
          invisibleprofile: [],
          isLogOut: "",
          // unseenmessages: [],
          placeofbirth: placeofbirth,
          sendlinks: [],
          unapprovedSendlists: [],
          timeofbirth: timeofbirth,
          lat: lat,
          lng: lng,
          puid: puid,
          verifiedstatus: "",
          pendingreq: [],
          chats: [],
          friends: [],
          activities: [],
          isBlur: false,
          notifications: [],
          sendreq: [],
          age: age,
          id: "",
          diet: diet,
          disability: disability,
          drink: drink,
          videolink: '',
          education: education,
          height: height,
          income: income,
          patnerprefs: patnerprefs,
          smoke: smoke,
          displayname: displayname,
          email: email,
          religion: religion,
          name: name,
          surname: surname,
          phone: phone,
          gender: gender,
          kundalidosh: kundalidosh,
          martialstatus: martialstatus,
          profession: profession,
          location: location,
          city: city,
          state: state,
          imageurls: imageurls,
          blocklists: blocklists,
          reportlist: reportlist,
          shortlist: shortlist,
          country: country,
          token: token,
          dob: dob);
      http.Response res = await http.post(Uri.parse(createincompleteuserurl),
          headers: {'Content-Type': 'Application/json'},
          body: userModel.toJson());
      print(res.body);
      if (res.statusCode == 200) {
      } else {
        print("Something went wrong");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> finduser(String email) async {
    int statusCode = 0;
    try {
      http.Response res = await http.get(Uri.parse("$finduserurl/$email"),
          headers: {'Content-Type': 'Application/json'});
      print(res.body);
      if (res.statusCode == 200) {
        userSave.email = jsonDecode(res.body)["user"]["email"];
        print(userSave.email);
        return statusCode = res.statusCode;
      } else if (res.statusCode == 400) {
        return statusCode = res.statusCode;
      }
    } catch (e) {
      print(e.toString());
    }
    return statusCode;
  }

  Future<int> finddeleteuser(String email) async {
    int statusCode = 0;
    try {
      http.Response res = await http.post(Uri.parse(finddeleteuserurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email}));
      print("********************");
      print("********************");

      print(res.body);
      if (res.statusCode == 200) {
        return statusCode = res.statusCode;
      } else if (res.statusCode == 400) {
        return statusCode = res.statusCode;
      }
    } catch (e) {
      print(e.toString());
    }
    return statusCode;
  }

  Future<int> finduser1(String email) async {
    int statusCode = 0;
    try {
      http.Response res = await http.get(Uri.parse("$finduserurl/$email"),
          headers: {'Content-Type': 'Application/json'});
      print(res.body);
      if (res.statusCode == 200) {
        return statusCode = res.statusCode;
      } else if (res.statusCode == 400) {
        return statusCode = res.statusCode;
      }
    } catch (e) {
      print(e.toString());
    }
    return statusCode;
  }

  Future<void> addvideo(String email, String videoUrl) async {
    try {
      http.Response res = await http.post(Uri.parse(uploadvideourl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "videourl": videoUrl,
          }));
      if (res.statusCode == 200) {
        print("unblock");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteincompleteuser(String email) async {
    try {
      http.Response res = await http.post(Uri.parse(deleteincompleteurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
          }));
      if (res.statusCode == 200) {
        print("unblock");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletevido(String email) async {
    try {
      http.Response res = await http.post(Uri.parse(deletevidourl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
          }));
      if (res.statusCode == 200) {
        print("unblock");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getbubbles() async {
    var data;
    try {
      http.Response res = await http.get(
        Uri.parse(getbubblesurl),
        headers: {'Content-Type': 'Application/json'},
      );
      print(res.body);
      if (res.statusCode == 200) {
        return data = jsonDecode(res.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return data;
  }
}

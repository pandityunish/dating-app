import 'dart:convert';
import 'dart:developer';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/new_user_modal.dart';

class NotificationService {
  Future<void> addtonotification({
    required String email,
    required String title,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse(addtonotificationurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "title": title,
          }));
      print("helloin****");
      print(res.body);
      print("helloin*******");
      if (res.statusCode == 200) {
        print("notification added successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> getnumberofnoti() async {
    int number = 0;
    try {
      http.Response res = await http.post(Uri.parse(getnumofnoti),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "userId": userSave.uid,
          }));
      log("new data ${res.body}");
      if (res.statusCode == 200) {
        return number = jsonDecode(res.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return number;
  }

  Future<int> updatenumberofnoti() async {
    int number = 0;
    try {
      http.Response res = await http.post(Uri.parse(updatenumofnoti),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "userId": userSave.uid,
          }));
      print("ok");
      print(res.body);
      if (res.statusCode == 200) {
        print("update noti");
        return number = jsonDecode(res.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return number;
  }

  Future getmaintenance() async {
    var data;
    try {
      http.Response res = await http.get(
        Uri.parse(getmaintenanceurl),
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

  Future<void> addtoadminnotification(
      {required String userid,
      required String useremail,
      required String userimage,
      required String title,
      required String subtitle}) async {
    try {
      print(useremail);
      print(userimage);
      print(title);
      print(subtitle);
      http.Response res = await http.post(Uri.parse(addtoadminnotificationurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "userid": userid,
            "title": title,
            "useremail": useremail,
            "userimage": userimage,
            "subtitle": subtitle,
            "adminemail": ""
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("Admin notification added successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addtoactivities(
      {required String email,
      required String title,
      required String username,
      String? userimage,
      required String userid}) async {
    try {
      print("hello");
      http.Response res = await http.post(Uri.parse(addtoactivitiesurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "title": title,
            "username": username,
            "userimage": userimage ?? "",
            "userid": userid
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("activities added successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteactivities(
      {required String notiId, required String userid}) async {
    try {
      print("hello");
      http.Response res = await http.post(Uri.parse(deleteactivitiesurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"userId": userid, "notiId": notiId}));
      print(res.body);
      if (res.statusCode == 200) {
        print("activities deleted successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<NewUserModel>> getinvisibleusers({
    required List<dynamic> userid,
  }) async {
    List<NewUserModel> allusers = [];
    print("hello hi ok");
    try {
      http.Response res = await http.post(Uri.parse(getinvisibleusersurl),
          headers: {'Content-Type': 'Application/json'},
          body: json.encode({
            "userIds": userid,
          }));
      print("${res.body} hello hi ok");
      if (res.statusCode == 200) {
        print("Nice");
        for (var i = 0; i < jsonDecode(res.body).length; i++) {
          allusers
              .add(NewUserModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
        }
      } else {
        print("something went wrongyunish122");
      }
    } catch (e) {
      print("${e}Hello yunish 123456");
    }
    return allusers;
  }

  Future<List<NewUserModel>> getboostusers({
    required List<dynamic> userid,
  }) async {
    List<NewUserModel> allusers = [];

    try {
      http.Response res = await http.post(Uri.parse(getboostusersurl),
          headers: {'Content-Type': 'Application/json'},
          body: json.encode({
            "userIds": userid,
          }));
      print("${res.body} $userid ");
      print("hello hi yunish");
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

  Future<void> deletevideo({required String email}) async {
    try {
      http.Response res = await http.post(Uri.parse("$baseurl/auth/delete"),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
          }));
      if (res.statusCode == 200) {
        print("delete video");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

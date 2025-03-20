import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/message_modal.dart';
import 'package:ristey/models/new_user_modal.dart';

class ChatService {
  Future<void> sendmessages(
      {required String text,
      required String to,
      required String token,
      required String from,
      required int time,
      required String status}) async {
    try {
      http.Response res = await http.post(Uri.parse(addmessagesurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "text": text,
            "token": token,
            "to": to,
            "from": from,
            "time": time,
            "uid": from,
            "status": status
          }));
      if (res.statusCode == 200) {
        print("send successfully");
      } else {
        print("Something went wrong");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<MessageModelChats>> getallmessage(
      {required String to, required String from}) async {
    List<MessageModelChats> allmessages = [];
    try {
      http.Response response = await http.post(Uri.parse(getallusermessages),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"from": from, "to": to}));
      if (response.statusCode == 200) {
        for (int i = 0; i < jsonDecode(response.body).length; i++) {
          allmessages.add(MessageModelChats.fromJson(
              jsonEncode(jsonDecode(response.body)[i])));
        }
      }
      return allmessages;
    } catch (e) {
      print(e.toString());
    }
    return allmessages;
  }

  Future<NewUserModel> getuserdata(String email) async {
    NewUserModel? newUserModel;

    try {
      http.Response res = await http.get(Uri.parse("$getuserdataurl/$email"),
          headers: {'Content-Type': 'Application/json'});
      print(res.body);
      if (res.statusCode == 200) {
        newUserModel = NewUserModel.fromJson(jsonEncode(jsonDecode(res.body)));
        return newUserModel;
      } else {
        print("something went wrong");
      }
    } catch (e) {
      print("${e}3ee");
    }
    return newUserModel!;
  }

  Future<NewUserModel> getuserdatabyid(String id) async {
    NewUserModel? newUserModel;

    try {
      http.Response res = await http.get(Uri.parse("$getuserdatabyurl/$id"),
          headers: {'Content-Type': 'Application/json'});
      print(res.body);
      if (res.statusCode == 200) {
        newUserModel = NewUserModel.fromJson(jsonEncode(jsonDecode(res.body)));
        return newUserModel;
      } else {
        print("something went wrong");
      }
    } catch (e) {
      print("${e}3ee");
    }
    return newUserModel!;
  }

  Future<void> setusermessage(
      {required String username,
      required String sendemail,
      required int lasttime,
      required String userimage,
      required String userid,
      required String lastmessage}) async {
    try {
      print(username);
      print(userid);
      http.Response res = await http.post(Uri.parse(createuserchats),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "lasttime": lasttime,
            "username": username,
            "userimage": userimage,
            "userid": userid,
            "senduseremail": sendemail,
            "lastmessage": lastmessage,
            "email": userSave.email,
            "senduserimage":
                userSave.imageUrls!.isEmpty ? "" : userSave.imageUrls![0],
            "senduserid": userSave.uid,
            "sendusername": userSave.surname
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("send successfully hei");
      } else {
        print("Something went wrongsdfa");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updatelastmessage(
      {required int lasttime,
      required String senderemail,
      required String lastmessage,
      required String email}) async {
    try {
      print(senderemail);
      http.Response res = await http.post(Uri.parse(updatelastmessageurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "chatemail": senderemail,
            "lastmessage1": lastmessage,
            "lasttime": lasttime,
            "senduseremail": senderemail,
            "sendchatemail": email,
            "token": userSave.token
          }));
      print("ksjfalksjdflksjadf");
      print("${res.body} hello");
      print("ksjfalksjdflksjadf");
      if (res.statusCode == 200) {
        print("send successfully hei");
      } else {
        print("Something went wrongsdfa");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addtounseenmessage(
      {required String userimage,
      required String username,
      required String userid,
      required String title,
      required String email}) async {
    try {
      print("${title}hlkdfjalkjd$email");
      http.Response res = await http.post(Uri.parse(addtounseenmessageurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "title": title,
            "username": username,
            "userid": userid,
            "userimage": userimage
          }));
      print("ksjfalksjdflksjadf");
      print("${res.body} hello1212");
      print("ksjfalksjdflksjadf");
      if (res.statusCode == 200) {
        print("send successfully ok");
      } else {
        print("Something went wrongsdfa");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateunseenmessage({required String email}) async {
    try {
      http.Response res = await http.post(Uri.parse(updateunseenmessageurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
          }));

      print("${res.body} hello");

      if (res.statusCode == 200) {
        print("update success");
      } else {
        print("Something went wrongsdfa");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> getnumberofunreadmsg(
      {required String from, required String to}) async {
    int numUnread = 0;
    try {
      http.Response response = await http.post(Uri.parse(getnumberunread),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"from": from, "to": to, "userid": userSave.uid}));
      print(response.body);
      if (response.statusCode == 200) {
        numUnread = jsonDecode(response.body);
      }
      return numUnread;
    } catch (e) {
      print(e.toString());
    }
    return numUnread;
  }

  Future<void> updateusernumberofunseenmes(
      {required String from, required String to}) async {
    try {
      http.Response response = await http.post(Uri.parse(updatenumberofstatus),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"from": from, "to": to, "userid": userSave.uid}));
      print(response.body);
      if (response.statusCode == 200) {
        print("success");
      } else {
        print("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

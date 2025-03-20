import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/global_vars.dart';

class SupprotService {
  Future<void> postquery({
    required String email,
    required String desc,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse(postqueryurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
            "description": desc,
            "name": userSave.name,
            "surname": userSave.surname,
          }));
      // print("this is our sending query ${jsonEncode({
      //       "email": email,
      //       "description": desc,
      //       "name": userSave.name,
      //       "surname": userSave.surname,
      //     })}");
      if (res.statusCode == 200) {
        // print("add to sortlist successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletesendlink(
      {required String email, required String value}) async {
    try {
      http.Response res = await http.post(Uri.parse(deletesendlinkurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email, "value": value}));
      if (res.statusCode == 200) {
        print("Delete sendlink successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getsupports(String email) async {
    var data;
    try {
      http.Response res = await http.post(Uri.parse(getsupporturl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email}));
      print("${res.body} hello33");
      if (res.statusCode == 200) {
        data = jsonDecode(res.body);
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

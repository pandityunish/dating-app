import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/location_modal.dart';
import 'package:ristey/models/new_user_modal.dart';

class Searchservice {
  Future<List<NewUserModel>> getuserdatabyid(
      {required String puid, required String email}) async {
    List<NewUserModel> allusers = [];

    try {
      http.Response res = await http.post(Uri.parse(searchuserbyid),
          headers: {'Content-Type': 'Application/json'},
          body: json.encode({"puid": puid, "email": email}));
      print("${res.body} hello");
      if (res.statusCode == 200) {
        for (var i = 0; i < jsonDecode(res.body).length; i++) {
          allusers
              .add(NewUserModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));

          // print(userdata);
        }
        return allusers;
      } else {
        print("something went wrongyunish");
      }
    } catch (e) {
      print(e.toString());
    }
    return allusers;
  }

  Future<List<NewUserModel>> getuserdatabydistance(
      {required String email,
      required double lat,
      required double lng,
      required int distance}) async {
    List<NewUserModel> allusers = [];

    try {
      http.Response res = await http.post(Uri.parse(searchuserbydistance),
          headers: {'Content-Type': 'Application/json'},
          body: json.encode({
            "email": email,
            "longitude": lng,
            "latitude": lat,
            "maxDistanceKm": distance
          }));
      print("${res.body} hello");
      if (res.statusCode == 200) {
        for (var i = 0; i < jsonDecode(res.body).length; i++) {
          allusers
              .add(NewUserModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));

          // print(userdata);
        }
        return allusers;
      } else {
        print("something went wrongyunish");
      }
    } catch (e) {
      print(e.toString());
    }
    return allusers;
  }

  Future<List<NewUserModel>> searchuserdata(
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
      required int maxDistanceKm,
      required List<dynamic> location,
      required List<dynamic> statelocation,
      required List<dynamic> citylocation}) async {
    List<NewUserModel> allusers = [];

    try {
      http.Response res = await http.post(Uri.parse(searchusers),
          headers: {'Content-Type': 'Application/json'},
          body: json.encode({
            "gender": gender,
            "religion": religion,
            "page": page,
            "email": email,
            "ages": ages,
            "religionList": religionList,
            'latitude': userSave.latitude,
            'longitude': userSave.longitude,
            "kundaliDoshList": kundaliDoshList,
            "maritalStatusList": maritalStatusList,
            "dietList": dietList,
            "drinkList": drinkList,
            "smokeList": smokeList,
            "disabilityList": disabilityList,
            "heightList": heightList,
            "educationList": educationList,
            "professionList": professionList,
            "incomeList": incomeList,
            "maxDistanceKm": maxDistanceKm,
            "citylocation": citylocation,
            "statelocation": statelocation,
            "location": location
          }));
      print("hello12345");
      print(jsonDecode(res.body).length);
      print("${res.body} hello");
      print("hello1256");

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

  Future<String> loadJsonData() async {
    return await rootBundle.loadString('assets/country.json');
  }

  Future<List<LocationModel>> getData() async {
    String jsonString = await loadJsonData();
    List<dynamic> jsonData = json.decode(jsonString);
    print(jsonData);
    List<LocationModel> persons =
        jsonData.map((json) => LocationModel.fromJson(json)).toList();
    return persons;
  }

  Future<void> unverifyuser({required String email}) async {
    try {
      http.Response res = await http.post(Uri.parse(updateunverifyuserurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "email": email,
          }));
      if (res.statusCode == 200) {
        print("unverify user");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

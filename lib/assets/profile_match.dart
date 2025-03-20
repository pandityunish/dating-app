import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/new_user_modal.dart';

class ProfileMatch {
  final List matchPercentage = [];
  int profileMatch(data) {
    var match = 0;
    if (userSave.religion == data.religion) {
      // print("1");
      match += 10;
    }
    if (userSave.KundaliDosh == data.kundalidosh) {
      // print("2");
      match += 10;
    }
    if (userSave.MartialStatus == data.martialstatus) {
      // print("3");
      match += 10;
    }
    if (userSave.Diet == data.diet) {
      // print("4");
      match += 10;
    }
    if (userSave.gender != data.gender) {
      if (userSave.gender == "Male" &&
          (double.parse(userSave.Height!.split(' ')[0]) >
              data.height!.split(' ')[0])) {
        match += 10;
      } else if (userSave.gender == "Female" &&
          (double.parse(userSave.Height!.split(' ')[0]) <
              data.height!.split(' ')[0])) {
        match += 10;
      }
    }
    if (userSave.Profession == data.profession) {
      // print("5");
      match += 10;
    }
    if (userSave.Diet == data.diet) {
      // print("6");
      match += 10;
    }
    if (userSave.Drink == data.drink) {
      // print("7");
      match += 5;
    }
    if (userSave.Smoke == data.smoke) {
      // print("8");
      match += 5;
    }
    if (userSave.Disability == data.disability) {
      // print("9");
      match += 10;
    }
    // if (profileMatchDataJson.LocatioList.toString().contains(data.Location)) {
    //   match += 10;
    // }
    if (match > 90) {
      match = 100;
    }

    // matchConditionCheck();
    // print(match);
    return match;
  }

  Future<double> getallusermatch(NewUserModel newuserModel) async {
    var data;
    if (userSave.gender == "male") {
      DateTime dateofbirth = DateTime.fromMillisecondsSinceEpoch(userSave.dob!);

      String mDay = dateofbirth.day.toString();
      String mMonth = dateofbirth.month.toString();
      String mYear = dateofbirth.year.toString();
      DateTime dateofbirth1 =
          DateTime.fromMillisecondsSinceEpoch(newuserModel.dob);
      String fDay = dateofbirth1.day.toString();
      String fMonth = dateofbirth1.month.toString();
      String fYear = dateofbirth1.year.toString();
      List<String> mParts = userSave.timeofbirth!.split(':');
      int mHours = int.parse(mParts[0]);

      List<String> minuteAndAmPm = mParts[1].split(' ');
      int mMinutes = int.parse(minuteAndAmPm[0]);
      List<String> fParts = newuserModel.timeofbirth.split(':');
      print("******************");
      print(fParts);
      print("******************");
      int fHours = int.parse(fParts[0]);

      List<String> fminuteAndAmPm = fParts[1].split(' ');
      int fMinutes = int.parse(fminuteAndAmPm[0]);
      print("******************");
      print(fHours);
      print("******************");
      var url = Uri.parse(
          'https://api.kundali.astrotalk.com/v1/combined/match_making');
      print(userSave.latitude);
      print(userSave.longitude);
      var payload = {
        "m_detail": {
          "day": mDay,
          "hour": mHours,
          "lat": userSave.latitude,
          "lon": userSave.longitude,
          "min": mMinutes,
          "month": mMonth,
          "name": userSave.name,
          "tzone": "5.5",
          "year": mYear,
          "gender": "male",
          "place": userSave.Location,
          "sec": 0
        },
        "f_detail": {
          "day": fDay,
          "hour": fHours,
          "lat": newuserModel.lat,
          "lon": newuserModel.lng,
          "min": fMinutes,
          "month": fMonth,
          "name": newuserModel.name,
          "tzone": "5.5",
          "year": fYear,
          "gender": "female",
          "place": newuserModel.location,
          "sec": 0
        },
        "languageId": 1
      };

      var body = json.encode(payload);

      var response = await http
          .post(url, body: body, headers: {'Content-Type': 'application/json'});
      print("*********************");
      print(response.body);
      print("*********************");
      if (response.statusCode == 200) {
        print("999999999999999999999999");
        print(
            jsonDecode(response.body)['ashtkoot']['total']['received_points']);
        data = jsonDecode(response.body)['ashtkoot']['total']['received_points']
            .toDouble();

        return data;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } else {
      DateTime dateofbirth =
          DateTime.fromMillisecondsSinceEpoch(newuserModel.dob);

      String mDay = dateofbirth.day.toString();
      String mMonth = dateofbirth.month.toString();
      String mYear = dateofbirth.year.toString();
      DateTime dateofbirth1 =
          DateTime.fromMillisecondsSinceEpoch(userSave.dob!);
      String fDay = dateofbirth1.day.toString();
      String fMonth = dateofbirth1.month.toString();
      String fYear = dateofbirth1.year.toString();
      List<String> mParts = newuserModel.timeofbirth.split(':');
      int mHours = int.parse(mParts[0]);

      List<String> minuteAndAmPm = mParts[1].split(' ');
      int mMinutes = int.parse(minuteAndAmPm[0]);
      List<String> fParts = userSave.timeofbirth!.split(':');
      int fHours = int.parse(fParts[0]);

      List<String> fminuteAndAmPm = fParts[1].split(' ');
      int fMinutes = int.parse(fminuteAndAmPm[0]);
      print(mYear);
      var url = Uri.parse(
          'https://api.kundali.astrotalk.com/v1/combined/match_making');

      var payload = {
        "m_detail": {
          "day": mDay,
          "hour": mHours,
          "lat": newuserModel.lat,
          "lon": newuserModel.lng,
          "min": mMinutes,
          "month": mMonth,
          "name": newuserModel.name,
          "tzone": "5.5",
          "year": mYear,
          "gender": "male",
          "place": newuserModel.location,
          "sec": 0
        },
        "f_detail": {
          "day": fDay,
          "hour": fHours,
          "lat": userSave.latitude,
          "lon": userSave.longitude,
          "min": fMinutes,
          "month": fMonth,
          "name": userSave.name,
          "tzone": "5.5",
          "year": fYear,
          "gender": "female",
          "place": userSave.Location,
          "sec": 0
        },
        "languageId": 1
      };

      var body = json.encode(payload);

      var response = await http
          .post(url, body: body, headers: {'Content-Type': 'application/json'});
      print("##################");
      print(response);
      print("##################");
      if (response.statusCode == 200) {
        data = jsonDecode(response.body)['ashtkoot']['total']['received_points']
            .toDouble();
        return data;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    return data;
  }
  // matchConditionCheck() {}
}

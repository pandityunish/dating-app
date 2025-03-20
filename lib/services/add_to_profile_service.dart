import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/global_vars.dart';

class AddToProfileService {
  void addtosearchprofile(
      {required String searchprofile,
      required String searchDistance,
      required String age,
      required String religion,
      required String kundalidosh,
      required String marital_status,
      required String diet,
      required String smoke,
      required String drink,
      required String disability,
      required List<dynamic> location1,
      required List<dynamic> statelocation,
      required List<dynamic> citylocation,
      required String height,
      required String education,
      required String profession,
      required String income,
      required String location}) async {
    try {
      http.Response res = await http.post(Uri.parse(addtoprofilesearchurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "searchidprofile": searchprofile,
            "searchDistance": searchDistance,
            "age": age,
            "religion": religion,
            "kundlidosh": kundalidosh,
            "location1": location1,
            "statelocation": statelocation,
            "citylocation": citylocation,
            "marital_status": marital_status,
            "diet": diet,
            "smoke": smoke,
            "drink": drink,
            "disability": disability,
            "height": height,
            "education": education,
            "profession": profession,
            "income": income,
            "name": userSave.name,
            "location": location,
            "userid": userSave.uid
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void addtokundaliprofile(
      {required String gname,
      required String gday,
      required String gmonth,
      required String gyear,
      required String ghour,
      required String gplace,
      required String gsec,
      required String bname,
      required String gkundli,
      required String bkundli,
      required String bday,
      required String bmonth,
      required String byear,
      required String bhour,
      required String bsec,
      required String bplace,
      required String totalgun,
      required String bam,
      required String gam}) async {
    try {
      http.Response res = await http.post(Uri.parse(addtokundaliprofileurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "gname": gname,
            "gday": gday,
            "gplace": gplace,
            "bam": bam,
            "gam": gam,
            "gkundli": gkundli,
            "bkundli": bkundli,
            "gmonth": gmonth,
            "gyear": gyear,
            "ghour": ghour,
            "gsec": gsec,
            "bname": bname,
            "bday": bday,
            "bmonth": bmonth,
            "byear": byear,
            "bhour": bhour,
            "bsec": bsec,
            "bplace": bplace,
            "totalgun": totalgun,
            "name": userSave.name,
            "userid": userSave.uid
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void addtosavedprefprofile(
      {required List<dynamic> ageList,
      required List<dynamic> religionList,
      required List<dynamic> kundaliDoshList,
      required List<dynamic> maritalStatusList,
      required List<dynamic> dietList,
      required List<dynamic> drinkList,
      required List<dynamic> smokeList,
      required String name,
      required List<dynamic> disabilityList,
      required List<dynamic> heightList,
      required List<dynamic> educationList,
      required List<dynamic> professionList,
      required List<dynamic> incomeList,
      required List<dynamic> location,
      required List<dynamic> statelocation,
      required List<dynamic> citylocation}) async {
    try {
      http.Response res = await http.post(Uri.parse(addtosharedprefsearch),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "ageList": ageList,
            "citylocation": citylocation,
            "religionList": religionList,
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
            "location": location,
            "statelocation": statelocation,
            "email": userSave.email,
            "name": name,
            "userid": userSave.uid
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updateonlineuser() async {
    try {
      http.Response res = await http.post(Uri.parse(updateonlineprofile),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"id": userSave.uid}));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updatedownloadbiodata() async {
    try {
      http.Response res = await http.post(Uri.parse(updatbiodataprofile),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"id": userSave.uid}));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updatechatnow() async {
    try {
      http.Response res = await http.post(Uri.parse(updatechatnowprofile),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"id": userSave.uid}));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updateprofileverified() async {
    try {
      http.Response res = await http.post(Uri.parse(updateprofileverifiedurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"id": userSave.uid}));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updatebiodata() async {
    try {
      http.Response res = await http.post(Uri.parse(updatebiodataurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"id": userSave.uid}));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updateonlinedata() async {
    try {
      http.Response res = await http.post(Uri.parse(updateonlinenumberdata),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"id": userSave.uid}));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updatesupport() async {
    try {
      http.Response res = await http.post(Uri.parse(updatesupporturl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"id": userSave.uid}));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updateshare() async {
    try {
      http.Response res = await http.post(Uri.parse(updateshareurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"id": userSave.uid}));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updateinterestsent() async {
    try {
      http.Response res = await http.post(Uri.parse(updateinteresturl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": userSave.email}));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updateprofileviewer() async {
    try {
      print("ok pro ${userSave.email}");
      http.Response res = await http.post(Uri.parse(updateprofileviewerurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": userSave.email}));
      if (res.statusCode == 200) {}
    } catch (e) {
      print("*******************21*");
      print(e.toString());
    }
  }

  void updateprofileviewed(String email) async {
    try {
      http.Response res = await http.post(Uri.parse(updateprofileviewedurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"email": email}));

      if (res.statusCode == 200) {}
    } catch (e) {
      print(e.toString());
    }
  }

  void marriageloanupdate() async {
    try {
      http.Response res = await http.post(Uri.parse(marriageloanupdateurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"id": userSave.uid}));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void freepersonmatch() async {
    try {
      http.Response res = await http.post(Uri.parse(freepersonmatchurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"id": userSave.uid}));
      print(res.body);
      if (res.statusCode == 200) {
        print("updatelogin  successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

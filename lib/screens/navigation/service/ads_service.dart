import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/models/ads_modal.dart';

class AdsService {
  Future<List<AdsModel>> getallusers({required String adsid}) async {
    List<AdsModel> getallusersdata = [];
    try {
      http.Response response = await http.post(Uri.parse(getallads),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({"adsid": adsid}));
      // print(response.body);
      if (response.statusCode == 200) {
        for (var i = 0; i < jsonDecode(response.body).length; i++) {
          getallusersdata
              .add(AdsModel.fromJson(jsonEncode(jsonDecode(response.body)[i])));

          // print(userdata);
        }
      } else {
        print("Something went wrong");
      }
    } catch (e) {
      print("${e}3ee");
    }
    return getallusersdata;
  }
   Future<void> updateSeenAds(
      {required String adsId,
     }) async {
    try {
  
      http.Response res = await http.post(Uri.parse(updateseenadurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "id": adsId,
           
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("Admin notification added successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> updateClickAds(
      {required String adsId,
     }) async {
    try {
  
      http.Response res = await http.post(Uri.parse(updateclickadurl),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            "id": adsId,
           
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print("Admin notification added successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

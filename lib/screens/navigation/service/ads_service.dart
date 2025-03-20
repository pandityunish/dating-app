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
}

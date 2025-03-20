import 'dart:convert';
import 'dart:developer';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:ristey/global_vars.dart';

import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'dart:convert';
// Import the necessary function:
// Correct import

class FirebaseAuthService {
  static Future<String?> getAccessToken() async {
    try {
      final serviceAccount = await rootBundle.loadString('assets/token.json');
      final Map<String, dynamic> keyMap = json.decode(serviceAccount);

      try {
        final credentials = ServiceAccountCredentials.fromJson(keyMap);
        final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

        try {
          // Use the imported function correctly:
          final client = await clientViaServiceAccount(credentials, scopes); // Correct usage

          final accessToken = client.credentials.accessToken.data;

      
            print("Access Token: $accessToken");
            return accessToken;
         
        } catch (e) {
          print("Error getting HTTP client: $e");
          return null;
        }
      } catch (e) {
        print("Error parsing service account JSON: $e");
        return null;
      }
    } catch (e) {
      print("Error loading service account file: $e");
      return null;
    }
  }
}

// Example usage (in your widget or other part of your app):


class SendMessage {
  void sendPushMessage(
      String body, String title, String userid, String route, String token,
      {String userName = "", String sound = "navnot"}) async {
    try {
        String? newtoken = await FirebaseAuthService.getAccessToken();
      http.Response res = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/freerishteywala-2f843/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $newtoken',
        },
        body: jsonEncode(
         {"message": <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            "android": {"priority": "high"},
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'uid': userid,
              'route': route,
              'id': userSave.uid,
              'userName': userName,
              'status': 'done',
              'sound': sound
            },
            "token": token,
          },}
        ),
      );
      log(res.body);
    } catch (e) {
      log("$e");
      print("error push notification");
    }
  }
}

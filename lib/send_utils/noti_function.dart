// import 'package:couple_match/screens/profile/service/home_service.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/send_utils/noti_modal.dart';

class NotificationFunction {
  static setNotification(String toWhome, String text, String Type,
      {String useruid = ""}) async {
    DatabaseReference dbref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://freerishteywala-2f843-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref();
    dbref = dbref.child(toWhome);
    String? tempuid;
    // print(useruid);
    if (toWhome == 'user2') {
      tempuid = useruid;
      useruid = userSave.uid!;
      // } else if (toWhome != 'user2' && useruid != null) {
      //   tempuid = useruid;
    } else {
      tempuid = (userSave.uid == null) ? useruid : userSave.uid;
    }
    if (useruid == "") {
      useruid = userSave.uid!;
    }
    // print("$tempuid , useruid : $useruid");
    if (await docexist(dbref.child(tempuid ?? ""))) {
      DateTime time = DateTime.now().toUtc();
      int millisecondsSinceEpoch = time.millisecondsSinceEpoch;
      NotifyModel temp = NotifyModel(
          text: text, uid: useruid, type: Type, time: millisecondsSinceEpoch);
      dbref.child(tempuid ?? "").push().update(temp.toJson());
    } else {
      DateTime time = DateTime.now().toUtc();
      int millisecondsSinceEpoch = time.millisecondsSinceEpoch;
      NotifyModel temp = NotifyModel(
          text: text, uid: useruid, type: Type, time: millisecondsSinceEpoch);
      dbref.child(tempuid ?? "").push().set(temp.toJson());
    }
  }

  static Future<bool> docexist(DatabaseReference databaseReference) async {
    DatabaseEvent dataSnapshot = await databaseReference.once();
    return dataSnapshot.snapshot.value != null;
  }

  showNotification(String towhome) {}

  static Future<void> setOnlineStatus(String userUid, String status) async {
    try {
      // Reference to the Firebase Database
      DatabaseReference dbRef = FirebaseDatabase.instanceFor(
        app: Firebase
            .app(), // Optional, can specify app if you use multiple apps
        databaseURL:
            "https://freerishteywala-2f843-default-rtdb.asia-southeast1.firebasedatabase.app",
      ).ref().child("onlineStatus");

      // Debugging: Print current state
      print(
          "Attempting to update online status for user: $userUid with status: $status");

      // If the user is online, update the offline time
      if (status == "Online") {
        if (userSave.email != null) {
          await HomeService().updateoffiletime(
            email: userSave.email!,
            time: DateTime.now().toString(),
          );
        } else {
          print("userSave.email is null, aborting operation.");
          return;
        }
      }

      // Check if the user exists in the database
      bool userExists = await docExists(dbRef.child(userUid));
      print("User exists in database: $userExists");

      // Prepare status update map
      Map<String, String> statusUpdate = {
        "status": status,
        "uid": userUid,
      };

      // Log the status update being applied
      print("Prepared status update: $statusUpdate");

      // Set or update the status in the database
      if (userExists) {
        print("User exists, attempting to update...");
        await dbRef
            .child(userUid)
            .update(statusUpdate)
            .timeout(const Duration(seconds: 10));
        print("User status updated successfully for $userUid");
      } else {
        print("User does not exist, attempting to set new status...");
        await dbRef
            .child(userUid)
            .set(statusUpdate)
            .timeout(const Duration(seconds: 10));
        print("User status set successfully for $userUid");
      }
    } on TimeoutException catch (e) {
      print("Timeout while updating status: $e");
    } on FirebaseException catch (e) {
      print("Firebase error: $e");
    } catch (e) {
      // General error handling
      print("Error updating online status: $e");
    }
  }

  static Future<bool> docExists(DatabaseReference ref) async {
    try {
      print("Checking if document exists...");

      // Set a timeout for the request
      DataSnapshot snapshot =
          await ref.get().timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("Firebase request timed out");
      });

      print("Document check complete.");
      return snapshot.exists;
    } catch (e) {
      print("Error while checking document existence: $e");
      return false;
    }
  }

  static settoken(String useruid, String token) async {
    DatabaseReference dbref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://freerishteywala-2f843-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref();
    dbref = dbref.child("token");

    if (await docexist(dbref.child(useruid))) {
      dbref.child(useruid).update({"token": token, "uid": useruid});
    } else {
      dbref.child(useruid).set({"token": token, "uid": useruid});
    }
  }

  static createChatroom(String useruid, String frienduid) async {
    DatabaseReference dbref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://freerishteywala-2f843-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref();
    dbref = dbref.child("chatroomids");
    final id = generateUniqueId();
    DateTime time = DateTime.now().toUtc();
    int timeStamp = time.millisecondsSinceEpoch;

    dbref.child(useruid).child(id).set({
      'useruid': useruid,
      'frienduid': frienduid,
      'roomid': id,
      'lmtime': timeStamp,
      'lmtext': '',
      'userdeactivetime': 0,
      'frienddeactivetime': 0,
      'blockedby': ""
    });

    dbref.child(frienduid).child(id).set({
      'useruid': frienduid,
      'frienduid': useruid,
      'roomid': id,
      'lmtime': timeStamp,
      'lmtext': '',
      'userdeactivetime': 0,
      'frienddeactivetime': 0,
      'blockedby': ""
    });

    return id;
  }

  static updateChatroom(
      String id, String useruid, String frienduid, String message) async {
    DatabaseReference dbref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://freerishteywala-2f843-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref();
    dbref = dbref.child("chatroomids");
    // final id = generateUniqueId();
    DateTime time = DateTime.now().toUtc();
    int timeStamp = time.millisecondsSinceEpoch;

    dbref.child(useruid).child(id).update({
      // 'useruid': useruid,
      // 'frienduid': frienduid,
      // 'roomid': id,
      'lmtime': timeStamp,
      'lmtext': message,
      // 'userdeactivetime': 0,
      // 'frienddeactivetime': 0,
      // 'blockedby': ""
    });

    dbref.child(frienduid).child(id).update({
      // 'useruid': frienduid,
      // 'frienduid': useruid,
      // 'roomid': id,
      'lmtime': timeStamp,
      'lmtext': '',
      // 'userdeactivetime': 0,
      // 'frienddeactivetime': 0,
      // 'blockedby': ""
    });

    // return id;
  }

  static String generateUniqueId() {
    final now = DateTime.now();
    final uniqueId = now.microsecondsSinceEpoch.toString();
    return uniqueId;
  }

  static setFriendList() {}
}

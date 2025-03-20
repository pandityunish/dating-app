import 'package:firebase_database/firebase_database.dart';

class NotifyModel {
  String text;
  String uid;
  String type;
  dynamic time;

  NotifyModel({this.text = "", this.uid = "", this.type = "", this.time});

  Map<String, dynamic> toJson() => {
        'text': text,
        'uid': uid,
        'type': type,
        'time': time ?? ServerValue.timestamp,
      };
  static NotifyModel fromdoc(var doc) {
    NotifyModel txt = NotifyModel(
        text: doc['text'].toString(),
        uid: doc['uid'].toString(),
        type: doc['type'].toString(),
        time: doc['time']);
    return txt;
  }
}

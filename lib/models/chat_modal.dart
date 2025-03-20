import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatsModel {
  final String username;
  final String userimage;
  final String userid;
  final String lastmessage;
  final DateTime lasttime;
  final String email;
  ChatsModel({
    required this.username,
    required this.userimage,
    required this.userid,
    required this.email,
    required this.lastmessage,
    required this.lasttime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'userimage': userimage,
      'userid': userid,
      'email': email,
      'lastmessage': lastmessage,
      'lasttime': lasttime.millisecondsSinceEpoch,
    };
  }

  factory ChatsModel.fromMap(Map<String, dynamic> map) {
    return ChatsModel(
      username: map['username'] as String,
      userimage: map['userimage'] as String,
      userid: map['userid'] as String,
      email: map['email'] as String,
      lastmessage: map['lastmessage'] as String,
      lasttime: DateTime.fromMillisecondsSinceEpoch(map['lasttime'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatsModel.fromJson(String source) =>
      ChatsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

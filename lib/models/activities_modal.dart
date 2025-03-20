import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ActivitiesModel {
  final String title;
  final String username;
  final String userimage;
  final String userid;
  final String createdAt;
  final String id;
  final bool? delete;
  final bool? isSeen;
  ActivitiesModel({
    required this.title,
    required this.username,
    required this.userimage,
    required this.userid,
    required this.createdAt,
    required this.id,
    this.delete,
    this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'username': username,
      'userimage': userimage,
      'userid': userid,
      'createdAt': createdAt,
      '_id': id,
      'delete': delete,
      'isSeen': isSeen
    };
  }

  factory ActivitiesModel.fromMap(Map<String, dynamic> map) {
    return ActivitiesModel(
      title: map['title'] as String,
      username: map['username'] as String,
      userimage: map['userimage'] as String,
      userid: map['userid'] as String,
      createdAt: map['createdAt'] as String,
      id: map["_id"] as String,
      // delete: map["delete"] as bool,
      // isSeen: map["isSeen"] as bool
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivitiesModel.fromJson(String source) =>
      ActivitiesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

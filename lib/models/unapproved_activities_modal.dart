// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UnapproveActivites {
  final String senduserid;
  final String reciveuserid;
  final String userimage;
  final String title;
  final String token;
  final String id;
  final String email;
  UnapproveActivites(
      {required this.senduserid,
      required this.email,
      required this.reciveuserid,
      required this.userimage,
      required this.title,
      required this.token,
      required this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senduserid': senduserid,
      'reciveuserid': reciveuserid,
      'userimage': userimage,
      'title': title,
      'token': token,
      'id': id,
      'email': email
    };
  }

  factory UnapproveActivites.fromMap(Map<String, dynamic> map) {
    return UnapproveActivites(
      senduserid: map['senduserid'] as String,
      reciveuserid: map['reciveuserid'] as String,
      userimage: map['userimage'] as String,
      title: map['title'] as String,
      token: map['token'] as String,
      email: map['email'] as String,
      id: map['_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UnapproveActivites.fromJson(String source) =>
      UnapproveActivites.fromMap(json.decode(source) as Map<String, dynamic>);
}

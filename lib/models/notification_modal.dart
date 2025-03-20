import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationModel {
  final String title;
  final String datetime;
  NotificationModel({
    required this.title,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'createdAt': datetime,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] as String,
      datetime: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

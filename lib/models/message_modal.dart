import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModelChats {
  final String text;
  final String sender;
  final String status;
  final int time;
  final String uid;
  MessageModelChats({
    required this.text,
    required this.sender,
    required this.status,
    required this.time,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'sender': sender,
      'status': status,
      'time': time,
      'uid': uid,
    };
  }

  factory MessageModelChats.fromMap(Map<String, dynamic> map) {
    return MessageModelChats(
      text: map['text'] as String,
      sender: map['sender'] as String,
      status: map['status'] as String,
      time: map['time'] as int,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModelChats.fromJson(String source) =>
      MessageModelChats.fromMap(json.decode(source) as Map<String, dynamic>);
}

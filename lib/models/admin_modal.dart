import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AdminModel {
  final String email;
  final double lat;
  final double lng;
  final String username;
  final List<dynamic> permissions;
  final String token;
  AdminModel({
    required this.email,
    required this.lat,
    required this.permissions,
    required this.lng,
    required this.username,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'lat': lat,
      'lng': lng,
      'username': username,
      'token': token
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      email: map['email'] as String,
      username: map['username'] as String,
      token: map['token'] as String,
      permissions: List<dynamic>.from((map['permissions'] as List<dynamic>)),
      lat: map['lat'] as double,
      lng: map['lng'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminModel.fromJson(String source) =>
      AdminModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

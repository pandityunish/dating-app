import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AdsModel {
  final String image;
  final String createdAt;
  final String adsid;
  final String description;
  final String video;
  final bool isActive;
  AdsModel({
    required this.image,
    required this.createdAt,
    required this.adsid,
    required this.video,
    required this.description,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'createdAt': createdAt,
      'adsid': adsid,
    };
  }

  factory AdsModel.fromMap(Map<String, dynamic> map) {
    return AdsModel(
      image: map['image'] as String,
      createdAt: map['createdAt'] as String,
      adsid: map['adsid'] as String,
      description: map['description'] as String,
      video: map['video'] as String,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdsModel.fromJson(String source) =>
      AdsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

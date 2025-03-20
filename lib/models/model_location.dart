import 'dart:convert';

List<ModelLocation> modelLocationFromMap(String str) =>
    List<ModelLocation>.from(
        json.decode(str).map((x) => ModelLocation.fromMap(x)));

String modelLocationToMap(List<ModelLocation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ModelLocation {
  String city;
  String cityAscii;
  double lat;
  double lng;
  String country;
  String iso2;
  String iso3;
  String? adminName;
  String? capital;
  int? population;
  int? id;

  ModelLocation({
    required this.city,
    required this.cityAscii,
    required this.lat,
    required this.lng,
    required this.country,
    required this.iso2,
    required this.iso3,
    this.adminName,
    this.capital,
    this.population,
    this.id,
  });

  factory ModelLocation.fromMap(Map<String, dynamic> json) => ModelLocation(
        city: json["city"],
        cityAscii: json["city_ascii"],
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
        country: json["country"],
        iso2: json["iso2"],
        iso3: json["iso3"],
        adminName: json["admin_name"],
        capital: json["capital"],
        population: json["population"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "city": city,
        "city_ascii": cityAscii,
        "lat": lat,
        "lng": lng,
        "country": country,
        "iso2": iso2,
        "iso3": iso3,
        "admin_name": adminName,
        "capital": capital,
        "population": population,
        "id": id,
      };
}

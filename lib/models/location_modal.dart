import 'dart:convert';

List<LocationModel> locationModelFromJson(String str) =>
    List<LocationModel>.from(
        json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationModelToJson(List<LocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
  int id;
  String name;
  String emoji;
  String emojiU;
  List<State1> state;

  LocationModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.emojiU,
    required this.state,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: json["id"],
        name: json["name"],
        emoji: json["emoji"],
        emojiU: json["emojiU"],
        state: List<State1>.from(json["state"].map((x) => State1.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "emoji": emoji,
        "emojiU": emojiU,
        "state": List<dynamic>.from(state.map((x) => x.toJson())),
      };
}

class State1 {
  int id;
  String name;
  int countryId;
  List<City> city;

  State1({
    required this.id,
    required this.name,
    required this.countryId,
    required this.city,
  });

  factory State1.fromJson(Map<String, dynamic> json) => State1(
        id: json["id"],
        name: json["name"],
        countryId: json["country_id"],
        city: List<City>.from(json["city"].map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_id": countryId,
        "city": List<dynamic>.from(city.map((x) => x.toJson())),
      };
}

class City {
  int id;
  String name;
  int stateId;

  City({
    required this.id,
    required this.name,
    required this.stateId,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        stateId: json["state_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "state_id": stateId,
      };
}

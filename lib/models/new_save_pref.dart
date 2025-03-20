import 'dart:convert';

NewSavePrefModel newSavePrefModelFromJson(String str) =>
    NewSavePrefModel.fromJson(json.decode(str));

String newSavePrefModelToJson(NewSavePrefModel data) =>
    json.encode(data.toJson());

class NewSavePrefModel {
  String id;
  String email;
  List<dynamic> ageList;
  List<dynamic> religionList;
  List<dynamic> kundaliDoshList;
  List<dynamic> maritalStatusList;
  List<dynamic> dietList;
  List<dynamic> drinkList;
  List<dynamic> smokeList;
  List<dynamic> disabilityList;
  List<dynamic> heightList;
  List<dynamic> educationList;
  List<dynamic> professionList;
  List<dynamic> incomeList;
  List<dynamic> location;
  List<dynamic> statelocation;
  List<dynamic> citylocation;
  int v;

  NewSavePrefModel({
    required this.id,
    required this.email,
    required this.ageList,
    required this.statelocation,
    required this.citylocation,
    required this.religionList,
    required this.kundaliDoshList,
    required this.maritalStatusList,
    required this.dietList,
    required this.drinkList,
    required this.smokeList,
    required this.disabilityList,
    required this.heightList,
    required this.educationList,
    required this.professionList,
    required this.incomeList,
    required this.location,
    required this.v,
  });

  factory NewSavePrefModel.fromJson(Map<String, dynamic> json) =>
      NewSavePrefModel(
        id: json["_id"],
        email: json["email"],
        ageList: List<dynamic>.from(json["ageList"].map((x) => x)),
        citylocation: List<dynamic>.from(json["citylocation"].map((x) => x)),
        statelocation: List<dynamic>.from(json["statelocation"].map((x) => x)),
        religionList: List<dynamic>.from(json["religionList"].map((x) => x)),
        kundaliDoshList:
            List<dynamic>.from(json["kundaliDoshList"].map((x) => x)),
        maritalStatusList:
            List<dynamic>.from(json["maritalStatusList"].map((x) => x)),
        dietList: List<dynamic>.from(json["dietList"].map((x) => x)),
        drinkList: List<dynamic>.from(json["drinkList"].map((x) => x)),
        smokeList: List<dynamic>.from(json["smokeList"].map((x) => x)),
        disabilityList:
            List<dynamic>.from(json["disabilityList"].map((x) => x)),
        heightList: List<dynamic>.from(json["heightList"].map((x) => x)),
        educationList: List<dynamic>.from(json["educationList"].map((x) => x)),
        professionList:
            List<dynamic>.from(json["professionList"].map((x) => x)),
        incomeList: List<dynamic>.from(json["incomeList"].map((x) => x)),
        location: List<dynamic>.from(json["location"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "ageList": List<dynamic>.from(ageList.map((x) => x)),
        "religionList": List<dynamic>.from(religionList.map((x) => x)),
        "kundaliDoshList": List<dynamic>.from(kundaliDoshList.map((x) => x)),
        "maritalStatusList":
            List<dynamic>.from(maritalStatusList.map((x) => x)),
        "dietList": List<dynamic>.from(dietList.map((x) => x)),
        "drinkList": List<dynamic>.from(drinkList.map((x) => x)),
        "smokeList": List<dynamic>.from(smokeList.map((x) => x)),
        "citylocation": List<dynamic>.from(citylocation.map((x) => x)),
        "statelocation": List<dynamic>.from(statelocation.map((x) => x)),
        "disabilityList": List<dynamic>.from(disabilityList.map((x) => x)),
        "heightList": List<dynamic>.from(heightList.map((x) => x)),
        "educationList": List<dynamic>.from(educationList.map((x) => x)),
        "professionList": List<dynamic>.from(professionList.map((x) => x)),
        "incomeList": List<dynamic>.from(incomeList.map((x) => x)),
        "location": List<dynamic>.from(location.map((x) => x)),
        "__v": v,
      };
}

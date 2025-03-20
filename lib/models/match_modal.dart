import 'dart:convert';

Match1 matchFromJson(String str) => Match1.fromJson(json.decode(str));

String matchToJson(Match1 data) => json.encode(data.toJson());

class Match1 {
  int status;
  Response response;

  Match1({
    required this.status,
    required this.response,
  });

  factory Match1.fromJson(Map<String, dynamic> json) => Match1(
        status: json["status"],
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class Response {
  String ashtakootScore;
  String dashkootScore;
  bool rajjudosh;
  bool vedhadosh;
  String mangaldosh;
  MangaldoshPoints mangaldoshPoints;
  String pitradosh;
  Points pitradoshPoints;
  String kaalsarpdosh;
  Points kaalsarpPoints;
  String manglikdoshSaturn;
  Points manglikdoshSaturnPoints;
  String manglikdoshRahuketu;
  Points manglikdoshRahuketuPoints;
  int score;
  String extendedResponse;
  String botResponse;

  Response({
    required this.ashtakootScore,
    required this.dashkootScore,
    required this.rajjudosh,
    required this.vedhadosh,
    required this.mangaldosh,
    required this.mangaldoshPoints,
    required this.pitradosh,
    required this.pitradoshPoints,
    required this.kaalsarpdosh,
    required this.kaalsarpPoints,
    required this.manglikdoshSaturn,
    required this.manglikdoshSaturnPoints,
    required this.manglikdoshRahuketu,
    required this.manglikdoshRahuketuPoints,
    required this.score,
    required this.extendedResponse,
    required this.botResponse,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        ashtakootScore: json["ashtakoot_score"],
        dashkootScore: json["dashkoot_score"],
        rajjudosh: json["rajjudosh"],
        vedhadosh: json["vedhadosh"],
        mangaldosh: json["mangaldosh"],
        mangaldoshPoints: MangaldoshPoints.fromJson(json["mangaldosh_points"]),
        pitradosh: json["pitradosh"],
        pitradoshPoints: Points.fromJson(json["pitradosh_points"]),
        kaalsarpdosh: json["kaalsarpdosh"],
        kaalsarpPoints: Points.fromJson(json["kaalsarp_points"]),
        manglikdoshSaturn: json["manglikdosh_saturn"],
        manglikdoshSaturnPoints:
            Points.fromJson(json["manglikdosh_saturn_points"]),
        manglikdoshRahuketu: json["manglikdosh_rahuketu"],
        manglikdoshRahuketuPoints:
            Points.fromJson(json["manglikdosh_rahuketu_points"]),
        score: json["score"],
        extendedResponse: json["extended_response"],
        botResponse: json["bot_response"],
      );

  Map<String, dynamic> toJson() => {
        "ashtakoot_score": ashtakootScore,
        "dashkoot_score": dashkootScore,
        "rajjudosh": rajjudosh,
        "vedhadosh": vedhadosh,
        "mangaldosh": mangaldosh,
        "mangaldosh_points": mangaldoshPoints.toJson(),
        "pitradosh": pitradosh,
        "pitradosh_points": pitradoshPoints.toJson(),
        "kaalsarpdosh": kaalsarpdosh,
        "kaalsarp_points": kaalsarpPoints.toJson(),
        "manglikdosh_saturn": manglikdoshSaturn,
        "manglikdosh_saturn_points": manglikdoshSaturnPoints.toJson(),
        "manglikdosh_rahuketu": manglikdoshRahuketu,
        "manglikdosh_rahuketu_points": manglikdoshRahuketuPoints.toJson(),
        "score": score,
        "extended_response": extendedResponse,
        "bot_response": botResponse,
      };
}

class Points {
  bool boy;
  bool girl;

  Points({
    required this.boy,
    required this.girl,
  });

  factory Points.fromJson(Map<String, dynamic> json) => Points(
        boy: json["boy"],
        girl: json["girl"],
      );

  Map<String, dynamic> toJson() => {
        "boy": boy,
        "girl": girl,
      };
}

class MangaldoshPoints {
  int boy;
  int girl;

  MangaldoshPoints({
    required this.boy,
    required this.girl,
  });

  factory MangaldoshPoints.fromJson(Map<String, dynamic> json) =>
      MangaldoshPoints(
        boy: json["boy"],
        girl: json["girl"],
      );

  Map<String, dynamic> toJson() => {
        "boy": boy,
        "girl": girl,
      };
}

import 'dart:convert';

Match2 match2FromJson(String str) => Match2.fromJson(json.decode(str));

String match2ToJson(Match2 data) => json.encode(data.toJson());

class Match2 {
  int status;
  Response response;

  Match2({
    required this.status,
    required this.response,
  });

  factory Match2.fromJson(Map<String, dynamic> json) => Match2(
        status: json["status"],
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class Response {
  int score;

  Response({
    required this.score,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "score": score,
      };
}

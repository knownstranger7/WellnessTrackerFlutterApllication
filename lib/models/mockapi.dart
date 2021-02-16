import 'dart:convert';

Mockapi mockapiFromJson(String str) => Mockapi.fromJson(json.decode(str));

String mockapiToJson(Mockapi data) => json.encode(data.toJson());

class Mockapi {
  Mockapi({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  int userId;
  int id;
  String title;
  String body;

  factory Mockapi.fromJson(Map<String, dynamic> json) => Mockapi(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "body": body,
  };
}

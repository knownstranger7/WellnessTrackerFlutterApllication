// To parse this JSON data, do
//
//     final wellnessBlockchain = wellnessBlockchainFromJson(jsonString);

import 'dart:convert';

WellnessBlockchain wellnessBlockchainFromJson(String str) => WellnessBlockchain.fromJson(json.decode(str));

String wellnessBlockchainToJson(WellnessBlockchain data) => json.encode(data.toJson());

class WellnessBlockchain {
  WellnessBlockchain({
    this.data,
  });

  Data data;

  factory WellnessBlockchain.fromJson(Map<String, dynamic> json) => WellnessBlockchain(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.bloodpressure,
    this.bodytemperature,
    this.cholesterol,
    this.glucose,
    this.heartrate,
    this.oxygensaturation,
    this.respiration,
  });

  int bloodpressure;
  String bodytemperature;
  int cholesterol;
  int glucose;
  int heartrate;
  int oxygensaturation;
  int respiration;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bloodpressure: json["bloodpressure"],
    bodytemperature: json["bodytemperature"],
    cholesterol: json["cholesterol"],
    glucose: json["glucose"],
    heartrate: json["heartrate"],
    oxygensaturation: json["oxygensaturation"],
    respiration: json["respiration"],
  );

  Map<String, dynamic> toJson() => {
    "bloodpressure": bloodpressure,
    "bodytemperature": bodytemperature,
    "cholesterol": cholesterol,
    "glucose": glucose,
    "heartrate": heartrate,
    "oxygensaturation": oxygensaturation,
    "respiration": respiration,
  };
}

import 'dart:convert';

WellnessPrediction wellnessPredictionFromJson(String str) => WellnessPrediction.fromJson(json.decode(str));

String wellnessPredictionToJson(WellnessPrediction data) => json.encode(data.toJson());

class WellnessPrediction {
  WellnessPrediction({
    this.chd,
  });

  String chd;

  factory WellnessPrediction.fromJson(Map<String, dynamic> json) => WellnessPrediction(
    chd: json["chd"],
  );

  Map<String, dynamic> toJson() => {
    "chd": chd,
  };
}

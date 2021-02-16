// To parse this JSON data, do
//
//     final wellnessTracker = wellnessTrackerFromJson(jsonString);

import 'dart:convert';

WellnessTracker wellnessTrackerFromJson(String str) => WellnessTracker.fromJson(json.decode(str));

String wellnessTrackerToJson(WellnessTracker data) => json.encode(data.toJson());

class WellnessTracker {
  WellnessTracker({
    this.steps,
    this.bodyTemperature,
    this.bloodPressure,
    this.respiration,
    this.glucose,
    this.heartRate,
    this.cholesterol,
    this.oxygenSaturation,
  });

  int steps;
  double bodyTemperature;
  int bloodPressure;
  int respiration;
  int glucose;
  int heartRate;
  int cholesterol;
  int oxygenSaturation;

  factory WellnessTracker.fromJson(Map<String, dynamic> json) => WellnessTracker(
    steps: json["Steps"],
    bodyTemperature: json["Body Temperature"].toDouble(),
    bloodPressure: json["Blood Pressure"],
    respiration: json["Respiration"],
    glucose: json["Glucose"],
    heartRate: json["Heart Rate"],
    cholesterol: json["Cholesterol"],
    oxygenSaturation: json["Oxygen Saturation"],
  );

  Map<String, dynamic> toJson() => {
    "Steps": steps,
    "Body Temperature": bodyTemperature,
    "Blood Pressure": bloodPressure,
    "Respiration": respiration,
    "Glucose": glucose,
    "Heart Rate": heartRate,
    "Cholesterol": cholesterol,
    "Oxygen Saturation": oxygenSaturation,
  };
}

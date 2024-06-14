// To parse this JSON data, do
//
//     final alarmData = alarmDataFromJson(jsonString);

import 'dart:convert';

List<AlarmData> alarmDataFromJson(String str) => List<AlarmData>.from(json.decode(str).map((x) => AlarmData.fromJson(x)));

String alarmDataToJson(List<AlarmData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AlarmData {
  int id;
  String alarmType;
  String content;
  dynamic createdAt;
  dynamic modifiedAt;
  dynamic removedAt;

  AlarmData({
    required this.id,
    required this.alarmType,
    required this.content,
    required this.createdAt,
    required this.modifiedAt,
    required this.removedAt,
  });

  factory AlarmData.fromJson(Map<String, dynamic> json) => AlarmData(
    id: json["id"],
    alarmType: json["alarmType"],
    content: json["content"],
    createdAt: json["createdAt"],
    modifiedAt: json["modifiedAt"],
    removedAt: json["removedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "alarmType": alarmType,
    "content": content,
    "createdAt": createdAt,
    "modifiedAt": modifiedAt,
    "removedAt": removedAt,
  };
}

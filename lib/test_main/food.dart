// To parse this JSON data, do
//
//     final food = foodFromJson(jsonString);

import 'dart:convert';

List<Food> foodFromJson(String str) => List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));

String foodToJson(List<Food> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Food {
  int id;
  String foodName;
  int quantity;
  String category;
  String storage;
  DateTime expiration;
  DateTime createdAt;
  String createdBy;
  DateTime modifiedAt;
  String modifiedBy;
  bool selected = false;

  Food({
    required this.id,
    required this.foodName,
    required this.quantity,
    required this.category,
    required this.storage,
    required this.expiration,
    required this.createdAt,
    required this.createdBy,
    required this.modifiedAt,
    required this.modifiedBy,
  });

  Food.clone(Food foodA) : this(id: foodA.id, foodName: foodA.foodName, quantity: foodA.quantity, category: foodA.category, storage: foodA.storage, expiration: foodA.expiration,
  createdAt: foodA.createdAt, createdBy: foodA.createdBy, modifiedAt: foodA.modifiedAt, modifiedBy: foodA.modifiedBy);


  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json["id"],
    foodName: json["foodName"],
    quantity: json["quantity"],
    category: json["category"],
    storage: json["storage"],
    expiration: DateTime.parse(json["expiration"]),
    createdAt: DateTime.parse(json["createdAt"]),
    createdBy: json["createdBy"],
    modifiedAt: DateTime.parse(json["modifiedAt"]),
    modifiedBy: json["modifiedBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "foodName": foodName,
    "quantity": quantity,
    "category": category,
    "storage": storage,
    "expiration": expiration.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "createdBy": createdBy,
    "modifiedAt": modifiedAt.toIso8601String(),
    "modifiedBy": modifiedBy,
  };
}

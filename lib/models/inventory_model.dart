import 'package:cloud_firestore/cloud_firestore.dart';

enum Category { dairy, vegetables, meat, spices, beverages }

enum Unit { kg, gram, litre, ml, piece }

class InventoryModel {
  String itemId;
  String name;
  String? imageUrl;
  Category category;
  double quantity = 0.0;
  Unit unit;
  double minQuantity = 0.0;
  bool? isDeleted = false;
  DateTime createdAt;

  InventoryModel({
    required this.itemId,
    required this.name,
    required this.category,
    this.imageUrl,
    required this.unit,
    required this.quantity,
    required this.minQuantity,
    this.isDeleted,
    required this.createdAt,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      itemId: json["uid"],
      name: json["name"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      category: json["category"] != null
          ? Category.values.byName(json["category"])
          : Category.vegetables,
      unit: json["unit"] != null ? Unit.values.byName(json["unit"]) : Unit.kg,

      quantity: json["quantity"] ?? 0,
      minQuantity: json["minQuantity"] ?? 0,
      isDeleted: json["isDeleted"] ?? false,
      createdAt: json["createdAt"],
    );
  }
  factory InventoryModel.fromMap(Map<String, dynamic> map) {
    return InventoryModel(
      itemId: map["itemId"],
      name: map["name"] ?? "",
      imageUrl: map["imageUrl"] ?? "",
      category: map["category"] != null
          ? Category.values.byName(map["category"])
          : Category.vegetables,
      unit: map["unit"] != null ? Unit.values.byName(map["unit"]) : Unit.kg,

      quantity: map["quantity"] ?? 0,
      minQuantity: map["minQuantity"] ?? 0,
      isDeleted: map["isDeleted"] ?? false,
      createdAt: map["createdAt"] != null
          ? (map["createdAt"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

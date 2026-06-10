enum Category { dairy, vegetables, meat, spices, beverages }

enum Unit { kg, gram, litre, ml, piece }

class InventoryModel {
  String itemId;
  String name;
  String? imageUrl;
  Category category;
  double quantity = 0.0;
  String unit;
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
}

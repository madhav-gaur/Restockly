import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { stockIn, stockOut }

class StockTransactionModel {
  String id;
  String itemId;
  String itemName;
  double oldQuantity;
  double newQuantity;
  TransactionType transactionType;
  String? note;
  DateTime createdAt;
  String createdBy;

  StockTransactionModel({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.oldQuantity,
    required this.newQuantity,
    required this.transactionType,
    this.note = "",
    required this.createdAt,
    required this.createdBy,
  });
  
  factory StockTransactionModel.fromMap(Map<String, dynamic> map) {
    final createdAt = map["createdAt"];

    return StockTransactionModel(
      id: map["transactionId"] ??  "",
      itemId: map["itemId"],
      itemName: map["itemName"] ?? "",
      oldQuantity: map["oldQuantity"] ?? 0,
      newQuantity: map["newQuantity"] ?? 0,
      transactionType: map["transactionType"] != null
          ? TransactionType.values.byName(map["transactionType"])
          : TransactionType.stockIn,
      note: map["note"] ?? "",
      createdBy: map["createdBy"] ?? "",
      createdAt: map["createdAt"] != null
          ? (map["createdAt"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

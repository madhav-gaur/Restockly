enum TransactionType { stockIn, stockOut }

class StockTransactionModel {
  String id;
  String itemId;
  double oldQuantity;
  double newQuantity;
  TransactionType transactionType;
  String? note;
  DateTime createdAt;
  String createdBy;

  StockTransactionModel({
    required this.id,
    required this.itemId,
    required this.oldQuantity,
    required this.newQuantity,
    required this.transactionType,
    this.note,
    required this.createdAt,
    required this.createdBy,
  });
}

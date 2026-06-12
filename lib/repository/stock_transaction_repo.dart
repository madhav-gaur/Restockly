import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/stock_transaction_model.dart';

class StockTransactionRepo {
  Future<List<StockTransactionModel>> getTransactions(
    String restaurantId,
  ) async {
    // await Future.delayed(const Duration(minutes: 30));

    final snapshot = await FirebaseFirestore.instance
        .collection(restaurantCol)
        .doc(restaurantId)
        .collection(transactionCol)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => StockTransactionModel.fromMap(doc.data()))
        .toList();
  }
}

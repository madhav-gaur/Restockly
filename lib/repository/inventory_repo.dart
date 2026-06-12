import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/inventory_model.dart';

class InventoryRepo {
  Future<List<InventoryModel?>> getAllItems(String restaurantId) async {
    log(restaurantId);
    final snapshot = await FirebaseFirestore.instance
        .collection(restaurantCol)
        .doc(restaurantId)
        .collection(inventoryCol)
        .get();
    return snapshot.docs
        .map((doc) => InventoryModel.fromMap(doc.data()))
        .toList();
  }

  Future<InventoryModel?> getInventoryItem(
    String restaurantId,
    String itemId,
  ) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(restaurantCol)
        .doc(restaurantId)
        .collection(inventoryCol)
        .doc(itemId)
        .get();
    final data = snapshot.data();
    return data == null ? null : InventoryModel.fromMap(data);
  }
}

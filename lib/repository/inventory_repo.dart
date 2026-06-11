import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restockly/models/inventory_model.dart';

class InventoryRepo {
  Future<List<InventoryModel?>> getAllItems(String restaurantId) async {
    log(restaurantId);
    final snapshot = await FirebaseFirestore.instance
        .collection("restaurants")
        .doc(restaurantId)
        .collection("inventory")
        .get();
    return snapshot.docs
        .map((doc) => InventoryModel.fromMap(doc.data()))
        .toList();
  }
}

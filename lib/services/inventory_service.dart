import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restockly/constants.dart';

class InventoryService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addToInventory({
    required String restaurantId,
    required String name,
    required String category,
    String? imageUrl = "",
    required String unit,
    required double quantity,
    required double minQuantity,
  }) async {
    if (restaurantId.trim().isEmpty) {
      throw ArgumentError('restaurantId is required');
    }

    final docRef = firestore
        .collection(restaurantCol)
        .doc(restaurantId.trim())
        .collection(inventoryCol)
        .doc();
    final item = await docRef.set({
      "itemId": docRef.id,
      "name": name,
      "category": category,
      "unit": unit,
      "imageUrl": imageUrl,
      "quantity": quantity,
      "minQuantity": minQuantity,
      "createdAt": Timestamp.now(),
      "isDeleted": false,
    });
    return item;
  }

  Future<void> updateItemQnt({
    required String restaurantId,
    required String itemId,
    required String itemName,
    required String userId,
    required double oldQnt,
    required double newQnt,
    String? note = "",
  }) async {
    final itemRef = firestore
        .collection(restaurantCol)
        .doc(restaurantId.trim())
        .collection(inventoryCol)
        .doc(itemId);

    final transactionRef = firestore
        .collection(restaurantCol)
        .doc(restaurantId.trim())
        .collection(transactionCol)
        .doc();

    final batch = firestore.batch();
    batch.update(itemRef, {"quantity": newQnt});
    batch.set(transactionRef, {
      "transactionId": transactionRef.id,
      "itemId": itemId,
      "itemName": itemName,
      "oldQuantity": oldQnt,
      "newQuantity": newQnt,
      "transactionType": newQnt > oldQnt ? "stockIn" : "stockOut",
      "note": note?.trim() ?? "",
      "createdBy": userId,
      "createdAt": FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<void> updateInventoryItem({
    required String restaurantId,
    required String itemId,
    required String name,
    required String category,
    required String unit,
    required double quantity,
    required double minQuantity,
    String? imageUrl = "",
  }) async {
    await firestore
        .collection(restaurantCol)
        .doc(restaurantId.trim())
        .collection(inventoryCol)
        .doc(itemId)
        .update({
          "name": name,
          "category": category,
          "unit": unit,
          "imageUrl": imageUrl,
          "quantity": quantity,
          "minQuantity": minQuantity,
        });
  }

  Future<void> deleteInventoryItem({
    required String restaurantId,
    required String itemId,
  }) async {
    await firestore
        .collection(restaurantCol)
        .doc(restaurantId.trim())
        .collection(inventoryCol)
        .doc(itemId)
        .update({"isDeleted": true});
  }
}

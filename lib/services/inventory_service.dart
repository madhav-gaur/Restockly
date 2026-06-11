import 'package:cloud_firestore/cloud_firestore.dart';

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
        .collection("restaurants")
        .doc(restaurantId.trim())
        .collection("inventory")
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
    required String userId,
    required double oldQnt,
    required double newQnt,
    String? note = "",
  }) async {
    final itemRef = firestore
        .collection("restaurants")
        .doc(restaurantId.trim())
        .collection("inventory")
        .doc(itemId);

    final transactionRef = firestore
        .collection("restaurants")
        .doc(restaurantId.trim())
        .collection("transactions")
        .doc();

    final batch = firestore.batch();
    batch.update(itemRef, {"quantity": newQnt});
    batch.set(transactionRef, {
      "transactionId": transactionRef.id,
      "itemId": itemId,
      "oldQuantity": oldQnt,
      "newQuantity": newQnt,
      "transactionType": newQnt > oldQnt ? "stockIn" : "stockOut",
      "note": note?.trim() ?? "",
      "createdBy": userId,
      "createdAt": FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }
}

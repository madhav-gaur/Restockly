import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/user_model.dart';

class UserRepo {
  final firestore = FirebaseFirestore.instance;
  Future<UserModel?> getCurrentUser(String uid) async {
    final doc = await firestore.collection(userCol).doc(uid).get();

    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }

  Future<UserModel?> getRestaurantMember({required String uid}) async {
    final collection = firestore.collection(userCol);
    final snapshot = await collection.doc(uid).get();

    if (!snapshot.exists) return null;
    return UserModel.fromJson(snapshot.data()!);
  }

  Future<List<UserModel?>> getAllRestaurantMembers({
    required String restaurantCode,
  }) async {
    final collection = firestore.collection(userCol);
    final snapshot = await collection
        .where('restaurantCode', isEqualTo: restaurantCode)
        .get();

    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restockly/models/user_model.dart';

class UserRepo {
  Future<UserModel?> getCurrentUser() async {
    final authUser = FirebaseAuth.instance.currentUser;

    if (authUser == null) return null;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(authUser.uid)
        .get();

    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }
}

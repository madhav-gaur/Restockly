import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/join_request_model.dart';

class JoinRequestRepo {
  Future<List<JoinRequestModel?>> getJoinRequests(String restaurantId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(joinRequestCol)
        .where('restaurantId', isEqualTo: restaurantId)
        // .orderBy('requestedAt', descending: true )
        .get();
    return snapshot.docs
        .map((doc) => JoinRequestModel.fromMap(doc.data()))
        .toList();
  }

  Future<JoinRequestModel?> getUserJoinRequests(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(joinRequestCol)
        .where('userId', isEqualTo: uid)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return JoinRequestModel.fromMap(snapshot.docs.first.data());
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/user_model.dart';

class JoinRequestService {
  Future<void> setJoinRequest({
    required UserApprovalStatus reqStatus,
    required String reqId,
    required String userId,
  }) async {
    await FirebaseFirestore.instance
        .collection(joinRequestCol)
        .doc(reqId)
        .update({"userApprovalStatus": reqStatus.name});

    await FirebaseFirestore.instance.collection(userCol).doc(userId).update({
      "userApprovalStatus": reqStatus.name,
    });
  }

  Future<void> deleteJoinRequest({
    required String reqId,
    required String userId,
  }) async {
    await FirebaseFirestore.instance
        .collection(joinRequestCol)
        .doc(reqId)
        .delete();

    await FirebaseFirestore.instance.collection(userCol).doc(userId).update({
      "userApprovalStatus": "pending",
      "restaurantId": "",
      "restaurantCode": "",
      "role": "",
    });
  }
}

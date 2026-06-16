import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restockly/models/user_model.dart';

class JoinRequestModel {
  String userId;
  String requestId;
  String restaurantId;
  String restaurantCode;
  UserApprovalStatus userApprovalStatus;
  DateTime requestedAt;

  JoinRequestModel({
    required this.userId,
    required this.requestId,
    required this.restaurantId,
    required this.restaurantCode,
    required this.userApprovalStatus,
    required this.requestedAt,
  });

  factory JoinRequestModel.fromMap(Map<String, dynamic> map) {
    return JoinRequestModel(
      userId: map["userId"] ?? "",
      requestId: map["requestId"] ?? "",
      restaurantId: map["restaurantId"] ?? "",
      restaurantCode: map["restaurantCode"] ?? "",
      userApprovalStatus: map["userApprovalStatus"] != null
          ? UserApprovalStatus.values.byName(map["userApprovalStatus"])
          : UserApprovalStatus.pending,
      requestedAt: map["requestedAt"] != null
          ? (map["requestedAt"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

import 'package:restockly/models/user_model.dart';

class JoinRequestModel {
  String userId;
  String restaurantId;
  String restaurantCode;
  UserApprovalStatus status;
  DateTime requestedAt;

  JoinRequestModel({
    required this.userId,
    required this.restaurantId,
    required this.restaurantCode,
    required this.status,
    required this.requestedAt,
  });
}

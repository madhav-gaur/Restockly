import 'package:restockly/models/user_model.dart';

class JoinRequestModel {
  String userId;
  String restaurantId;
  UserApprovalStatus status;
  DateTime requestedAt;

  JoinRequestModel({
    required this.userId,
    required this.restaurantId,
    required this.status,
    required this.requestedAt,
  });
}

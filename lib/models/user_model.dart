enum AccountProvider { phone, email, google }

enum Role { manager, staff }

enum UserApprovalStatus { approved, pending, rejected }

class UserModel {
  String uid;
  String name;
  String email;
  String? photoUrl;
  AccountProvider accountProvider;
  Role role;
  String restaurantName;
  String restaurantId;
  String restaurantCode;
  UserApprovalStatus userApprovalStatus = UserApprovalStatus.pending;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl = "",
    required this.accountProvider,
    required this.role,
    required this.restaurantName,
    required this.restaurantId,
    required this.restaurantCode,
    required this.userApprovalStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"],
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      photoUrl: json["photoUrl"] ?? "",
      accountProvider: json["accountProvider"] != null
          ? AccountProvider.values.byName(json["accountProvider"])
          : AccountProvider.email,
      role: json["role"] != null
          ? Role.values.byName(json["role"])
          : Role.staff,
      restaurantName: json["restaurantName"] ?? "",
      restaurantId: json["restaurantId"] ?? "",
      restaurantCode: json["restaurantCode"] ?? "",
      userApprovalStatus: json["userApprovalStatus"] != null
          ? UserApprovalStatus.values.byName(json["userApprovalStatus"])
          : UserApprovalStatus.pending,
    );
  }
}

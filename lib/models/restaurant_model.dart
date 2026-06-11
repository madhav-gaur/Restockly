class RestaurantModel {
  String restaurantName;
  String restaurantId;
  String restaurantCode;
  List<String> managersId;
  RestaurantModel({
    required this.restaurantName,
    required this.restaurantId,
    required this.restaurantCode,
    required this.managersId,
  });
}

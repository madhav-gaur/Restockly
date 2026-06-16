import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:restockly/widgets/const_widget.dart';

// Firestore Collections
const String restaurantCol = "restaurants";
const String userCol = "users";
const String inventoryCol = "inventory";
const String transactionCol = "transactions";
const String joinRequestCol = "joinRequests";

const String onboardingImage = "assets/images/onboarding_page.png";
const String googleLogo = "assets/images/google.png";
const String pendingBanner = "assets/images/pending_request_banner.png";
const String rejectedBanner = "assets/images/rejected_request_banner.png";



EdgeInsets defaultPagePadding({double vertical = 8, double horiz = 16}) {
  return EdgeInsets.symmetric(vertical: vertical, horizontal: horiz);
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 30
    ..indicatorWidget = SizedBox(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(strokeWidth: 1, color: Colors.grey.shade700),
    )
    ..radius = 7
    ..textStyle = mediumTextStyle()
    ..maskColor = Colors.black45
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false
    ..dismissOnTap = false;
}
// Widget d(){}

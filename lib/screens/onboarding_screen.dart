import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/routes/route_const.dart';
import 'package:restockly/widgets/const_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: defaultPagePadding(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: Image.asset(
                        onboardingImage,
                        height: 430,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // boldContainer(text: "Let's Get Started"),
                  Text(
                    "Welcome to Restockly",
                    style: boldTextStyle().copyWith(fontSize: 20),
                  ),
                  Text("Get Started to Manage your Stocks")
                ],
              ),
            ),
            Column(
              children: [
                elevatedButton(() {
                  context.pushNamed(RouteConst.signup);
                }, "Create Account"),
                SizedBox(height: 5,),
                outlinedButton(() {
                  // context.goNamed(name)
                }, Text("Sign In to an existing Account", style: boldTextStyle(),)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

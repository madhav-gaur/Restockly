import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restockly/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/routes/route_const.dart';
import 'package:restockly/services/auth_service.dart';
import 'package:restockly/widgets/const_widget.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SignupState();
}

class _SignupState extends State<Signin> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Role? selectedRole = Role.manager;
  final _formKey = GlobalKey<FormState>();

  void _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    log(email.toString());
    final user = await AuthService().signIn(email: email, password: password);
    if (user != null) {
      log("go to role selection");
      context.goNamed(RouteConst.mainScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        leading: IconButton(
          onPressed: () {
            context.goNamed(RouteConst.onboarding);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Padding(
        padding: defaultPagePadding(),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10),
              Container(
                child: textFormField(
                  controller: _emailController,
                  labelText: "Email",
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "*Required field";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: textFormField(
                  controller: _passwordController,
                  labelText: "Password",
                  isClearButton: false,
                  isObscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "*Required field";
                    }
                    if (value.length < 6) {
                      return "Password must be atleast 6 character long";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 30),
              elevatedButton(() {
                _handleSignIn();
              }, "Sign in"),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Or", style: mediumTextStyle()),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              outlinedButton(
                () async {
                  final user = await AuthService().signInWithGoogle();
                  log(user.toString());
                  if (user != null && context.mounted) {
                    final doc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get();
                    final hasRole = doc.exists && doc.data()?['role'] != null;
                    if (hasRole) {
                      context.goNamed(RouteConst.mainScreen);
                    } else {
                      context.goNamed(RouteConst.roleSelection);
                    }
                  }
                },
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Image.asset(googleLogo, width: 20),
                    SizedBox(width: 10),
                    Text("Sign in  with Google", style: boldTextStyle()),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(12),
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    context.goNamed(RouteConst.signup);
                  },
                  child: Text(
                    "New user? Create an Account",
                    textAlign: TextAlign.center,
                    style: smallTextStyle().copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

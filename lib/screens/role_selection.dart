import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/routes/route_const.dart';
import 'package:restockly/services/auth_service.dart';
import 'package:restockly/widgets/const_widget.dart';

class RoleSelection extends StatefulWidget {
  const RoleSelection({super.key});

  @override
  State<RoleSelection> createState() => _SignupState();
}

class _SignupState extends State<RoleSelection> {
  late TextEditingController _restNameController;
  late TextEditingController _restCodeController;

  @override
  void initState() {
    super.initState();
    _restNameController = TextEditingController();
    _restCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _restNameController.dispose();
    _restCodeController.dispose();
    super.dispose();
  }

  Role? selectedRole = Role.manager;
  final _formKey = GlobalKey<FormState>();
  Future<void> _addRole() async {
    if (!_formKey.currentState!.validate() || selectedRole == null) {
      return;
    }

    final isSaved = await AuthService().addRoleToFirestore(
        role: selectedRole!,
      restaurantCode: _restCodeController.text.trim(),
      restaurantName: _restNameController.text.trim(),
    );

    if (isSaved && mounted) {
      context.goNamed(RouteConst.mainScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select your Role"),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Padding(
        padding: defaultPagePadding(),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 12),
                child: Text(
                  "How will you use Restockly",
                  style: mediumTextStyle(),
                ),
              ),
              // SizedBox(height: 20),
              RadioGroup<Role>(
                groupValue: selectedRole,
                onChanged: (Role? value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                child: Column(
                  children: [
                    radioListTile<Role>(
                      value: Role.manager,
                      title: "Manager",
                      groupValue: selectedRole,
                    ),
                    // SizedBox(height: 20),
                    radioListTile<Role>(
                      value: Role.staff,
                      title: "Staff",
                      groupValue: selectedRole,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (selectedRole == Role.manager)
                Column(
                  children: [
                    Container(
                      child: textFormField(
                        controller: _restNameController,
                        labelText: "Restaurant Name",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "*Required field";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              if (selectedRole == Role.staff)
                Column(
                  children: [
                    Container(
                      child: textFormField(
                        controller: _restCodeController,
                        labelText: "Restaurant Code (Enter a 6 character code)",
                        validator: (value) {
                          final code = value?.trim() ?? "";
                          if (code.isEmpty) {
                            return "*Required field";
                          }
                          if (code.length != 6) {
                            return "Invalid code";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 30),
              elevatedButton(() {
                _addRole();
              }, "Continue to Home"),
            ],
          ),
        ),
      ),
    );
  }
}

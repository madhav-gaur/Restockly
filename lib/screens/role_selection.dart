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
  late TextEditingController _restIdController;

  @override
  void initState() {
    super.initState();
    _restNameController = TextEditingController();
    _restIdController = TextEditingController();
  }

  @override
  void dispose() {
    _restNameController.dispose();
    _restIdController.dispose();
    super.dispose();
  }

  Role? selectedRole = Role.manager;
  final _formKey = GlobalKey<FormState>();
  void _addRole() {
    if (selectedRole != null) {
      AuthService().addRoleToFirestore(
        role: selectedRole!,
        restaurantId: _restIdController.text,
        restaurantName: _restNameController.text,
      );
    }
    context.goNamed(RouteConst.mainScreen);
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
                        validadator: (value) {
                          if (value == null) {
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
                        controller: _restIdController,
                        labelText: "Restaurant Id (Enter a 6 character ID)",
                        validadator: (value) {
                          if (value == null) {
                            return "*Required field";
                          }
                          if (value.length != 6) {
                            return "Invalid Id";
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

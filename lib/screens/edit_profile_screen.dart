import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/services/auth_service.dart';
import 'package:restockly/themes/color_const.dart';
import 'package:restockly/utils/cloudinary.dart';
import 'package:restockly/widgets/const_widget.dart';

// class EditProfileScreen extends ConsumerStatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
// }

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isFormInitialized = false;
  String? profileUrl = "";

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    profileUrl = "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  // FIX 1: Properly initialize the image state along with text fields
  void _setInitialValues(UserModel item) {
    if (_isFormInitialized) return;

    _nameController.text = item.name;
    _emailController.text = item.email.toString();
    profileUrl = item.photoUrl ?? ""; // Fallback to empty string if null
    _isFormInitialized = true;
  }

  Future<void> _handleSave() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }
    await AuthService().updateProfile(
      name: _nameController.text,
      photoUrl: profileUrl,
    );

    ref.invalidate(currentUserProvider);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _handleUpload(UserModel user) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return;

    showDefaultLoading(status: "Uploading Image...");

    final url = await CloudinaryService().uploadImage(File(pickedFile.path));
    showSuccessMessage(status: "Image Uploaded");
    if (url != null) {
      log(url);
      setState(() {
        profileUrl = url;
      });
    }
    hideLoading();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: defaultPagePadding(),
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("Error: $err")),
          data: (currUser) {
            if (currUser == null)
              return const Center(child: Text("No user found"));

            _setInitialValues(currUser);
            final user = currUser;
            final hasImage = profileUrl != null && profileUrl!.isNotEmpty;

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      width: 120,
                      height: 120,
                      child: !hasImage
                          ? CircleAvatar(
                              backgroundColor: lightPrimary,
                              child: Text(
                                user.name.isNotEmpty
                                    ? user.name[0].toUpperCase()
                                    : "?",
                                style: boldTextStyle().copyWith(
                                  fontSize: 40,
                                  color: primary,
                                ),
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(profileUrl!),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: outlinedButton(
                          () {
                            _handleUpload(user);
                          },
                          Text(
                            !hasImage ? "Upload Image" : "Change Image",
                            style: mediumTextStyle(),
                          ),
                        ),
                      ),
                      if (hasImage) const SizedBox(width: 10),
                      if (hasImage)
                        Expanded(
                          child: outlinedButton(() {
                            setState(() {
                              profileUrl = "";
                            });
                          }, Text("Remove Image", style: mediumTextStyle())),
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    child: textFormField(
                      controller: _nameController,
                      labelText: "Full Name",
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
                      controller: _emailController,
                      labelText: "Email",
                      inputType: TextInputType.emailAddress,
                      readOnly: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  elevatedButton(() => _handleSave(), "Update"),
                  SizedBox(height: 16),
                  outlinedButton(() async {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: user.email,
                    );
                    showInfoMessage(
                      status: "Password Reset Link sent to ${user.email}",
                      d: const Duration(seconds: 3)
                    );
                  }, Text("Change Password", style: mediumTextStyle())),
                ],
              ),
            );
          },
          // error: (e, s) => Text("Error"),
          // loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/utils/generate_restaurant_id.dart';
import 'package:restockly/widgets/const_widget.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    showDefaultLoading(status: 'Signing up...');
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(user.toString());
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.user!.uid)
          .set({
            "uid": user.user!.uid,
            "name": name,
            "email": email,
            "accountProvider": "email",
            "photoUrl": "",
          });
      hideLoading();
      return user;
    } on FirebaseAuthException catch (e) {
      hideLoading();
      showErrorMessage(status: e.message ?? 'Sign up failed');
      log(e.toString());
    } catch (e) {
      hideLoading();
      showErrorMessage(status: 'Sign up failed');
      log(e.toString());
    }
    return null;
  }

  Future<void> addRoleToFirestore({
    required Role role,
    String? restaurantName,
    String? restaurantId,
  }) async {
    showDefaultLoading(status: 'Applying role...');
    try {
      final user = FirebaseAuth.instance.currentUser;
      final roleData = {"role": role.toString().split('.').last};

      if (restaurantName != null) roleData["restaurantName"] = restaurantName;
      if (restaurantId != null && restaurantId != "") {
        roleData["restaurantId"] = restaurantId;
        roleData["userApprovalStatus"] = "pending";

        await FirebaseFirestore.instance.collection("joinRequest").doc().set({
          "userId": user!.uid,
          "restaurantId": restaurantName,
          "userApprovalStatus": "pending",
          "requestedAt": DateTime.now(),
        });
      }

      if (restaurantId == null || restaurantId == "") {
        final restaurantId = generateRestaurantId();
        roleData["restaurantId"] = restaurantId;
        roleData["userApprovalStatus"] = "approved";

        await FirebaseFirestore.instance.collection("restaurants").doc().set({
          "restaurantId": restaurantId,
          "restaurantName": restaurantName,
          "managersId": [user!.uid],
        });
      }

      log(roleData.toString());
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update(roleData);
      hideLoading();
    } catch (e) {
      hideLoading();
      showErrorMessage(status: 'Unable to save role');
      log(e.toString());
    }
  }

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    showDefaultLoading(status: 'Signing in...');
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(user.toString());
      hideLoading();
      return user;
    } on FirebaseAuthException catch (e) {
      hideLoading();
      showErrorMessage(status: e.message ?? 'Sign in failed');
      log(e.toString());
    } catch (e) {
      hideLoading();
      showErrorMessage(status: 'Sign in failed');
      log(e.toString());
    }
    return null;
  }

  Future<User?> signInWithGoogle() async {
    showDefaultLoading(status: 'Signing in with Google...');
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        hideLoading();
        return null;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        hideLoading();
        showErrorMessage(status: 'Google sign in failed');
        return null;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!doc.exists) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .set({
              "uid": firebaseUser.uid,
              "name": firebaseUser.displayName,
              "email": firebaseUser.email,
              "accountProvider": "google",
              "photoUrl": firebaseUser.photoURL,
            });
      }
      hideLoading();
      return firebaseUser;
    } catch (e) {
      hideLoading();
      showErrorMessage(status: 'Google sign in failed');
      log(e.toString());
      return null;
    }
  }
}


// ?sign out
              // await FirebaseAuth.instance.signOut();
              // await GoogleSignIn().signOut();
              // if (context.mounted) {
              //   context.go(RouteConst.signup);
              // }
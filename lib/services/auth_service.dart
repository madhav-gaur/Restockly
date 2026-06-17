import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restockly/constants.dart';
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
          .collection(userCol)
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

  Future<bool> checkIsRestaurant(String restaurantCode) async {
    final snapshots = await FirebaseFirestore.instance
        .collection(restaurantCol)
        .where('restaurantCode', isEqualTo: restaurantCode).get();

      if(snapshots.docs.isEmpty) return false;
      return true;
  }

  Future<bool> addRoleToFirestore({
    required Role role,
    String? restaurantName,
    String? restaurantId,
    String? restaurantCode,
  }) async {
    showDefaultLoading(status: 'Setting up role...');
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showErrorMessage(status: 'User not found');
        return false;
      }

      final roleData = <String, dynamic>{
        "role": role.toString().split('.').last,
      };

      if (restaurantName != null) roleData["restaurantName"] = restaurantName;
      if (role == Role.staff) {
        final code = (restaurantCode ?? restaurantId ?? "")
            .trim()
            .toUpperCase();
        final restaurantSnapshot = await FirebaseFirestore.instance
            .collection(restaurantCol)
            .where("restaurantCode", isEqualTo: code)
            .limit(1)
            .get();

        if (restaurantSnapshot.docs.isEmpty) {
          hideLoading();
          showErrorMessage(status: 'Restaurant code not found');
          return false;
        }

        final restaurantDoc = restaurantSnapshot.docs.first;
        final restaurantData = restaurantDoc.data();

        roleData["restaurantId"] = restaurantDoc.id;
        roleData["restaurantCode"] = code;
        roleData["restaurantName"] = restaurantData["restaurantName"] ?? "";
        roleData["userApprovalStatus"] = "pending";

        final docRef = FirebaseFirestore.instance
            .collection(joinRequestCol)
            .doc();
        await docRef.set({
          "requestId": docRef.id,
          "userId": user.uid,
          "restaurantId": restaurantDoc.id,
          "restaurantCode": code,
          "userApprovalStatus": "pending",
          "requestedAt": DateTime.now(),
        });
      }

      if (role == Role.manager) {
        final code = generateRestaurantId();
        final docRef = FirebaseFirestore.instance
            .collection(restaurantCol)
            .doc();

        roleData["restaurantId"] = docRef.id;
        roleData["restaurantCode"] = code;
        roleData["userApprovalStatus"] = "approved";

        await docRef.set({
          "restaurantId": docRef.id,
          "restaurantCode": code,
          "restaurantName": restaurantName,
          "managersId": [user.uid],
        });
      }

      log(roleData.toString());
      await FirebaseFirestore.instance
          .collection(userCol)
          .doc(user.uid)
          .update(roleData);
      hideLoading();
      return true;
    } catch (e) {
      hideLoading();
      showErrorMessage(status: 'Unable to save role');
      log(e.toString());
      return false;
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
            .collection(userCol)
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

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}


// ?sign out
              // await FirebaseAuth.instance.signOut();
              // await GoogleSignIn().signOut();
              // if (context.mounted) {
              //   context.go(RouteConst.signup);
              // }

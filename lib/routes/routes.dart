import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/routes/route_const.dart';
import 'package:restockly/screens/add_inventory.dart';
import 'package:restockly/screens/inventory_item_details.dart';
import 'package:restockly/screens/join_request.dart';
import 'package:restockly/screens/main_screen.dart';
import 'package:restockly/screens/onboarding.dart';
import 'package:restockly/screens/pending_request_screen.dart';
import 'package:restockly/screens/rejected_request_screen.dart';
import 'package:restockly/screens/role_selection.dart';
import 'package:restockly/screens/signin.dart';
import 'package:restockly/screens/signup.dart';
import 'package:restockly/screens/stock_transaction_details.dart';

final GoRouter route = GoRouter(
  redirect: (context, state) async {
    final user = FirebaseAuth.instance.currentUser;
    final location = state.uri.path;

    final isSignup = location == RouteConst.signup;
    final isSignin = location == RouteConst.signin;
    final isOnboarding = location == RouteConst.onboarding;

    final isAuthRoute = isSignup || isSignin || isOnboarding;

    if (user == null) {
      if (!isAuthRoute) {
        return RouteConst.signup;
      }
      return null;
    } else {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final role = doc.data()?['role'];

      final hasRole = role != null && role.toString().trim().isNotEmpty;
      if (!hasRole) {
        return RouteConst.roleSelection;
      }
      log(role);
      log(doc.data()?['email']);

      if (role == 'staff') {
        final reqSnapshot = await FirebaseFirestore.instance
            .collection(joinRequestCol)
            .where('userId', isEqualTo: user.uid)
            .orderBy('requestedAt', descending: true)
            .limit(1)
            .get();
        log(reqSnapshot.docs.toString());
        if (reqSnapshot.docs.isNotEmpty) {
          final req = reqSnapshot.docs.first.data();
          final status = req['userApprovalStatus'];
          log(status);
          if (status == 'pending' && location != RouteConst.requestPending) {
            return RouteConst.requestPending;
          }

          if (status == 'rejected' && location != RouteConst.requestRejected) {
            return RouteConst.requestRejected;
          }
        }
      }

      return null;
    }
  },

  routes: [
    GoRoute(
      name: RouteConst.onboarding,
      path: '/auth/onboarding',
      builder: (context, state) => const Onboarding(),
    ),
    GoRoute(
      name: RouteConst.signup,
      path: '/auth/signup',
      builder: (context, state) => const Signup(),
    ),
    GoRoute(
      name: RouteConst.roleSelection,
      path: '/auth/role-selection',
      builder: (context, state) => const RoleSelection(),
    ),
    GoRoute(
      name: RouteConst.signin,
      path: '/auth/signin',
      builder: (context, state) => const Signin(),
    ),
    GoRoute(
      name: RouteConst.mainScreen,
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      name: RouteConst.addInventory,
      path: "/add-inventory",
      builder: (context, state) => const AddInventory(),
    ),

    GoRoute(
      name: RouteConst.itemDetails,
      path: "/item-details/:itemId",
      builder: (context, state) {
        final itemId = state.pathParameters["itemId"];
        return InventoryItemDetails(itemId: itemId!);
      },
    ),
    GoRoute(
      name: RouteConst.stockTransactionDetails,
      path: "/stock-transaction-details/:itemId",
      builder: (context, state) {
        final itemId = state.pathParameters["itemId"];
        return StockTransactionDetails(itemId: itemId!);
      },
    ),

    GoRoute(
      name: RouteConst.joinRequest,
      path: "/join-request",
      builder: (context, state) => const JoinRequest(),
    ),
    GoRoute(
      name: RouteConst.requestPending,
      path: "/request-pending",
      builder: (context, state) => const PendingRequestScreen(),
    ),
    GoRoute(
      name: RouteConst.requestRejected,
      path: "/request-rejected",
      builder: (context, state) => const RejectedRequestScreen(),
    ),
  ],
);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/providers/join_request_provider.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/routes/route_const.dart';
import 'package:restockly/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:restockly/themes/color_const.dart';

import 'package:restockly/widgets/const_widget.dart';

class RejectedRequestScreen extends ConsumerWidget {
  const RejectedRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reqAsync = ref.watch(userJoinRequestProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Join Request Status")),
      body: Padding(
        padding: defaultPagePadding(),
        child: reqAsync.when(
          data: (currReq) {
            if (currReq == null) {
              return Center(child: Text("Something went Wrong"));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(rejectedBanner, height: 250, fit: BoxFit.cover),
                Text(
                  "Request Rejected",
                  style: boldTextStyle().copyWith(fontSize: 28),
                ),
                SizedBox(height: 15),
                Text(
                  "Your Request to join was rejected by Manager",
                  textAlign: .center,
                  style: mediumTextStyle().copyWith(color: textSecondary),
                ),
                SizedBox(height: 5),
                Text(
                  "Requested ${DateFormat("d MMM, h:mm a").format(currReq.requestedAt)}",
                  style: mediumTextStyle().copyWith(color: textTertiary),
                ),
                SizedBox(height: 30),
                elevatedButton(() {
                  context.goNamed(RouteConst.roleSelection);
                }, "Send another Request"),
                SizedBox(height: 8),
                elevatedButton(() async {
                  await AuthService().signOut();
                  ref.invalidate(currentUserProvider);
                  if (context.mounted) {
                    context.goNamed(RouteConst.signin);
                  }
                }, "Sign Out"),
              ],
            );
          },
          error: (e, s) => Text(e.toString()),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/providers/join_request_provider.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/routes/route_const.dart';
import 'package:restockly/services/auth_service.dart';
import 'package:restockly/services/join_request_service.dart';
import 'package:intl/intl.dart';
import 'package:restockly/themes/color_const.dart';

import 'package:restockly/widgets/const_widget.dart';

class PendingRequestScreen extends ConsumerWidget {
  const PendingRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reqAsync = ref.watch(userJoinRequestProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Join Request Status")),
      body: Padding(
        padding: defaultPagePadding(),
        child: reqAsync.when(
          data: (currReq) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(pendingBanner, height: 250, fit: BoxFit.cover),
                Text(
                  "Pending Approval",
                  style: boldTextStyle().copyWith(fontSize: 28),
                ),
                SizedBox(height: 15),
                Text(
                  "Your Request is awaiting approval",
                  style: mediumTextStyle().copyWith(color: textSecondary),
                ),
                SizedBox(height: 5),
                Text(
                  "Requested ${DateFormat("d MMM, h:mm a").format(currReq!.requestedAt)}",
                  style: mediumTextStyle().copyWith(color: textTertiary),
                ),
                SizedBox(height: 30),
                elevatedButton(() {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return alertDialog(
                        title: "Cancel Request",
                        description:
                            "You need to re-enter code to request again",
                        cancel: () => context.pop(),
                        confirm: () async {
                          await JoinRequestService().deleteJoinRequest(
                            reqId: currReq.requestId,
                            userId: currReq.userId,
                          );
                          ref.invalidate(joinRequestProvider);
                          showInfoMessage(status: "Request Cancelled");
                          if (context.mounted) {
                            context.goNamed(RouteConst.roleSelection);
                          }
                        },
                      );
                    },
                  );
                }, "Cancel Request"),
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

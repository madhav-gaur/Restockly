import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restockly/models/join_request_model.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/providers/join_request_provider.dart';
import 'package:restockly/services/join_request_service.dart';
import 'package:restockly/themes/color_const.dart';
import 'package:restockly/utils/capitilize.dart';
import 'package:restockly/widgets/const_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget bottomSheet(
  UserModel currReqUser,
  JoinRequestModel currReq,
  BuildContext context,
  WidgetRef ref,
) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: lightPrimary,
          child: Text(
            currReqUser.name[0].toUpperCase(),
            style: boldTextStyle().copyWith(fontSize: 28, color: primary),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          currReqUser.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),

        Text(currReqUser.email, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _detailTile(
                Icons.badge_outlined,
                "Role",
                capitalize(currReqUser.role.name),
              ),
              _detailTile(
                Icons.store_outlined,
                "Restaurant Code",
                currReq.restaurantCode,
              ),

              _detailTile(
                Icons.schedule_outlined,
                "Requested",
                timeago.format(currReq.requestedAt),
              ),

              _detailTile(
                Icons.verified_user_outlined,
                "Status",
                capitalize(currReq.userApprovalStatus.name),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            if (currReq.userApprovalStatus == UserApprovalStatus.pending ||
                currReq.userApprovalStatus == UserApprovalStatus.approved)
              Expanded(
                child: outlinedButton(() async {
                  await JoinRequestService().setJoinRequest(
                    reqStatus: UserApprovalStatus.rejected,
                    userId: currReqUser.uid,
                    reqId: currReq.requestId,
                  );
                  ref.invalidate(joinRequestProvider);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }, Text("Reject", style: mediumTextStyle())),
              ),

            const SizedBox(width: 12),

            if (currReq.userApprovalStatus == UserApprovalStatus.pending ||
                currReq.userApprovalStatus == UserApprovalStatus.rejected)
              Expanded(
                child: elevatedButton(() async {
                  await JoinRequestService().setJoinRequest(
                    reqStatus: UserApprovalStatus.approved,
                    userId: currReqUser.uid,
                    reqId: currReq.requestId,
                  );
                  showSuccessMessage(status: "Request Approved");
                  ref.invalidate(joinRequestProvider);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }, "Approve"),
              ),
          ],
        ),

        const SizedBox(height: 12),
      ],
    ),
  );
}

Widget _detailTile(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Spacer(),
        Text(value),
      ],
    ),
  );
}

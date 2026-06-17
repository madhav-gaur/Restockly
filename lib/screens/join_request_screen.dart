import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restockly/components/user_request_bottom_sheet.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/providers/join_request_provider.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/services/join_request_service.dart';
import 'package:restockly/themes/color_const.dart';
import 'package:restockly/widgets/const_widget.dart';
import 'package:restockly/widgets/skeletons.dart';
import 'package:timeago/timeago.dart' as timeago;

class JoinRequestScreen extends ConsumerStatefulWidget {
  const JoinRequestScreen({super.key});

  @override
  ConsumerState<JoinRequestScreen> createState() => _JoinRequestState();
}

class _JoinRequestState extends ConsumerState<JoinRequestScreen> {
  @override
  Widget build(BuildContext context) {
    final joinRequest = ref.watch(joinRequestProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Join Requests")),
      body: joinRequest.when(
        data: (requests) {
          return ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final currReq = requests[index]!;
              final currReqUserAsync = ref.watch(
                anyUserProvider(currReq.userId),
              );
              return currReqUserAsync.when(
                data: (currReqUser) {
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    title: Text(
                      "${currReqUser!.name} requsted to join",
                      style: mediumTextStyle().copyWith(fontSize: 16),
                    ),
                    subtitle: Text(timeago.format(currReq.requestedAt)),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        showDragHandle: true,
                        backgroundColor: surface,
                        isScrollControlled: true,
                        builder: (context) {
                          return bottomSheet(
                            currReqUser,
                            currReq,
                            context,
                            ref,
                          );
                        },
                      );
                    },
                    trailing:
                        currReq.userApprovalStatus == UserApprovalStatus.pending
                        ? SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 70,
                                  height: 32,
                                  child: FilledButton(
                                    style: ButtonStyle(
                                      padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(horizontal: 0),
                                      ),
                                      backgroundColor: WidgetStatePropertyAll(
                                        primary,
                                      ),
                                    ),
                                    onPressed: () async {
                                      await JoinRequestService().setJoinRequest(
                                        reqStatus: UserApprovalStatus.approved,
                                        reqId: currReq.requestId,
                                        userId: currReqUser.uid,
                                      );
                                      ref.invalidate(joinRequestProvider);
                                    },
                                    child: Text(
                                      "Accept",
                                      style: boldTextStyle().copyWith(
                                        color: whiteText,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),

                                // const SizedBox(width: 4),
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return alertDialog(
                                          title: "Reject Request",
                                          description:
                                              "Do You wantt to reject this Request?",
                                          confirmText: "Reject",
                                          cancel: context.pop,
                                          confirm: () async {
                                            await JoinRequestService()
                                                .setJoinRequest(
                                                  reqStatus: UserApprovalStatus
                                                      .rejected,
                                        userId: currReqUser.uid,
                                                  reqId: currReq.requestId,
                                                );
                                            ref.invalidate(joinRequestProvider);
                                            context.pop();
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.clear, size: 18),
                                ),
                              ],
                            ),
                          )
                        : (currReq.userApprovalStatus ==
                                  UserApprovalStatus.approved
                              ? SizedBox(
                                  width: 110,
                                  height: 32,
                                  child: FilledButton(
                                    style: ButtonStyle(
                                      padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(horizontal: 0),
                                      ),
                                      backgroundColor: WidgetStatePropertyAll(
                                        primary,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "Accepted",
                                      style: boldTextStyle().copyWith(
                                        color: whiteText,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 110,
                                  height: 32,
                                  child: outlinedButton(
                                    () {},
                                    Text(
                                      "Rejected",
                                      style: mediumTextStyle().copyWith(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                )),
                  );
                },
                error: (e, s) => Text(e.toString()),
                loading: () => requestTileSkeleton(),
              );
            },
          );
        },
        error: (e, s) => Text(e.toString()),
        loading: () => Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
            itemCount: 5,
            itemBuilder: (context, index) => requestTileSkeleton(),
          ),
        ),
      ),
    );
  }
}

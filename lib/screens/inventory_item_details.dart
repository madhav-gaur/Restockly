import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/stock_transaction_model.dart';
import 'package:restockly/providers/inventory_provider.dart';
import 'package:restockly/providers/stock_transaction_provider.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/routes/route_const.dart';
import 'package:restockly/themes/color_const.dart';
import 'package:restockly/widgets/const_widget.dart';
import 'package:restockly/widgets/skeletons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InventoryItemDetails extends ConsumerStatefulWidget {
  final String itemId;
  const InventoryItemDetails({super.key, required this.itemId});

  @override
  ConsumerState<InventoryItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends ConsumerState<InventoryItemDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final itemId = widget.itemId;
    final itemAsync = ref.watch(inventoryItemProvider(itemId));
    final transactionAsync = ref.watch(stockTransactionProvider);

    return itemAsync.when(
      data: (itemData) {
        if (itemData == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Item not found')),
            body: Center(child: Text('Item not found')),
          );
        }
        final item = itemData;
        return Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton(
                position: PopupMenuPosition.under,
                tooltip: "More Options",
                color: whiteText,
                elevation: 2,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(child: Text("Edit")),
                    PopupMenuItem(child: Text("Delete")),
                  ];
                },
              ),
              // SizedBox(width: 10,)
            ],
            title: Row(
              mainAxisAlignment: .start,
              children: [
                Text(item.name),
                SizedBox(width: 5),
                Text("(${item.category.name})", style: smallTextStyle()),
              ],
            ),
          ),
          body: Padding(
            padding: defaultPagePadding(),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Column(
                    children: [
                      row(
                        "Current Stock: ",
                        "${item.quantity} ${item.unit.name}",
                      ),
                      Divider(),
                      row(
                        "Minimum Stock: ",
                        "${item.minQuantity} ${item.unit.name}",
                      ),
                      Divider(),
                      row(
                        "Last updated: ",
                        "${item.quantity} ${item.unit.name}",
                      ),
                      Divider(),
                      row(
                        "Stock Status: ",
                        item.quantity > item.minQuantity
                            ? "In Stock"
                            : "Low Stock",
                      ),
                      Divider(),
                      row("Category: ", item.category.name),
                      Divider(),
                      row("Unit: ", item.unit.name),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text("Recent transactions"),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: transactionAsync.when(
                    data: (transactionData) {
                      final itemLogs = transactionData
                          .where(
                            (log) => log != null && log.itemId == item.itemId,
                          )
                          .toList();

                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade300,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: itemLogs.length > 5 ? 6 : itemLogs.length,
                        itemBuilder: (context, index) {
                          if (itemLogs.length > 5 && index == 5) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: outlinedButton(
                                () {
                                  context.pushNamed(
                                    RouteConst.stockTransactionDetails,
                                    pathParameters: {"itemId": item.itemId},
                                  );
                                },
                                Text(
                                  "See All Transactions",
                                  style: mediumTextStyle(),
                                ),
                              ),
                            );
                          }
                          final currLog = itemLogs[index]!;
                          final restaurentMember = ref.watch(
                            anyUserProvider(currLog.createdBy),
                          );
                          final transactionType =
                              currLog.transactionType == TransactionType.stockIn
                              ? "IN"
                              : "OUT";
                          final unit = item.unit.name;
                          return restaurentMember.when(
                            data: (membersData) {
                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                tileColor: background,
                                leading: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: transactionType == "IN"
                                      ? green
                                      : danger,
                                  child: Icon(
                                    transactionType == "IN"
                                        ? Icons.add
                                        : Icons.remove,
                                    color: whiteText,
                                    size: 25,
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${transactionType == "IN" ? "Added" : "Used"} ${(currLog.newQuantity - currLog.oldQuantity).abs()} $unit ${currLog.itemName}",
                                        style: mediumTextStyle(),
                                      ),
                                    ),
                                    Text(
                                      "${currLog.oldQuantity} $unit -> ${currLog.newQuantity} $unit",
                                      style: smallTextStyle().copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: transactionType == "IN"
                                            ? green
                                            : danger,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: SizedBox(
                                  width: 50,
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      if (currLog.note != "")
                                        Text(
                                          "Note: ${currLog.note}",
                                          style: mediumTextStyle().copyWith(
                                            color: textSecondary,
                                          ),
                                        ),
                                      Text(
                                        "By ${membersData!.name} on ${DateFormat("d MMM, h:mm a").format(currLog.createdAt)}",
                                        style: smallTextStyle().copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // trailing:
                              );
                            },
                            error: (e, s) => Text(e.toString()),
                            loading: transactionSkeletonTile,
                          );
                        },
                      );
                    },
                    error: (e, s) => Text(e.toString()),
                    loading: () => Skeletonizer(
                      containersColor: Colors.grey.shade300,
                      enabled: true,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade300,
                        ),
                        itemBuilder: (context, index) =>
                            transactionSkeletonTile(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (e, s) => Text(e.toString()),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

Widget row(String left, String right) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left, style: mediumTextStyle()),
        Text(right, style: mediumTextStyle().copyWith(fontSize: 15)),
      ],
    ),
  );
}

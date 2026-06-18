import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restockly/components/transaction_list_tile.dart';
import 'package:restockly/models/stock_transaction_model.dart';
import 'package:restockly/providers/inventory_provider.dart';
import 'package:restockly/providers/stock_transaction_provider.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/widgets/const_widget.dart';
import 'package:restockly/widgets/skeletons.dart';

class StockTransactionDetails extends ConsumerStatefulWidget {
  final String itemId;
  const StockTransactionDetails({super.key, required this.itemId});

  @override
  ConsumerState<StockTransactionDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends ConsumerState<StockTransactionDetails> {
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
          appBar: AppBar(title: Text("Transactions")),
          body: ListView(
            children: [
              transactionAsync.when(
                data: (transactionData) {
                  final itemLogs = transactionData
                      .where((log) => log != null && log.itemId == item.itemId)
                      .toList();
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: itemLogs.length,
                    itemBuilder: (context, index) {
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
                          return transactionListTile(
                            transactionType: transactionType,
                            currLog: currLog,
                            unit: unit,
                            membersData: membersData!,
                          );
                        },
                        error: (e, s) => Text(e.toString()),
                        loading: transactionSkeletonTile,
                      );
                    },
                  );
                },
                error: (e, s) => Text(e.toString()),
                loading: () => ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey.shade300,
                  ),
                  itemBuilder: (context, index) => transactionSkeletonTile(),
                ),
              ),
            ],
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

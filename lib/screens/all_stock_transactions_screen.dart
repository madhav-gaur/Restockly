import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restockly/components/transaction_list_tile.dart';
import 'package:restockly/models/stock_transaction_model.dart';
import 'package:restockly/providers/inventory_provider.dart';
import 'package:restockly/providers/stock_transaction_provider.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/widgets/const_widget.dart';
import 'package:restockly/widgets/skeletons.dart';

class AllStockTransactionsScreen extends ConsumerStatefulWidget {
  const AllStockTransactionsScreen({super.key});

  @override
  ConsumerState<AllStockTransactionsScreen> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends ConsumerState<AllStockTransactionsScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onQueryChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final transactionAsync = ref.watch(stockTransactionProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Transactions")),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchBar(
              controller: _searchController,
              elevation: WidgetStatePropertyAll(0),
              constraints: BoxConstraints.expand(height: 40),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              ),
              backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
              leading: Icon(Icons.search_rounded),
              hintText: "Search Items",
              onChanged: (_) => setState(() {}),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                    icon: Icon(Icons.close),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16),

          transactionAsync.when(
            data: (transactionData) {
              final query = _searchController.text.trim().toLowerCase();
              final filteredItems = transactionData.where((item) {
                if (item == null) return false;
                if (query.isEmpty) return true;

                return item.itemName.toLowerCase().contains(query) ||
                    item.createdAt.toString().toLowerCase().contains(query) ||
                    item.transactionType.name.toLowerCase().contains(query);
              }).toList();

              final itemLogs = filteredItems;
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
                  return restaurentMember.when(
                    data: (membersData) {
                      final currInventoryItem = ref.watch(
                        inventoryItemProvider(currLog.itemId),
                      );
                      return currInventoryItem.when(
                        data: (inventoryItem) {
                          return transactionListTile(
                            transactionType: transactionType,
                            currLog: currLog,
                            unit: inventoryItem!.unit.name,
                            membersData: membersData!,
                          );
                        },
                        error: (e, s) => Text(e.toString()),
                        loading: transactionSkeletonTile,
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
              separatorBuilder: (context, index) =>
                  Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
              itemBuilder: (context, index) => transactionSkeletonTile(),
            ),
          ),
        ],
      ),
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

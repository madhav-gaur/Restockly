import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restockly/components/transaction_list_tile.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/stock_transaction_model.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/providers/inventory_provider.dart';
import 'package:restockly/providers/stock_transaction_provider.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/routes/route_const.dart';
import 'package:restockly/services/auth_service.dart';
import 'package:restockly/themes/color_const.dart';
import 'package:restockly/widgets/const_widget.dart';
import 'package:restockly/widgets/skeletons.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final inventoryAsync = ref.watch(inventoryProvider);
    final memberAsync = ref.watch(allRestaurantMembersProvider);
    final transactionAsync = ref.watch(stockTransactionProvider);
    return Scaffold(
      appBar: user.when(
        data: (user) {
          return AppBar(
            centerTitle: false,
            title: Text(
              "Welcome, ${user?.name}",
              style: boldTextStyle().copyWith(fontSize: 23),
            ),
            actions: [
              if (user?.role == Role.manager)
                IconButton(
                  onPressed: () => context.pushNamed(RouteConst.joinRequest),
                  icon: Icon(Icons.group_add_outlined),
                ),
            ],
          );
        },
        error: (e, s) => AppBar(),
        loading: () => AppBar(),
      ),
      // ),
      body: Padding(
        padding: defaultPagePadding(),
        child: inventoryAsync.when(
          data: (inventory) {
            final totalItems = inventory.length;
            final lowStock = inventory
                .where((item) => item!.quantity < item.minQuantity)
                .length;
            final outOfStock = inventory
                .where((item) => item!.quantity == 0)
                .length;
            return ListView(
              children: [
                // Text(user!.restaurantName, style: smallTextStyle()),
                Row(
                  children: [
                    homeCard(
                      "Total Items",
                      "$totalItems",
                      Icons.list_sharp,
                      primary.withAlpha(40),
                      primary,
                    ),

                    SizedBox(width: 10),
                    homeCard(
                      "Low Stock",
                      "$lowStock",
                      Icons.warning_amber_outlined,
                      warning.withAlpha(25),
                      warning,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    memberAsync.when(
                      data: (members) {
                        return homeCard(
                          "Total Members",
                          "${members.length}",
                          Icons.group_outlined,
                          green.withAlpha(25),
                          green,
                        );
                      },
                      error: (e, s) => Text(""),
                      loading: () => Text(""),
                    ),
                    SizedBox(width: 10),
                    homeCard(
                      "Out of Stock",
                      "$outOfStock",
                      Icons.production_quantity_limits,
                      danger.withAlpha(25),
                      danger,
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Text(
                  "Quick Actions",
                  style: mediumTextStyle().copyWith(fontSize: 18),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    quickActionBtn(() {}, "Add Item", Icons.add_box_outlined),
                    const SizedBox(width: 10),
                    quickActionBtn(() {}, "Manage Team", Icons.groups_outlined),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    quickActionBtn(() {}, "View Activity", Icons.history),
                    const SizedBox(width: 10),
                    quickActionBtn(
                      () {},
                      "Join Requests",
                      Icons.person_add_alt_1_outlined,
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Text(
                  "Recent Activity",
                  style: mediumTextStyle().copyWith(fontSize: 18),
                ),
                SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: transactionAsync.when(
                    data: (trans) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade300,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trans.length > 5 ? 6 : trans.length,
                        itemBuilder: (context, index) {
                          final currLog = trans[index]!;
                          if (trans.length > 1 && index == 5) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: outlinedButton(
                                () {
                                  // context.pushNamed(
                                  //   RouteConst.stockTransactionDetails,
                                  //   pathParameters: {"itemId": item.itemId},
                                  // );
                                },
                                Text(
                                  "See All Transactions",
                                  style: mediumTextStyle(),
                                ),
                              ),
                            );
                          }
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
                    loading: () => CircularProgressIndicator(),
                  ),
                ),

                SizedBox(height: 50),

                elevatedButton(() async {
                  await AuthService().signOut();
                  ref.invalidate(currentUserProvider);

                  if (context.mounted) {
                    context.go(RouteConst.signup);
                  }
                }, "Sign oute"),
              ],
            );
          },
          error: (e, s) => Text(e.toString()),
          loading: () => CircularProgressIndicator(),
        ),
      ),
    );
  }
}

Widget quickActionBtn(VoidCallback onTap, String title, IconData icon) {
  return Expanded(
    child: Material(
      color: background.withAlpha(150),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        splashColor: Colors.grey.shade200,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primary, size: 22),
              ),

              const SizedBox(height: 10),

              Text(
                title,
                textAlign: TextAlign.center,
                style: mediumTextStyle().copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget homeCard(
  String text,
  String data,
  IconData icon,
  Color iconbg,
  Color iconColor,
) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: smallTextStyle().copyWith(fontSize: 13)),
              Text(data, style: boldTextStyle().copyWith(fontSize: 26)),
            ],
          ),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: iconbg,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
        ],
      ),
    ),
  );
}

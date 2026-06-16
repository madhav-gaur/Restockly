import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/providers/inventory_provider.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/routes/route_const.dart';
import 'package:restockly/services/inventory_service.dart';
import 'package:restockly/themes/color_const.dart';
import 'package:restockly/widgets/const_widget.dart';
import 'package:restockly/widgets/skeletons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Inventory extends ConsumerStatefulWidget {
  const Inventory({super.key});

  @override
  ConsumerState<Inventory> createState() => _InventoryState();
}

class _InventoryState extends ConsumerState<Inventory> {
  String? _selectedNoteItemId;
  final Map<String, double> _quantities = {};
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, TextEditingController> _noteControllers = {};

  TextEditingController _quantityControllerFor(String itemId, double quantity) {
    return _quantityControllers.putIfAbsent(
      itemId,
      () => TextEditingController(text: quantity.toString()),
    );
  }

  TextEditingController _noteControllerFor(String itemId) {
    return _noteControllers.putIfAbsent(itemId, () => TextEditingController());
  }

  late TextEditingController _searchController;

  void _setQuantity(String itemId, double quantity) {
    final safeQuantity = quantity < 0 ? 0.0 : quantity;
    _quantities[itemId] = safeQuantity;

    final controller = _quantityControllers[itemId];
    if (controller != null) {
      final text = safeQuantity.toString();
      controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  void _clearEditedItem(String itemId) {
    _selectedNoteItemId = null;
    _quantities.remove(itemId);
    _quantityControllers.remove(itemId)?.dispose();
    _noteControllerFor(itemId).clear();
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onQueryChanged);
    for (final controller in _quantityControllers.values) {
      controller.dispose();
    }
    for (final controller in _noteControllers.values) {
      controller.dispose();
    }
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(inventoryProvider);
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Inventory")),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          backgroundColor: green,
          splashColor: greenSecondary,
          hoverElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          foregroundColor: whiteText,
          onPressed: () {
            context.pushNamed(RouteConst.addInventory);
          },
          elevation: 0,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: .endFloat,
      body: Padding(
        padding: defaultPagePadding(),
        child: Column(
          children: [
            SearchBar(
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
            SizedBox(height: 16),
            items.when(
              data: (items) {
                final query = _searchController.text.trim().toLowerCase();
                final filteredItems = items.where((item) {
                  if (item == null) return false;
                  if (query.isEmpty) return true;

                  return item.name.toLowerCase().contains(query) ||
                      item.category.name.toLowerCase().contains(query) ||
                      item.unit.name.toLowerCase().contains(query);
                }).toList();

                if (filteredItems.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        query.isEmpty ? "No inventory items" : "No items found",
                        style: mediumTextStyle().copyWith(
                          color: textSecondary,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: RefreshIndicator(
                    backgroundColor: surface,
                    color: primary,
                    onRefresh: () async {
                      log("message");
                      await ref.refresh(inventoryProvider.future);
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 100),
                      itemCount: filteredItems.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final currItem = filteredItems[index]!;
                        final unit = currItem.unit.name;
                        final quantity =
                            _quantities[currItem.itemId] ?? currItem.quantity;
                        final quantityController = _quantityControllerFor(
                          currItem.itemId,
                          quantity,
                        );
                        final isLowStock =
                            currItem.quantity < currItem.minQuantity;
                        if (filteredItems.isNotEmpty) {
                          return user.when(
                            data: (user) {
                              return Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 7),
                                    child: Material(
                                      color: background,
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: BorderRadius.circular(13),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(13),
                                        splashColor: Colors.grey.shade300,
                                        onTap: () => context.pushNamed(
                                          RouteConst.itemDetails,
                                          pathParameters: {
                                            "itemId": currItem.itemId,
                                          },
                                        ),
                                        child: Ink(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              13,
                                            ),
                                            border: Border.all(
                                              color: isLowStock
                                                  ? danger
                                                  : Colors.grey.shade400,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (isLowStock)
                                                    SizedBox(height: 25),
                                                  Row(
                                                    children: [
                                                      if (isLowStock)
                                                        Icon(
                                                          Icons
                                                              .warning_amber_outlined,
                                                          color: warning,
                                                        ),
                                                      if (isLowStock)
                                                        SizedBox(width: 8),
                                                      Text(
                                                        currItem.name,
                                                        style: boldTextStyle()
                                                            .copyWith(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "Quantity: ${currItem.quantity} ${currItem.unit.name}",
                                                    style: smallTextStyle()
                                                        .copyWith(
                                                          color: isLowStock
                                                              ? danger
                                                              : textSecondary,
                                                          fontSize: 15,
                                                          fontWeight: isLowStock
                                                              ? FontWeight.w600
                                                              : FontWeight.w400,
                                                        ),
                                                  ),
                                                  Text(
                                                    "Min Quantity: ${currItem.minQuantity} $unit ",
                                                    style: smallTextStyle()
                                                        .copyWith(
                                                          color: textSecondary,
                                                          fontSize: 15,
                                                        ),
                                                  ),
                                                  SizedBox(height: 16),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            100,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Material(
                                                          color: primary,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          borderRadius:
                                                              BorderRadius.horizontal(
                                                                left:
                                                                    Radius.circular(
                                                                      100,
                                                                    ),
                                                              ),
                                                          child: InkWell(
                                                            splashColor: accent,
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedNoteItemId =
                                                                    currItem
                                                                        .itemId;
                                                                _setQuantity(
                                                                  currItem
                                                                      .itemId,
                                                                  quantity - 1,
                                                                );
                                                                log(
                                                                  _quantities[currItem
                                                                          .itemId]
                                                                      .toString(),
                                                                );
                                                              });
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical: 3,
                                                                  ),
                                                              child: Text(
                                                                "-",
                                                                style: mediumTextStyle()
                                                                    .copyWith(
                                                                      color:
                                                                          whiteText,
                                                                      fontSize:
                                                                          25,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 7,
                                                              ),
                                                          child: SizedBox(
                                                            width: 40,
                                                            child: TextField(
                                                              controller:
                                                                  quantityController,
                                                              keyboardType:
                                                                  const TextInputType.numberWithOptions(
                                                                    decimal:
                                                                        true,
                                                                  ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: boldTextStyle()
                                                                  .copyWith(
                                                                    color:
                                                                        whiteText,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                              cursorColor:
                                                                  whiteText,
                                                              decoration: const InputDecoration(
                                                                isDense: true,
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                      vertical:
                                                                          6,
                                                                    ),
                                                              ),
                                                              onTap: () {
                                                                setState(() {
                                                                  _selectedNoteItemId =
                                                                      currItem
                                                                          .itemId;
                                                                });
                                                              },
                                                              onChanged: (value) {
                                                                final parsed =
                                                                    double.tryParse(
                                                                      value,
                                                                    );
                                                                if (parsed ==
                                                                    null) {
                                                                  return;
                                                                }

                                                                setState(() {
                                                                  _selectedNoteItemId =
                                                                      currItem
                                                                          .itemId;
                                                                  _quantities[currItem
                                                                          .itemId] =
                                                                      parsed < 0
                                                                      ? 0
                                                                      : parsed;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Material(
                                                          color: primary,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          borderRadius:
                                                              BorderRadius.horizontal(
                                                                right:
                                                                    Radius.circular(
                                                                      100,
                                                                    ),
                                                              ),
                                                          child: InkWell(
                                                            splashColor: accent,
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedNoteItemId =
                                                                    currItem
                                                                        .itemId;
                                                                _setQuantity(
                                                                  currItem
                                                                      .itemId,
                                                                  quantity + 1,
                                                                );
                                                              });
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical: 3,
                                                                  ),
                                                              child: Text(
                                                                "+",
                                                                style: mediumTextStyle()
                                                                    .copyWith(
                                                                      color:
                                                                          whiteText,
                                                                      fontSize:
                                                                          25,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (currItem.itemId ==
                                                      _selectedNoteItemId)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 10,
                                                          ),
                                                      child: SizedBox(
                                                        width: 280,
                                                        child: textFormField(
                                                          controller:
                                                              _noteControllerFor(
                                                                currItem.itemId,
                                                              ),
                                                          labelText:
                                                              "Note (Optional)",
                                                        ),
                                                      ),
                                                    ),
                                                  if (currItem.itemId ==
                                                      _selectedNoteItemId)
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: 120,
                                                          child: Container(
                                                            child: outlinedButton(
                                                              () {
                                                                setState(() {
                                                                  _clearEditedItem(
                                                                    currItem
                                                                        .itemId,
                                                                  );
                                                                });
                                                              },
                                                              Text(
                                                                "Cancel",
                                                                style:
                                                                    mediumTextStyle(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 20),
                                                        SizedBox(
                                                          width: 120,
                                                          child: Container(
                                                            child: elevatedButton(() async {
                                                              await InventoryService().updateItemQnt(
                                                                restaurantId: user!
                                                                    .restaurantId,
                                                                itemId: currItem
                                                                    .itemId,
                                                                itemName:
                                                                    currItem
                                                                        .name,
                                                                userId:
                                                                    user.uid,
                                                                oldQnt: currItem
                                                                    .quantity,
                                                                newQnt:
                                                                    quantity,
                                                                note: _noteControllerFor(
                                                                  currItem
                                                                      .itemId,
                                                                ).text,
                                                              );
                                                              ref.invalidate(
                                                                inventoryProvider,
                                                              );
                                                              setState(() {
                                                                _clearEditedItem(
                                                                  currItem
                                                                      .itemId,
                                                                );
                                                              });
                                                            }, "Update"),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          // )
                                        ),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    right: 10,
                                    top: 8,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: green,
                                        borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(7),
                                        ),
                                      ),
                                      child: Text(
                                        currItem.category.name,
                                        style: TextStyle(
                                          color: whiteText,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    // ),]
                                  ),
                                  if (isLowStock)
                                    Positioned(
                                      left: 0,
                                      top: 20,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: danger,
                                          borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(7),
                                          ),
                                        ),
                                        child: Text(
                                          "Stock Alert",
                                          style: TextStyle(
                                            color: whiteText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      // ),]
                                    ),
                                ],
                              );
                            },
                            error: (e, s) {
                              return Text(e.toString());
                            },
                            loading: () => inventoryItemSkeleton(),
                          );
                        }

                        if (filteredItems.isEmpty) {
                          return Text("No items");
                        }
                        return null;
                      },
                    ),
                  ),
                );
              },
              error: (e, c) {
                return Text(e.toString());
              },
              loading: () => Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) => inventoryItemSkeleton(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/inventory_model.dart';
import 'package:restockly/providers/inventory_provider.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/services/inventory_service.dart';
import 'package:restockly/widgets/const_widget.dart';

class UpdateIntventoryItem extends ConsumerStatefulWidget {
  final String itemId;
  const UpdateIntventoryItem({super.key, required this.itemId});

  @override
  ConsumerState<UpdateIntventoryItem> createState() => _AddInventoryState();
}

class _AddInventoryState extends ConsumerState<UpdateIntventoryItem> {
  final InventoryService _inventoryService = InventoryService();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _minQuantityController;
  late TextEditingController _unitController;
  late TextEditingController _categoryController;
  bool _isFormInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
    _minQuantityController = TextEditingController();
    _unitController = TextEditingController();
    _categoryController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _minQuantityController.dispose();
    _unitController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Category selectedCategory = Category.vegetables;
  Unit selectedUnit = Unit.kg;
  final _formKey = GlobalKey<FormState>();

  void _setInitialValues(InventoryModel item) {
    if (_isFormInitialized) return;

    _nameController.text = item.name;
    _quantityController.text = item.quantity.toString();
    _minQuantityController.text = item.minQuantity.toString();
    selectedCategory = item.category;
    selectedUnit = item.unit;
    _isFormInitialized = true;
  }

  Future<void> _handleSave(String restaurantId, String itemId) async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }
    final category = selectedCategory.name;
    final unit = selectedUnit.name;

    await _inventoryService.updateInventoryItem(
      restaurantId: restaurantId,
      itemId: itemId,
      name: _nameController.text.trim(),
      category: category,
      unit: unit,
      quantity: double.tryParse(_quantityController.text.trim()) ?? 0,
      minQuantity: double.tryParse(_minQuantityController.text.trim()) ?? 0,
    );

    ref.invalidate(inventoryProvider);
    ref.invalidate(inventoryItemProvider(itemId));
    log('suc');
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final itemId = widget.itemId;
    final itemAsync = ref.watch(inventoryItemProvider(itemId));
    return userAsync.when(
      data: (userData) {
        if (userData == null) {
          return const Scaffold(body: Center(child: Text('User not found')));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Update Item"),
            leading: IconButton(onPressed: () => context.pop(), icon: Icon(Icons.clear)),
          ),
          body: Padding(
            padding: defaultPagePadding(),
            child: itemAsync.when(
              data: (itemData) {
                if (itemData == null) {
                  return const Center(child: Text('Item not found'));
                }

                _setInitialValues(itemData);

                return Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Container(
                        child: textFormField(
                          controller: _nameController,
                          labelText: "Name",
                          inputType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "*Required field";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      dropdownMenu<Category>(
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: Category.vegetables,
                            label: Category.vegetables.name,
                          ),
                          DropdownMenuEntry(
                            value: Category.dairy,
                            label: Category.dairy.name,
                          ),
                          DropdownMenuEntry(
                            value: Category.spices,
                            label: Category.spices.name,
                          ),
                          DropdownMenuEntry(
                            value: Category.beverages,
                            label: Category.beverages.name,
                          ),
                          DropdownMenuEntry(
                            value: Category.meat,
                            label: Category.meat.name,
                          ),
                        ],
                        label: "Select Category",
                        initialSelection: selectedCategory,
                        onSelected: (value) {
                          if (value == null) return;
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return "*Required field";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      dropdownMenu<Unit>(
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: Unit.kg,
                            label: Unit.kg.name,
                          ),
                          DropdownMenuEntry(
                            value: Unit.gram,
                            label: Unit.gram.name,
                          ),
                          DropdownMenuEntry(
                            value: Unit.litre,
                            label: Unit.litre.name,
                          ),
                          DropdownMenuEntry(
                            value: Unit.ml,
                            label: Unit.ml.name,
                          ),
                          DropdownMenuEntry(
                            value: Unit.piece,
                            label: Unit.piece.name,
                          ),
                        ],
                        label: "Select Item Unit",
                        initialSelection: selectedUnit,
                        onSelected: (value) {
                          if (value == null) return;
                          setState(() {
                            selectedUnit = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return "*Required field";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Container(
                        child: textFormField(
                          controller: _quantityController,
                          labelText: "Current Quantity",
                          inputType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "*Required field";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        child: textFormField(
                          controller: _minQuantityController,
                          labelText: "Minimum Quantity",
                          inputType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "*Required field";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 24),
                      elevatedButton(() {
                        _handleSave(userData.restaurantId, itemId);
                      }, "Update Item"),
                    ],
                  ),
                );
              },
              error: (e, s) => Text(e.toString()),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text(error.toString()))),
    );
  }
}

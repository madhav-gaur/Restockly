import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/inventory_model.dart';
import 'package:restockly/widgets/const_widget.dart';

class AddInventory extends StatefulWidget {
  const AddInventory({super.key});

  @override
  State<AddInventory> createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _minQuantityController;
  late TextEditingController _unitController;
  late TextEditingController _categoryController;

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

  final _formKey = GlobalKey<FormState>();
  void _handleSave() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }
    log("suc");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Item to Inventory")),
      body: Padding(
        padding: defaultPagePadding(),
        child: Form(
          key: _formKey,
          // autovalidateMode:
          //     _submitted ? AutovalidateMode.always : AutovalidateMode.disabled,
          child: ListView(
            children: [
              Container(
                child: textFormField(
                  controller: _nameController,
                  labelText: "Name",
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
                controller: _categoryController,
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
                  DropdownMenuEntry(value: Unit.kg, label: Unit.kg.name),
                  DropdownMenuEntry(value: Unit.gram, label: Unit.gram.name),
                  DropdownMenuEntry(value: Unit.litre, label: Unit.litre.name),
                  DropdownMenuEntry(value: Unit.ml, label: Unit.ml.name),
                  DropdownMenuEntry(value: Unit.piece, label: Unit.piece.name),
                ],
                label: "Select Item Unit",
                controller: _unitController,
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
                _handleSave();
              }, "Save Item"),
            ],
          ),
        ),
      ),
    );
  }
}

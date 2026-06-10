import 'package:flutter/material.dart';
import 'package:restockly/constants.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: defaultPagePadding(), child: ListView()),
    );
  }
}

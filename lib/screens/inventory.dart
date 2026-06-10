import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/routes/route_const.dart';
import 'package:restockly/themes/color_const.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inventory")),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          backgroundColor: primary,
          splashColor: secondary,
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
        child: ListView(children: [
        ],
      ),
      ),
    );
  }
}

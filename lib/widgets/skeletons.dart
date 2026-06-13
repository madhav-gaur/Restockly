import 'package:flutter/material.dart';
import 'package:restockly/themes/color_const.dart';
import 'package:restockly/widgets/const_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget transactionSkeletonTile() {
  return Skeletonizer(
    enabled: true,
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      tileColor: background,
      leading: CircleAvatar(radius: 17, backgroundColor: Colors.grey.shade200),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text("Added  2.0 kg Onion", style: TextStyle(fontSize: 20)),
          ),
          Text("2.0 kg", style: smallTextStyle().copyWith(fontSize: 15)),
        ],
      ),
      subtitle: SizedBox(
        width: 50,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // Text("Note: This a note", style: mediumTextStyle()),
            Text(
              "By Restaurant Member",
              style: smallTextStyle().copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
      // trailing:
    ),
  );
}

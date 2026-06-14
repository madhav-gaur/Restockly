import 'package:flutter/material.dart';
import 'package:restockly/themes/color_const.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget transactionSkeletonTile() {
  return Skeletonizer(
    enabled: true,
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      tileColor: background,
      leading: Bone.circle(size: 37),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Bone.text(words: 2), Bone.text(width: 40)],
      ),
      subtitle: Bone.text(width: 120, fontSize: 12),
      // trailing:
    ),
  );
}

Widget inventoryItemSkeleton() {
  return Skeletonizer(
    enabled: true,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone.text(width: 150),
              SizedBox(height: 12),
              Bone.text(width: 100),
              SizedBox(height: 12),
              Bone.text(width: 120),
              SizedBox(height: 16),
              Bone.button(
                width: 120,
                height: 40,
                borderRadius: BorderRadius.circular(100),
              ),
            ],
          ),
          Bone.button(
            width: 60,
            height: 20,
            borderRadius: BorderRadius.circular(30),
          ),
        ],
      ),
    ),
  );
}

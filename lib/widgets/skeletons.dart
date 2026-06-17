import 'package:flutter/material.dart';
import 'package:restockly/screens/home_screen.dart';
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

Widget requestTileSkeleton() {
  return Skeletonizer(
    enabled: true,
    child: ListTile(
      dense: true,
      title: Bone.text(words: 3),
      subtitle: Bone.text(width: 60),
      trailing: Bone.button(
        borderRadius: BorderRadius.circular(100),
        height: 32,
        width: 110,
      ),
    ),
  );
}

Widget homeSkeletons() {
  return Skeletonizer(
    child: Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            homeSkeletonHelper(),
            SizedBox(width: 10),
            homeSkeletonHelper(),
          ],
        ),

        SizedBox(height: 10),
        Row(
          children: [
            homeSkeletonHelper(),
            SizedBox(width: 10),
            homeSkeletonHelper(),
          ],
        ),
        SizedBox(height: 25),

        Bone.text(words: 1),
        SizedBox(height: 10),
        Row(
          children: [
            homeSkeletonHelper2(),
            const SizedBox(width: 10),
            homeSkeletonHelper2(),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            homeSkeletonHelper2(),
            const SizedBox(width: 10),
            homeSkeletonHelper2(),
          ],
        ),
      ],
    ),
  );
}

Widget homeSkeletonHelper() {
  return Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80,
            child: Bone.multiText(lines: 2, style: TextStyle(fontSize: 12)),
          ),
          Bone.square(size: 35, borderRadius: BorderRadius.circular(7)),
        ],
      ),
    ),
  );
}

Widget homeSkeletonHelper2() {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Bone.circle(size: 45),
          const SizedBox(height: 10),

          Bone.text(words: 2),
        ],
      ),
    ),
  );
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restockly/screens/main_screen.dart';
import 'package:restockly/themes/color_const.dart';

class BottomNavBarItem extends ConsumerWidget {
  final int idx;
  final IconData? unselectedIcon;
  final IconData? selectedIcon;
  final String? photoUrl;
  final String label;

  const BottomNavBarItem({
    super.key,
    required this.idx,
    this.unselectedIcon,
    this.selectedIcon,
    this.photoUrl = "",
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currIdx = ref.watch(selectedIndex);
    bool isSelected = currIdx == idx;
    return GestureDetector(
      onTap: () {
        ref.read(selectedIndex.notifier).state = idx;
      },
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromARGB(255, 207, 233, 255) : null,
          border: Border.all(
            color: isSelected ? lightPrimary : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Container(
              child: photoUrl == ""
                  ? Icon(
                      fontWeight: FontWeight.w100,
                      size: 20,
                      isSelected ? selectedIcon : unselectedIcon,
                      color: isSelected ? primary : Colors.grey.shade600,
                    )
                  : ClipOval(
                    
                    child: Image.network(photoUrl!, width: 25, height: 25,)),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? primary : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

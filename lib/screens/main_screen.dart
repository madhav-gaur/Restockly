import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:restockly/components/bottom_navbar_item.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/screens/home.dart';
import 'package:restockly/screens/inventory.dart';
import 'package:restockly/screens/profile.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _HomeState();
}

final selectedIndex = StateProvider<int>((ref) => 0);

class _HomeState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final currIdx = ref.watch(selectedIndex);

    final List<Widget> pages = [Home(), Inventory(), Profile()];
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: defaultPagePadding(),
        child: user.when(
          data: (userData) {
            return pages[currIdx];
          },
          error: (e, s) {
            return Text(e.toString());
          },
          loading: () {
            return CircularProgressIndicator();
          },
        ),
      ),
      bottomSheet: Expanded(
        child: Container(
          height: 55,
          margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(33),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BottomNavBarItem(
                idx: 0,
                unselectedIcon: Icons.home_outlined,
                selectedIcon: Icons.home_filled,
                label: "Home",
              ),
              BottomNavBarItem(
                idx: 1,
                unselectedIcon: Icons.category_outlined,
                selectedIcon: Icons.category,
                label: "Inventory",
              ),
              BottomNavBarItem(
                idx: 2,
                unselectedIcon: Icons.settings_outlined,
                selectedIcon: Icons.settings,
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

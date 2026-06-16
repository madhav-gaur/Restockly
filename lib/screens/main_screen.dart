import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:restockly/components/bottom_navbar_item.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/screens/home.dart';
import 'package:restockly/screens/inventory.dart';
import 'package:restockly/screens/profile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MainScreen extends ConsumerStatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  ConsumerState<MainScreen> createState() => _HomeState();
}

final selectedIndex = StateProvider<int>((ref) => 0);

class _HomeState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedIndex.notifier).state = widget.initialIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currIdx = ref.watch(selectedIndex);

    final List<Widget> pages = [Home(), Inventory(), Profile()];
    final user = ref.watch(currentUserProvider);
    return Stack(
      children: [
        user.when(
          data: (userData) {
            return pages[currIdx];
          },
          error: (e, s) {
            return Text(e.toString());
          },
          loading: () {
            return Text("");
          },
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 55,
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
                  user.when(
                    data: (user) {
                      // log(user?.photoUrl != null ? user.photoUrl : "no");
                      return BottomNavBarItem(
                        idx: 2,
                        unselectedIcon: Icons.person_2_outlined,
                        selectedIcon: Icons.person_2_rounded,
                        label: "You",
                        photoUrl: user?.photoUrl ?? "",
                      );
                    },
                    error: (e, s) => Text(""),
                    loading: () =>
                        Skeletonizer(enabled: true, child: Bone.circle()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      //   ),
    );
  }
}

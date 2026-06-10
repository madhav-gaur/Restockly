import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/widgets/const_widget.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    return Container(
      child: user.when(
        data: (userData) {
          return Padding(
            padding: defaultPagePadding(),
            child: ListView(
              children: [
                Text(
                  "Welcome, ${userData?.name.split(" ")[0]}",
                  style: boldTextStyle().copyWith(fontSize: 23),
                ),
                Text(userData!.restaurantName, style: smallTextStyle()),
              ],
            ),
          );
        },
        error: (e, s) {
          return Text(e.toString());
        },
        loading: () {
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

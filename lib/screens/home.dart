import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/routes/route_const.dart';
import 'package:restockly/services/auth_service.dart';
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
    return user.when(
      data: (user) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              "Welcome, ${user?.name}",
              style: boldTextStyle().copyWith(fontSize: 23),
            ),
            actions: [
              if (user?.role == Role.manager)
                IconButton(
                  onPressed: () => context.pushNamed(RouteConst.joinRequest),
                  icon: Icon(Icons.group_add_outlined ),
                ),
            ],
          ),
          body: Container(
            child: Padding(
              padding: defaultPagePadding(),
              child: ListView(
                children: [
                  // Text(user!.restaurantName, style: smallTextStyle()),
                  elevatedButton(() async {
                    await AuthService().signOut();
                    ref.invalidate(currentUserProvider);

                    if (context.mounted) {
                      context.go(RouteConst.signup);
                    }
                  }, "Sign oute"),
                ],
              ),
            ),
          ),
        );
      },
      error: (e, s) => Text("Something went Wrong"),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

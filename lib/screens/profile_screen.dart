import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/routes/route_const.dart';
import 'package:restockly/themes/color_const.dart';
import 'package:restockly/utils/capitilize.dart';
import 'package:restockly/widgets/const_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<ProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  bool showAppBar = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 200;

      if (shouldShow != showAppBar) {
        setState(() {
          showAppBar = shouldShow;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    return userAsync.when(
      data: (data) {
        final user = data!;
        final isManager = user.role == Role.manager;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(showAppBar ? 100 : 0),

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: showAppBar ? 80 : 0,
              child: AppBar(
                leading: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: showAppBar ? 1 : 0,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: user.photoUrl == ""
                        ? CircleAvatar(
                            backgroundColor: lightPrimary,
                            child: Text(
                              user.name[0].toUpperCase(),
                              style: boldTextStyle().copyWith(
                                fontSize: 20,
                                color: primary,
                              ),
                            ),
                          )
                        : Image.network(user.photoUrl!),
                  ),
                ),
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: showAppBar ? 1 : 0,
                  child: Text(user.name),
                ),
                centerTitle: false,
              ),
            ),
          ),
          body: Padding(
            padding: defaultPagePadding(),

            child: ListView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: 35),
                Center(
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    width: 100,
                    height: 100,
                    child: user.photoUrl == ""
                        ? CircleAvatar(
                            backgroundColor: lightPrimary,
                            child: Text(
                              user.name[0].toUpperCase(),
                              style: boldTextStyle().copyWith(
                                fontSize: 40,
                                color: primary,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(user.photoUrl!),
                          ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  user.name,
                  style: boldTextStyle().copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                Text(
                  user.email,
                  style: smallTextStyle().copyWith(color: textSecondary),
                  textAlign: TextAlign.center,
                ),
                Chip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(100),
                    side: BorderSide(color: Colors.transparent),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  backgroundColor: success.withAlpha(50),
                  label: Text(
                    capitalize(user.role.name),
                    style: mediumTextStyle().copyWith(
                      color: green,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: background,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _detailTile(
                        Icons.restaurant,
                        "Restaurant Name",
                        capitalize(user.restaurantName),
                      ),
                      _detailTile(
                        Icons.store_outlined,
                        "Restaurant Code",
                        user.restaurantCode,
                      ),
                      _detailTile(
                        Icons.verified_user_outlined,
                        "Status",
                        capitalize(user.userApprovalStatus.name),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                settingsTile(
                  title: "Edit Profile",
                  icon: Icons.edit,
                  onTap: () => context.pushNamed(RouteConst.editProfile),
                ),
                settingsTile(
                  title: "View Activity",
                  icon: Icons.history,
                  onTap: () =>
                      context.pushNamed(RouteConst.allStockTransactions),
                ),
                settingsTile(
                  title: "Share Restaurant's Code",
                  icon: Icons.share_outlined,
                ),
                if (isManager)
                  settingsTile(
                    title: "Pending Requests",
                    icon: Icons.notifications_active_outlined,
                  ),
                if (isManager)
                  settingsTile(
                    title: "Manage Staffs",
                    icon: Icons.groups_2_outlined,
                  ),
                if (!isManager)
                  settingsTile(
                    title: "View Members",
                    icon: Icons.group_outlined,
                  ),
                if (!isManager)
                  settingsTile(
                    title: "My Activity",
                    icon: Icons.local_activity_outlined,
                  ),
                settingsTile(
                  title: "Leave Restaurant",
                  isDanger: true,
                  icon: Icons.outbox_outlined,
                ),
                settingsTile(
                  title: "Sign Out",
                  isDanger: true,
                  icon: Icons.logout,
                ),
                if (isManager)
                  settingsTile(
                    title: "Delete Restuarant",
                    isDanger: true,
                    icon: Icons.delete_forever_rounded,
                  ),
                // settingsTile("Share Restaurant's Code"),
                SizedBox(height: 100),
              ],
            ),
          ),
        );
      },

      error: (e, s) => Text(e.toString()),
      loading: () => Center(child: CircularProgressIndicator()),
    );
    // ),

    // );
  }
}

Widget _detailTile(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Spacer(),
        Text(value),
      ],
    ),
  );
}

Widget settingsTile({
  required String title,
  bool? isDanger = false,
  VoidCallback? onTap,
  IconData? icon,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      onTap: onTap,
      tileColor: background,
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: BorderSide(color: isDanger! ? danger : Colors.grey.shade300),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: isDanger ? danger : textPrimary),
              SizedBox(width: 10),
              Text(
                title,
                style: mediumTextStyle().copyWith(
                  color: isDanger ? danger : const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios_outlined, size: 20, color: textTertiary),
        ],
      ),
    ),
  );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/repository/user_repo.dart';

final userRepoProvider = Provider((ref) => UserRepo());

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final repo = ref.read(userRepoProvider);
  return repo.getCurrentUser();
});

final anyUserProvider = FutureProvider.family<UserModel?, String>((
  ref,
  userId,
) async {
  final repo = ref.read(userRepoProvider);
  return repo.getRestaurantMember(uid: userId);
});

final allRestaurantMembersProvider = FutureProvider<List<UserModel?>>((
  ref,
) async {
  final user = await ref.watch(currentUserProvider.future);

  if (user == null) {
    return [];
  }

  final repo = ref.read(userRepoProvider);
  return repo.getAllRestaurantMembers(restaurantCode: user.restaurantCode);
});

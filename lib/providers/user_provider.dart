import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/repository/user_repo.dart';

final userRepoProvider = Provider((ref) => UserRepo());
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final firebaseUser = await ref.watch(authStateProvider.future);

  if (firebaseUser == null) return null;

  final repo = ref.read(userRepoProvider);
  return repo.getCurrentUser(firebaseUser.uid);
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

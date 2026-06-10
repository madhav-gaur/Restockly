import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/repository/user_repo.dart';

final userRepoProvider = Provider((ref) => UserRepo());

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final repo = ref.read(userRepoProvider);
  return repo.getCurrentUser();
});

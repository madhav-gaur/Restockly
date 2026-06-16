import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restockly/models/join_request_model.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/repository/join_request_repo.dart';

final joinRequestRepoProvider = Provider((ref) => JoinRequestRepo());

final joinRequestProvider = FutureProvider<List<JoinRequestModel?>>((
  ref,
) async {
  // await Future.delayed(const Duration(minutes: 22));

  final user = await ref.watch(currentUserProvider.future);

  if (user == null) {
    return [];
  }

  final repo = ref.read(joinRequestRepoProvider);
  return repo.getJoinRequests(user.restaurantId);
});

final userJoinRequestProvider = FutureProvider<JoinRequestModel?>((ref) async {
  // await Future.delayed(const Duration(minutes: 22));

  final user = await ref.watch(currentUserProvider.future);

  if (user == null) {
    return null;
  }

  final repo = ref.read(joinRequestRepoProvider);
  return repo.getUserJoinRequests(user.uid);
});

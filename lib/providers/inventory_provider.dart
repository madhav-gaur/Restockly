import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restockly/models/inventory_model.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/repository/inventory_repo.dart';

final inventoryRepoProvider = Provider((ref) => InventoryRepo());

final inventoryProvider = FutureProvider<List<InventoryModel?>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);

  if (user == null) {
    return [];
  }

  final repo = ref.read(inventoryRepoProvider);
  return repo.getAllItems(user.restaurantId);
});

final inventoryItemProvider = FutureProvider.family<InventoryModel?, String>((
  ref,
  itemId,
) async {
  final user = await ref.watch(currentUserProvider.future);
  
  if (user == null) {
    return null;
  }

  final repo = ref.read(inventoryRepoProvider);
  return repo.getInventoryItem(user.restaurantId, itemId);
});

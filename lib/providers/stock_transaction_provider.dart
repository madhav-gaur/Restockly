import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restockly/models/stock_transaction_model.dart';
import 'package:restockly/providers/user_provider.dart';
import 'package:restockly/repository/stock_transaction_repo.dart';

final stockTransaction = Provider((ref) => StockTransactionRepo());

final stockTransactionProvider = FutureProvider<List<StockTransactionModel?>>((
  ref,
) async {
  final user = await ref.watch(currentUserProvider.future);

  if (user == null) {
    return [];
  }

  final repo = ref.read(stockTransaction);
  return repo.getTransactions(user.restaurantId);
});

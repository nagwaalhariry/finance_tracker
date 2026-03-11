import 'package:isar/isar.dart';

import '../../../../core/services/isar_service.dart';
import '../models/fixed_expense_model.dart';

abstract class FixedExpenseLocalDataSource {
  Future<List<FixedExpenseModel>> getAll();
  Future<void> save(FixedExpenseModel expense);
  Future<void> deleteById(String id);
  Future<double> calculateTotal();
}

class FixedExpenseLocalDataSourceImpl implements FixedExpenseLocalDataSource {
  FixedExpenseLocalDataSourceImpl(this._isarService);

  final IsarService _isarService;

  Isar get _db => _isarService.db;
  IsarCollection<FixedExpenseModel> get _collection =>
      _db.collection<FixedExpenseModel>();

  @override
  Future<List<FixedExpenseModel>> getAll() async {
    final records = await _collection.where().findAll();
    records.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return records;
  }

  @override
  Future<void> save(FixedExpenseModel expense) async {
    await _db.writeTxn(() async {
      await _collection.put(expense);
    });
  }

  @override
  Future<void> deleteById(String id) async {
    final all = await _collection.where().findAll();
    final item = all.cast<FixedExpenseModel?>().firstWhere(
          (e) => e?.id == id,
          orElse: () => null,
        );
    if (item == null) return;

    await _db.writeTxn(() async {
      await _collection.delete(item.isarId);
    });
  }

  @override
  Future<double> calculateTotal() async {
    final all = await _collection.where().findAll();
    return all.fold<double>(0, (sum, e) => sum + e.amount);
  }
}


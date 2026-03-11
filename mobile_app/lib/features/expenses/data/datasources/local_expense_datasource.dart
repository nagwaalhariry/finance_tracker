import 'package:isar/isar.dart';

import '../../../../core/services/isar_service.dart';
import '../models/expense_model.dart';

abstract class LocalExpenseDataSource {
  Future<List<ExpenseModel>> getAll();
  Future<void> save(ExpenseModel expense);
  Future<void> deleteById(String id);
  Future<List<ExpenseModel>> getUnsynced();
  Future<void> markSynced(List<String> ids);
}

class LocalExpenseDataSourceImpl implements LocalExpenseDataSource {
  LocalExpenseDataSourceImpl(this._isarService);

  final IsarService _isarService;

  Isar get _db => _isarService.db;
  IsarCollection<ExpenseModel> get _collection =>
      _db.collection<ExpenseModel>();

  @override
  Future<List<ExpenseModel>> getAll() async {
    final records = await _collection.where().findAll();
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  @override
  Future<void> save(ExpenseModel expense) async {
    await _db.writeTxn(() async {
      await _collection.put(expense);
    });
  }

  @override
  Future<void> deleteById(String id) async {
    final item =
        (await _collection.where().findAll()).cast<ExpenseModel?>().firstWhere(
              (e) => e?.id == id,
              orElse: () => null,
            );
    if (item == null) return;
    await _db.writeTxn(() async {
      await _collection.delete(item.isarId);
    });
  }

  @override
  Future<List<ExpenseModel>> getUnsynced() async {
    final all = await _collection.where().findAll();
    return all.where((e) => !e.isSynced).toList();
  }

  @override
  Future<void> markSynced(List<String> ids) async {
    if (ids.isEmpty) return;
    final records = (await _collection.where().findAll())
        .where((e) => ids.contains(e.id))
        .toList();

    await _db.writeTxn(() async {
      for (final rec in records) {
        rec.isSynced = true;
      }
      await _collection.putAll(records);
    });
  }
}

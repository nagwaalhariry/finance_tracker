import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/local_expense_datasource.dart';
import '../datasources/remote_expense_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl(this._localDataSource, this._remoteDataSource);

  final LocalExpenseDataSource _localDataSource;
  final RemoteExpenseDataSource _remoteDataSource;

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    await _localDataSource.save(ExpenseModel.fromEntity(expense));
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _localDataSource.deleteById(id);
  }

  @override
  Future<List<ExpenseEntity>> getAllExpenses() async {
    final records = await _localDataSource.getAll();
    return records.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    final updated = expense.copyWith(isSynced: false);
    await _localDataSource.save(ExpenseModel.fromEntity(updated));
  }

  @override
  Future<List<ExpenseEntity>> getUnsyncedExpenses() async {
    final records = await _localDataSource.getUnsynced();
    return records.map((e) => e.toEntity()).toList();
  }

  @override
  Future<int> syncUnsyncedExpenses() async {
    final unsynced = await _localDataSource.getUnsynced();
    if (unsynced.isEmpty) return 0;

    const maxRetries = 3;
    var attempts = 0;

    while (attempts < maxRetries) {
      try {
        await _remoteDataSource.syncExpenses(unsynced);
        await _localDataSource.markSynced(unsynced.map((e) => e.id).toList());
        return unsynced.length;
      } catch (_) {
        attempts++;
        if (attempts >= maxRetries) rethrow;
      }
    }

    return 0;
  }
}

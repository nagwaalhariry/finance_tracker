import '../../domain/entities/fixed_expense_entity.dart';
import '../../domain/repositories/fixed_expense_repository.dart';
import '../datasources/fixed_expense_local_datasource.dart';
import '../models/fixed_expense_model.dart';

class FixedExpenseRepositoryImpl implements FixedExpenseRepository {
  FixedExpenseRepositoryImpl(this._localDataSource);

  final FixedExpenseLocalDataSource _localDataSource;

  @override
  Future<void> addFixedExpense(FixedExpenseEntity expense) {
    return _localDataSource.save(FixedExpenseModel.fromEntity(expense));
  }

  @override
  Future<double> calculateTotalFixedExpenses() => _localDataSource.calculateTotal();

  @override
  Future<void> deleteFixedExpense(String id) => _localDataSource.deleteById(id);

  @override
  Future<List<FixedExpenseEntity>> getFixedExpenses() async {
    final records = await _localDataSource.getAll();
    return records.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> updateFixedExpense(FixedExpenseEntity expense) {
    return _localDataSource.save(FixedExpenseModel.fromEntity(expense));
  }
}


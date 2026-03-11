import '../repositories/expense_repository.dart';

class SyncExpensesUseCase {
  SyncExpensesUseCase(this._repository);

  final ExpenseRepository _repository;

  Future<int> call() => _repository.syncUnsyncedExpenses();
}

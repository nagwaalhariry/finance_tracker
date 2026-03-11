import '../repositories/fixed_expense_repository.dart';

class CalculateTotalFixedExpensesUseCase {
  CalculateTotalFixedExpensesUseCase(this._repository);

  final FixedExpenseRepository _repository;

  Future<double> call() => _repository.calculateTotalFixedExpenses();
}


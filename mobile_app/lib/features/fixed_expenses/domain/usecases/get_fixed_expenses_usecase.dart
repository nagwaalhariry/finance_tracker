import '../entities/fixed_expense_entity.dart';
import '../repositories/fixed_expense_repository.dart';

class GetFixedExpensesUseCase {
  GetFixedExpensesUseCase(this._repository);

  final FixedExpenseRepository _repository;

  Future<List<FixedExpenseEntity>> call() => _repository.getFixedExpenses();
}


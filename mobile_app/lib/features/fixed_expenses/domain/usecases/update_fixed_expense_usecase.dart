import '../entities/fixed_expense_entity.dart';
import '../repositories/fixed_expense_repository.dart';

class UpdateFixedExpenseUseCase {
  UpdateFixedExpenseUseCase(this._repository);

  final FixedExpenseRepository _repository;

  Future<void> call(FixedExpenseEntity expense) =>
      _repository.updateFixedExpense(expense);
}


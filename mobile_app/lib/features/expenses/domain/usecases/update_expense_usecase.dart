import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class UpdateExpenseUseCase {
  UpdateExpenseUseCase(this._repository);

  final ExpenseRepository _repository;

  Future<void> call(ExpenseEntity expense) => _repository.updateExpense(expense);
}

import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  DeleteExpenseUseCase(this._repository);

  final ExpenseRepository _repository;

  Future<void> call(String id) => _repository.deleteExpense(id);
}

import '../repositories/fixed_expense_repository.dart';

class DeleteFixedExpenseUseCase {
  DeleteFixedExpenseUseCase(this._repository);

  final FixedExpenseRepository _repository;

  Future<void> call(String id) => _repository.deleteFixedExpense(id);
}


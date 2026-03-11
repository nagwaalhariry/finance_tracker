import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetAllExpensesUseCase {
  GetAllExpensesUseCase(this._repository);

  final ExpenseRepository _repository;

  Future<List<ExpenseEntity>> call() => _repository.getAllExpenses();
}

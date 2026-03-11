import 'package:uuid/uuid.dart';

import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class AddExpenseUseCase {
  AddExpenseUseCase(this._repository);

  final ExpenseRepository _repository;
  final Uuid _uuid = const Uuid();

  Future<void> call({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    String? note,
  }) async {
    final expense = ExpenseEntity(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      category: category,
      date: date,
      note: note,
      isSynced: false,
      createdAt: DateTime.now(),
    );
    await _repository.addExpense(expense);
  }
}

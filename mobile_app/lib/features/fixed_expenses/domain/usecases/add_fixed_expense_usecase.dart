import 'package:uuid/uuid.dart';

import '../entities/fixed_expense_entity.dart';
import '../repositories/fixed_expense_repository.dart';

class AddFixedExpenseUseCase {
  AddFixedExpenseUseCase(this._repository);

  final FixedExpenseRepository _repository;
  final Uuid _uuid = const Uuid();

  Future<void> call({
    required String title,
    required double amount,
    required String category,
  }) {
    final expense = FixedExpenseEntity(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      category: category,
      createdAt: DateTime.now(),
    );
    return _repository.addFixedExpense(expense);
  }
}


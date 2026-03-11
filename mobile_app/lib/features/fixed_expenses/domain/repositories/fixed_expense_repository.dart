import '../entities/fixed_expense_entity.dart';

abstract class FixedExpenseRepository {
  Future<List<FixedExpenseEntity>> getFixedExpenses();
  Future<void> addFixedExpense(FixedExpenseEntity expense);
  Future<void> updateFixedExpense(FixedExpenseEntity expense);
  Future<void> deleteFixedExpense(String id);
  Future<double> calculateTotalFixedExpenses();
}


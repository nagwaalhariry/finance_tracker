import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseEntity>> getAllExpenses();
  Future<void> addExpense(ExpenseEntity expense);
  Future<void> updateExpense(ExpenseEntity expense);
  Future<void> deleteExpense(String id);
  Future<List<ExpenseEntity>> getUnsyncedExpenses();
  Future<int> syncUnsyncedExpenses();
}

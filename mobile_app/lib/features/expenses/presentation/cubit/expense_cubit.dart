import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/get_all_expenses_usecase.dart';
import '../../domain/usecases/update_expense_usecase.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit(this._getAllExpenses, this._deleteExpense, this._updateExpense)
      : super(const ExpenseState.initial());

  final GetAllExpensesUseCase _getAllExpenses;
  final DeleteExpenseUseCase _deleteExpense;
  final UpdateExpenseUseCase _updateExpense;

  Future<void> loadExpenses() async {
    emit(state.copyWith(status: ExpenseStatus.loading));
    try {
      final expenses = await _getAllExpenses();
      emit(state.copyWith(status: ExpenseStatus.success, expenses: expenses));
    } catch (e) {
      emit(state.copyWith(status: ExpenseStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> deleteExpense(String id) async {
    emit(state.copyWith(status: ExpenseStatus.loading));
    try {
      await _deleteExpense(id);
      await loadExpenses();
    } catch (e) {
      emit(state.copyWith(status: ExpenseStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> updateExpense(ExpenseEntity expense) async {
    emit(state.copyWith(status: ExpenseStatus.loading));
    try {
      await _updateExpense(expense);
      await loadExpenses();
    } catch (e) {
      emit(state.copyWith(status: ExpenseStatus.error, errorMessage: e.toString()));
    }
  }
}

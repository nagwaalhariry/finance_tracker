import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/fixed_expense_entity.dart';
import '../../domain/usecases/add_fixed_expense_usecase.dart';
import '../../domain/usecases/delete_fixed_expense_usecase.dart';
import '../../domain/usecases/get_fixed_expenses_usecase.dart';
import '../../domain/usecases/update_fixed_expense_usecase.dart';

part 'fixed_expense_state.dart';

class FixedExpenseCubit extends Cubit<FixedExpenseState> {
  FixedExpenseCubit(
    this._getFixedExpenses,
    this._addFixedExpense,
    this._updateFixedExpense,
    this._deleteFixedExpense,
  ) : super(const FixedExpenseState.initial());

  final GetFixedExpensesUseCase _getFixedExpenses;
  final AddFixedExpenseUseCase _addFixedExpense;
  final UpdateFixedExpenseUseCase _updateFixedExpense;
  final DeleteFixedExpenseUseCase _deleteFixedExpense;

  Future<void> loadFixedExpenses() async {
    emit(state.copyWith(status: FixedExpenseStatus.loading));
    try {
      final expenses = await _getFixedExpenses();
      emit(
        state.copyWith(
          status: FixedExpenseStatus.loaded,
          expenses: expenses,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FixedExpenseStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addFixedExpense({
    required String title,
    required double amount,
    required String category,
  }) async {
    emit(state.copyWith(status: FixedExpenseStatus.loading));
    try {
      await _addFixedExpense(title: title, amount: amount, category: category);
      await loadFixedExpenses();
    } catch (e) {
      emit(
        state.copyWith(
          status: FixedExpenseStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateFixedExpense(FixedExpenseEntity expense) async {
    emit(state.copyWith(status: FixedExpenseStatus.loading));
    try {
      await _updateFixedExpense(expense);
      await loadFixedExpenses();
    } catch (e) {
      emit(
        state.copyWith(
          status: FixedExpenseStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteFixedExpense(String id) async {
    emit(state.copyWith(status: FixedExpenseStatus.loading));
    try {
      await _deleteFixedExpense(id);
      await loadFixedExpenses();
    } catch (e) {
      emit(
        state.copyWith(
          status: FixedExpenseStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}


import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_expense_usecase.dart';

part 'add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  AddExpenseCubit(this._addExpenseUseCase) : super(const AddExpenseState.initial());

  final AddExpenseUseCase _addExpenseUseCase;

  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    String? note,
  }) async {
    emit(state.copyWith(status: AddExpenseStatus.loading));
    try {
      await _addExpenseUseCase(
        title: title,
        amount: amount,
        category: category,
        date: date,
        note: note,
      );
      emit(state.copyWith(status: AddExpenseStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AddExpenseStatus.error, errorMessage: e.toString()));
    }
  }

  void reset() => emit(const AddExpenseState.initial());
}

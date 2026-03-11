import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/get_all_expenses_usecase.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._getAllExpensesUseCase)
      : super(const DashboardState.initial());

  final GetAllExpensesUseCase _getAllExpensesUseCase;

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final expenses = await _getAllExpensesUseCase();
      final now = DateTime.now();
      final thisMonthExpenses = expenses
          .where((e) => e.date.year == now.year && e.date.month == now.month)
          .toList();

      final totalSpending = thisMonthExpenses.fold<double>(
        0,
        (sum, e) => sum + e.amount,
      );

      final byCategory = <String, double>{};
      for (final e in thisMonthExpenses) {
        byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amount;
      }

      emit(
        state.copyWith(
          status: DashboardStatus.success,
          totalMonthSpending: totalSpending,
          monthlyExpenses: thisMonthExpenses,
          categoryBreakdown: byCategory,
          recentExpenses: expenses.take(5).toList(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: DashboardStatus.error, errorMessage: e.toString()),
      );
    }
  }
}

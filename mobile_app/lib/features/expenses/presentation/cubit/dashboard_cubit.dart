import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/auth_repository.dart';
import '../../../fixed_expenses/domain/usecases/calculate_total_fixed_expenses_usecase.dart';
import '../../../profile/domain/usecases/get_user_profile_usecase.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/get_all_expenses_usecase.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(
    this._getAllExpensesUseCase,
    this._calculateTotalFixedExpenses,
    this._getUserProfileUseCase,
    this._authRepository,
  )
      : super(const DashboardState.initial());

  final GetAllExpensesUseCase _getAllExpensesUseCase;
  final CalculateTotalFixedExpensesUseCase _calculateTotalFixedExpenses;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final AuthRepository _authRepository;

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final userId = _authRepository.currentUserId();
      if (userId == null) {
        throw Exception('No authenticated user found.');
      }

      final profile = await _getUserProfileUseCase(userId);
      if (profile == null) {
        throw Exception('Missing monthly salary setup.');
      }

      final expenses = await _getAllExpensesUseCase();
      final now = DateTime.now();
      final thisMonthExpenses = expenses
          .where((e) => e.date.year == now.year && e.date.month == now.month)
          .toList();

      final totalSpending = thisMonthExpenses.fold<double>(
        0,
        (sum, e) => sum + e.amount,
      );
      final totalFixed = await _calculateTotalFixedExpenses();
      final monthlySalary = profile.monthlySalary;
      final remainingAfterEssentials = monthlySalary - totalFixed;
      final remainingBalance = remainingAfterEssentials - totalSpending;

      final byCategory = <String, double>{};
      for (final e in thisMonthExpenses) {
        byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amount;
      }

      emit(
        state.copyWith(
          status: DashboardStatus.success,
          totalMonthSpending: totalSpending,
          monthlySalary: monthlySalary,
          currency: profile.currency,
          totalFixedExpenses: totalFixed,
          remainingAfterEssentials: remainingAfterEssentials,
          remainingBalance: remainingBalance,
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

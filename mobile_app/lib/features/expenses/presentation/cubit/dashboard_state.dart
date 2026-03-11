part of 'dashboard_cubit.dart';

enum DashboardStatus { initial, loading, success, error }

class DashboardState extends Equatable {
  const DashboardState({
    required this.status,
    required this.totalMonthSpending,
    required this.monthlyExpenses,
    required this.categoryBreakdown,
    required this.recentExpenses,
    this.errorMessage,
  });

  const DashboardState.initial()
      : status = DashboardStatus.initial,
        totalMonthSpending = 0,
        monthlyExpenses = const [],
        categoryBreakdown = const {},
        recentExpenses = const [],
        errorMessage = null;

  final DashboardStatus status;
  final double totalMonthSpending;
  final List<ExpenseEntity> monthlyExpenses;
  final Map<String, double> categoryBreakdown;
  final List<ExpenseEntity> recentExpenses;
  final String? errorMessage;

  DashboardState copyWith({
    DashboardStatus? status,
    double? totalMonthSpending,
    List<ExpenseEntity>? monthlyExpenses,
    Map<String, double>? categoryBreakdown,
    List<ExpenseEntity>? recentExpenses,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      totalMonthSpending: totalMonthSpending ?? this.totalMonthSpending,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      recentExpenses: recentExpenses ?? this.recentExpenses,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        totalMonthSpending,
        monthlyExpenses,
        categoryBreakdown,
        recentExpenses,
        errorMessage,
      ];
}

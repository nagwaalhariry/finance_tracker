part of 'dashboard_cubit.dart';

enum DashboardStatus { initial, loading, success, error }

class DashboardState extends Equatable {
  const DashboardState({
    required this.status,
    required this.totalMonthSpending,
    required this.monthlySalary,
    required this.currency,
    required this.totalFixedExpenses,
    required this.remainingAfterEssentials,
    required this.remainingBalance,
    required this.monthlyExpenses,
    required this.categoryBreakdown,
    required this.recentExpenses,
    this.errorMessage,
  });

  const DashboardState.initial()
      : status = DashboardStatus.initial,
        totalMonthSpending = 0,
        monthlySalary = 0,
        currency = 'USD',
        totalFixedExpenses = 0,
        remainingAfterEssentials = 0,
        remainingBalance = 0,
        monthlyExpenses = const [],
        categoryBreakdown = const {},
        recentExpenses = const [],
        errorMessage = null;

  final DashboardStatus status;
  final double totalMonthSpending;
  final double monthlySalary;
  final String currency;
  final double totalFixedExpenses;
  final double remainingAfterEssentials;
  final double remainingBalance;
  final List<ExpenseEntity> monthlyExpenses;
  final Map<String, double> categoryBreakdown;
  final List<ExpenseEntity> recentExpenses;
  final String? errorMessage;

  DashboardState copyWith({
    DashboardStatus? status,
    double? totalMonthSpending,
    double? monthlySalary,
    String? currency,
    double? totalFixedExpenses,
    double? remainingAfterEssentials,
    double? remainingBalance,
    List<ExpenseEntity>? monthlyExpenses,
    Map<String, double>? categoryBreakdown,
    List<ExpenseEntity>? recentExpenses,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      totalMonthSpending: totalMonthSpending ?? this.totalMonthSpending,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      currency: currency ?? this.currency,
      totalFixedExpenses: totalFixedExpenses ?? this.totalFixedExpenses,
      remainingAfterEssentials:
          remainingAfterEssentials ?? this.remainingAfterEssentials,
      remainingBalance: remainingBalance ?? this.remainingBalance,
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
        monthlySalary,
        currency,
        totalFixedExpenses,
        remainingAfterEssentials,
        remainingBalance,
        monthlyExpenses,
        categoryBreakdown,
        recentExpenses,
        errorMessage,
      ];
}

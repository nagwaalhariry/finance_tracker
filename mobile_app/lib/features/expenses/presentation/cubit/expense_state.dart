part of 'expense_cubit.dart';

enum ExpenseStatus { initial, loading, success, error }

class ExpenseState extends Equatable {
  const ExpenseState({
    required this.status,
    required this.expenses,
    this.errorMessage,
  });

  const ExpenseState.initial()
      : status = ExpenseStatus.initial,
        expenses = const [],
        errorMessage = null;

  final ExpenseStatus status;
  final List<ExpenseEntity> expenses;
  final String? errorMessage;

  ExpenseState copyWith({
    ExpenseStatus? status,
    List<ExpenseEntity>? expenses,
    String? errorMessage,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, expenses, errorMessage];
}

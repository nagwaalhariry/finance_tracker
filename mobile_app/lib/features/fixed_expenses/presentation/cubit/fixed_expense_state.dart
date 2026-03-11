part of 'fixed_expense_cubit.dart';

enum FixedExpenseStatus { initial, loading, loaded, error }

class FixedExpenseState extends Equatable {
  const FixedExpenseState({
    required this.status,
    required this.expenses,
    this.errorMessage,
  });

  const FixedExpenseState.initial()
      : status = FixedExpenseStatus.initial,
        expenses = const [],
        errorMessage = null;

  final FixedExpenseStatus status;
  final List<FixedExpenseEntity> expenses;
  final String? errorMessage;

  FixedExpenseState copyWith({
    FixedExpenseStatus? status,
    List<FixedExpenseEntity>? expenses,
    String? errorMessage,
  }) {
    return FixedExpenseState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, expenses, errorMessage];
}


part of 'add_expense_cubit.dart';

enum AddExpenseStatus { initial, loading, success, error }

class AddExpenseState extends Equatable {
  const AddExpenseState({required this.status, this.errorMessage});

  const AddExpenseState.initial()
      : status = AddExpenseStatus.initial,
        errorMessage = null;

  final AddExpenseStatus status;
  final String? errorMessage;

  AddExpenseState copyWith({AddExpenseStatus? status, String? errorMessage}) {
    return AddExpenseState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

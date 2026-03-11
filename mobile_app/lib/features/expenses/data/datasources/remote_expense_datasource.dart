import 'package:dio/dio.dart';

import '../models/expense_model.dart';

abstract class RemoteExpenseDataSource {
  Future<void> syncExpenses(List<ExpenseModel> expenses);
}

class RemoteExpenseDataSourceImpl implements RemoteExpenseDataSource {
  RemoteExpenseDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> syncExpenses(List<ExpenseModel> expenses) async {
    if (expenses.isEmpty) return;

    await _dio.post(
      '/sync',
      data: {
        'expenses': expenses.map((e) => e.toJson()).toList(),
      },
    );
  }
}

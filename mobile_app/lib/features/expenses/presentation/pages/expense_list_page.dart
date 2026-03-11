import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/pages/settings_page.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/expense_cubit.dart';
import '../widgets/expense_tile.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  String? _category;
  bool _sortDescending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Expenses'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              setState(() => _sortDescending = !_sortDescending);
            },
            icon: Icon(_sortDescending ? Icons.arrow_downward : Icons.arrow_upward),
          )
        ],
      ),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          if (state.status == ExpenseStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          var expenses = [...state.expenses];
          if (_category != null) {
            expenses = expenses.where((e) => e.category == _category).toList();
          }

          expenses.sort((a, b) {
            if (_sortDescending) {
              return b.date.compareTo(a.date);
            }
            return a.date.compareTo(b.date);
          });

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: DropdownButtonFormField<String?>(
                  value: _category,
                  decoration: const InputDecoration(labelText: 'Filter by Category'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All')),
                    ...AppConstants.defaultCategories.map(
                      (e) => DropdownMenuItem(value: e, child: Text(e)),
                    )
                  ],
                  onChanged: (value) => setState(() => _category = value),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<ExpenseCubit>().loadExpenses(),
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return ExpenseTile(
                        expense: expense,
                        onDelete: () async {
                          await context.read<ExpenseCubit>().deleteExpense(expense.id);
                          await context.read<DashboardCubit>().loadDashboard();
                        },
                        onEdit: (updated) async {
                          await context.read<ExpenseCubit>().updateExpense(updated);
                          await context.read<DashboardCubit>().loadDashboard();
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

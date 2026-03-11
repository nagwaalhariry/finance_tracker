import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/expense_tile.dart';
import '../../../auth/presentation/pages/settings_page.dart';
import '../../../profile/presentation/cubit/user_profile_cubit.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/expense_cubit.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  String _category = 'All';
  bool _sortDescending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Expenses'),
        actions: [
          IconButton(
            onPressed: () {
              final profileCubit = context.read<UserProfileCubit>();
              final dashboardCubit = context.read<DashboardCubit>();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: profileCubit),
                      BlocProvider.value(value: dashboardCubit),
                    ],
                    child: const SettingsPage(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              setState(() => _sortDescending = !_sortDescending);
            },
            icon: Icon(
                _sortDescending ? Icons.arrow_downward : Icons.arrow_upward),
          )
        ],
      ),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          if (state.status == ExpenseStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          var expenses = [...state.expenses];
          if (_category != 'All') {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...['All', ...AppConstants.defaultCategories].map(
                        (cat) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: _category == cat,
                            label: Text(cat),
                            onSelected: (_) => setState(() => _category = cat),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<ExpenseCubit>().loadExpenses(),
                  child: expenses.isEmpty
                      ? const EmptyStateWidget(title: 'No expenses found')
                      : ListView.builder(
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final expense = expenses[index];
                            return AppExpenseTile(
                              expense: expense,
                              onDelete: () async {
                                await context
                                    .read<ExpenseCubit>()
                                    .deleteExpense(expense.id);
                                await context
                                    .read<DashboardCubit>()
                                    .loadDashboard();
                              },
                              onEdit: (updated) async {
                                await context
                                    .read<ExpenseCubit>()
                                    .updateExpense(updated);
                                await context
                                    .read<DashboardCubit>()
                                    .loadDashboard();
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

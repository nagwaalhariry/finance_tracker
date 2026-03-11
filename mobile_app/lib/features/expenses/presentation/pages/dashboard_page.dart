import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../auth/presentation/pages/settings_page.dart';
import '../../../fixed_expenses/presentation/cubit/fixed_expense_cubit.dart';
import '../../../fixed_expenses/presentation/pages/fixed_expenses_page.dart';
import '../../../profile/presentation/cubit/user_profile_cubit.dart';
import '../cubit/dashboard_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Dashboard'),
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
        ],
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == DashboardStatus.error) {
            return Center(
                child: Text(state.errorMessage ?? 'Failed to load dashboard'));
          }

          final categoryEntries = state.categoryBreakdown.entries.toList();
          final money = NumberFormat.simpleCurrency(name: state.currency);

          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Monthly Salary',
                          style: Theme.of(context).textTheme.labelLarge),
                      Text(
                        money.format(state.monthlySalary),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text('Currency: ${state.currency}'),
                      Text(
                          'Essential Expenses: ${money.format(state.totalFixedExpenses)}'),
                      Text(
                          'Remaining Balance: ${money.format(state.remainingBalance)}'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: SizedBox(
                    height: 220,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              spots: state.monthlyExpenses
                                  .asMap()
                                  .entries
                                  .map((e) {
                                return FlSpot(e.key.toDouble(), e.value.amount);
                              }).toList(),
                            )
                          ],
                          titlesData: const FlTitlesData(show: false),
                          gridData: const FlGridData(show: true),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: SizedBox(
                    height: 240,
                    child: PieChart(
                      PieChartData(
                        sections: categoryEntries.map((e) {
                          return PieChartSectionData(
                            value: e.value,
                            title: e.key,
                            radius: 80,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: ListTile(
                    title: const Text('Essential Monthly Expenses'),
                    subtitle: Text(
                      'Remaining after essentials: ${money.format(state.remainingAfterEssentials)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final fixedExpenseCubit =
                          context.read<FixedExpenseCubit>();
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: fixedExpenseCubit,
                            child: const FixedExpensesPage(),
                          ),
                        ),
                      );
                      if (context.mounted) {
                        await context.read<DashboardCubit>().loadDashboard();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text('Recent Expenses',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (state.recentExpenses.isEmpty)
                  const EmptyStateWidget(title: 'No recent expenses')
                else
                  ...state.recentExpenses.map(
                    (expense) => Card(
                      child: ListTile(
                        title: Text(expense.title),
                        subtitle: Text(AppDateUtils.formatDate(expense.date)),
                        trailing: Text(money.format(expense.amount)),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

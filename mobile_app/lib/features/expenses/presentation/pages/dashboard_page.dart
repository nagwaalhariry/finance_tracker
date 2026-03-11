import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../auth/presentation/pages/settings_page.dart';
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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
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
            return Center(child: Text(state.errorMessage ?? 'Failed to load dashboard'));
          }

          final categoryEntries = state.categoryBreakdown.entries.toList();

          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Total Spending This Month'),
                    subtitle: Text(
                      '\$${state.totalMonthSpending.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: SizedBox(
                    height: 220,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              spots: state.monthlyExpenses.asMap().entries.map((e) {
                                return FlSpot(e.key.toDouble(), e.value.amount);
                              }).toList(),
                            )
                          ],
                          titlesData: FlTitlesData(show: false),
                          gridData: const FlGridData(show: true),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
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
                Text('Recent Expenses', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ...state.recentExpenses.map(
                  (expense) => Card(
                    child: ListTile(
                      title: Text(expense.title),
                      subtitle: Text(AppDateUtils.formatDate(expense.date)),
                      trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/pages/settings_page.dart';
import '../cubit/add_expense_cubit.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/expense_cubit.dart';
import 'add_expense_page.dart';
import 'dashboard_page.dart';
import 'expense_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _pages = const [
    DashboardPage(),
    ExpenseListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) => setState(() => _currentIndex = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.list_alt_outlined), label: 'Expenses'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final addCubit = context.read<AddExpenseCubit>();
          final expenseCubit = context.read<ExpenseCubit>();
          final dashboardCubit = context.read<DashboardCubit>();
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: addCubit),
                  BlocProvider.value(value: expenseCubit),
                  BlocProvider.value(value: dashboardCubit),
                ],
                child: const AddExpensePage(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Finance Tracker')),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () async {
                Navigator.of(context).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../cubit/fixed_expense_cubit.dart';

class FixedExpensesPage extends StatefulWidget {
  const FixedExpensesPage({super.key});

  @override
  State<FixedExpensesPage> createState() => _FixedExpensesPageState();
}

class _FixedExpensesPageState extends State<FixedExpensesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FixedExpenseCubit>().loadFixedExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Essential Monthly Expenses')),
      body: BlocBuilder<FixedExpenseCubit, FixedExpenseState>(
        builder: (context, state) {
          if (state.status == FixedExpenseStatus.loading &&
              state.expenses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == FixedExpenseStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'Failed to load'));
          }

          final total = state.expenses.fold<double>(0, (s, e) => s + e.amount);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: const Text('Total Essentials'),
                  subtitle: Text('\$${total.toStringAsFixed(2)}'),
                ),
              ),
              const SizedBox(height: 12),
              ...state.expenses.map(
                (item) => Card(
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.category),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        Text('\$${item.amount.toStringAsFixed(2)}'),
                        IconButton(
                          onPressed: () => _openDialog(expenseId: item.id, initialTitle: item.title, initialAmount: item.amount, initialCategory: item.category),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            context
                                .read<FixedExpenseCubit>()
                                .deleteFixedExpense(item.id);
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Essential'),
      ),
    );
  }

  Future<void> _openDialog({
    String? expenseId,
    String? initialTitle,
    double? initialAmount,
    String? initialCategory,
  }) async {
    final titleController = TextEditingController(text: initialTitle ?? '');
    final amountController =
        TextEditingController(text: initialAmount?.toString() ?? '');
    var category = initialCategory ?? AppConstants.fixedExpenseCategories.first;

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(expenseId == null ? 'Add Essential' : 'Edit Essential'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: category,
              items: AppConstants.fixedExpenseCategories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => category = value ?? category,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text.trim());
              if (amount == null || titleController.text.trim().isEmpty) return;

              if (expenseId == null) {
                await context.read<FixedExpenseCubit>().addFixedExpense(
                      title: titleController.text.trim(),
                      amount: amount,
                      category: category,
                    );
              } else {
                final current = context
                    .read<FixedExpenseCubit>()
                    .state
                    .expenses
                    .firstWhere((e) => e.id == expenseId);
                await context.read<FixedExpenseCubit>().updateFixedExpense(
                      current.copyWith(
                        title: titleController.text.trim(),
                        amount: amount,
                        category: category,
                      ),
                    );
              }
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}


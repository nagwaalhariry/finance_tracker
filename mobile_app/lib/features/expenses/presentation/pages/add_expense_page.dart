import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../cubit/add_expense_cubit.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/expense_cubit.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _category = AppConstants.defaultCategories.first;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: BlocConsumer<AddExpenseCubit, AddExpenseState>(
        listener: (context, state) {
          if (state.status == AddExpenseStatus.success) {
            context.read<ExpenseCubit>().loadExpenses();
            context.read<DashboardCubit>().loadDashboard();
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) => value == null || value.isEmpty ? 'Enter title' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || double.tryParse(value) == null
                        ? 'Enter valid amount'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _category,
                    items: AppConstants.defaultCategories
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => _category = value ?? _category),
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text('Date'),
                    subtitle: Text(_selectedDate.toIso8601String().split('T').first),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(labelText: 'Note (optional)'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: state.status == AddExpenseStatus.loading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() != true) return;
                            context.read<AddExpenseCubit>().addExpense(
                                  title: _titleController.text.trim(),
                                  amount: double.parse(_amountController.text.trim()),
                                  category: _category,
                                  date: _selectedDate,
                                  note: _noteController.text.trim().isEmpty
                                      ? null
                                      : _noteController.text.trim(),
                                );
                          },
                    child: state.status == AddExpenseStatus.loading
                        ? const CircularProgressIndicator()
                        : const Text('Save Expense'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

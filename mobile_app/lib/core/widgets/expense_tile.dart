import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../../features/expenses/domain/entities/expense_entity.dart';
import '../utils/date_utils.dart';

class AppExpenseTile extends StatelessWidget {
  const AppExpenseTile({
    required this.expense,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  final ExpenseEntity expense;
  final Future<void> Function() onDelete;
  final Future<void> Function(ExpenseEntity updated) onEdit;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red.shade100,
        child: const Icon(Icons.delete_outline),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(child: Text(expense.category.substring(0, 1))),
          title: Text(expense.title),
          subtitle:
              Text('${expense.category} • ${AppDateUtils.formatDate(expense.date)}'),
          trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
          onTap: () => _showEditDialog(context),
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final titleController = TextEditingController(text: expense.title);
    final amountController = TextEditingController(text: expense.amount.toString());
    var selectedCategory = expense.category;

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Expense'),
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
              value: selectedCategory,
              items: AppConstants.defaultCategories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => selectedCategory = value ?? selectedCategory,
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
              final parsedAmount = double.tryParse(amountController.text.trim());
              if (parsedAmount == null) return;
              final updated = expense.copyWith(
                title: titleController.text.trim(),
                amount: parsedAmount,
                category: selectedCategory,
              );
              await onEdit(updated);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}


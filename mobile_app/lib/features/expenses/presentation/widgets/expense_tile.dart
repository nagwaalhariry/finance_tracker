import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/expense_entity.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
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
    return Card(
      child: ListTile(
        title: Text(expense.title),
        subtitle: Text('${expense.category} • ${AppDateUtils.formatDate(expense.date)}'),
        trailing: Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('\$${expense.amount.toStringAsFixed(2)}'),
            Icon(
              expense.isSynced ? Icons.cloud_done : Icons.cloud_off,
              color: expense.isSynced ? Colors.green : Colors.orange,
            ),
            IconButton(
              onPressed: () => _showEditDialog(context),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
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
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
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
          )
        ],
      ),
    );
  }
}

const Expense = require('../models/Expense');

async function upsertExpenses(expenses = []) {
  if (!Array.isArray(expenses) || expenses.length === 0) {
    return { syncedCount: 0 };
  }

  const operations = expenses.map((expense) => ({
    updateOne: {
      filter: { id: expense.id },
      update: {
        $set: {
          title: expense.title,
          amount: expense.amount,
          category: expense.category,
          date: expense.date,
          note: expense.note || '',
          createdAt: expense.createdAt || new Date(),
          userId: expense.userId || 'default-user',
        },
      },
      upsert: true,
    },
  }));

  await Expense.bulkWrite(operations);
  return { syncedCount: expenses.length };
}

module.exports = { upsertExpenses };

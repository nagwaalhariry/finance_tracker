const Expense = require('../models/Expense');
const { upsertExpenses } = require('../services/syncService');

function validateExpensePayload(body) {
  const { id, title, amount, category, date, createdAt } = body;
  if (!id || !title || amount == null || !category || !date || !createdAt) {
    return 'Missing required fields: id, title, amount, category, date, createdAt';
  }
  if (Number.isNaN(Number(amount))) {
    return 'amount must be a valid number';
  }
  return null;
}

async function createExpense(req, res, next) {
  try {
    const validationError = validateExpensePayload(req.body);
    if (validationError) {
      return res.status(400).json({ message: validationError });
    }

    const expense = await Expense.create(req.body);
    return res.status(201).json({ message: 'Expense created', data: expense });
  } catch (error) {
    return next(error);
  }
}

async function getAllExpenses(_req, res, next) {
  try {
    const expenses = await Expense.find().sort({ date: -1 });
    return res.status(200).json({ data: expenses });
  } catch (error) {
    return next(error);
  }
}

async function updateExpense(req, res, next) {
  try {
    const updated = await Expense.findOneAndUpdate({ id: req.params.id }, req.body, {
      new: true,
      runValidators: true,
    });

    if (!updated) {
      return res.status(404).json({ message: 'Expense not found' });
    }

    return res.status(200).json({ message: 'Expense updated', data: updated });
  } catch (error) {
    return next(error);
  }
}

async function deleteExpense(req, res, next) {
  try {
    const deleted = await Expense.findOneAndDelete({ id: req.params.id });

    if (!deleted) {
      return res.status(404).json({ message: 'Expense not found' });
    }

    return res.status(200).json({ message: 'Expense deleted' });
  } catch (error) {
    return next(error);
  }
}

async function syncExpenses(req, res, next) {
  try {
    const { expenses } = req.body;
    if (!Array.isArray(expenses)) {
      return res.status(400).json({ message: 'expenses must be an array' });
    }

    for (const item of expenses) {
      const validationError = validateExpensePayload(item);
      if (validationError) {
        return res.status(400).json({ message: validationError });
      }
    }

    const result = await upsertExpenses(expenses);
    return res.status(200).json({ message: 'Sync completed', ...result });
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  createExpense,
  getAllExpenses,
  updateExpense,
  deleteExpense,
  syncExpenses,
};

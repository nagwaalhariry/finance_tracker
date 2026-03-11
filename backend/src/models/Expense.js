const mongoose = require('mongoose');

const ExpenseSchema = new mongoose.Schema(
  {
    id: { type: String, required: true, unique: true, index: true },
    title: { type: String, required: true, trim: true },
    amount: { type: Number, required: true, min: 0 },
    category: { type: String, required: true },
    date: { type: Date, required: true },
    note: { type: String, default: '' },
    userId: { type: String, default: 'default-user' },
    createdAt: { type: Date, required: true },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Expense', ExpenseSchema);

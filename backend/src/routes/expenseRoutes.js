const express = require('express');

const {
  createExpense,
  deleteExpense,
  getAllExpenses,
  updateExpense,
} = require('../controllers/expenseController');

const router = express.Router();

router.post('/', createExpense);
router.get('/', getAllExpenses);
router.put('/:id', updateExpense);
router.delete('/:id', deleteExpense);

module.exports = router;

const express = require('express');

const { syncExpenses } = require('../controllers/expenseController');

const router = express.Router();

router.post('/', syncExpenses);

module.exports = router;

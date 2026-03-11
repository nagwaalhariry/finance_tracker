const cors = require('cors');
const express = require('express');

const expenseRoutes = require('./routes/expenseRoutes');
const syncRoutes = require('./routes/syncRoutes');
const errorHandler = require('./middleware/errorHandler');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/health', (_req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.use('/api/expenses', expenseRoutes);
app.use('/api/sync', syncRoutes);

app.use(errorHandler);

module.exports = app;

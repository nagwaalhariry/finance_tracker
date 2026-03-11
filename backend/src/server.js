require('dotenv').config();

const app = require('./app');
const connectDb = require('./config/db');

const PORT = process.env.PORT || 3000;

(async () => {
  try {
    await connectDb();
    app.listen(PORT, () => {
      console.log(`Finance Tracker API listening on port ${PORT}`);
    });
  } catch (error) {
    console.error('Failed to start server:', error.message);
    process.exit(1);
  }
})();

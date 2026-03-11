function errorHandler(error, _req, res, _next) {
  console.error(error);

  if (error.code === 11000) {
    return res.status(409).json({ message: 'Duplicate expense id' });
  }

  return res.status(500).json({ message: 'Internal server error' });
}

module.exports = errorHandler;

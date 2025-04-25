const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

// Import routes
const courseRoutes = require('./routes/courseRoutes');

// Create Express app
const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Replace the existing MongoDB connection code with this:
// Connect to MongoDB with retry logic
const connectWithRetry = () => {
  mongoose.connect(process.env.MONGODB_URI)
    .then(() => {
      console.log('Connected to MongoDB');
    })
    .catch(err => {
      console.error('MongoDB connection error:', err);
      console.log('Retrying in 5 seconds...');
      setTimeout(connectWithRetry, 5000);
    });
};

connectWithRetry();
// Routes
app.use('/api/courses', courseRoutes);

// Test route
app.get('/', (req, res) => {
  res.send('Course API server is running!');
});

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});

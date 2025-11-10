require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const connectDB = require('./config/database');
const notificationService = require('./services/notificationService');

// Import routes
const varietyRoutes = require('./routes/varietyRoutes');
const plantingFormRoutes = require('./routes/plantingFormRoutes');
const samplingFormRoutes = require('./routes/samplingFormRoutes');
const replantingFormRoutes = require('./routes/replantingFormRoutes');

const app = express();

// Connect to database
connectDB();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve uploaded files
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Routes
app.use('/api/varieties', varietyRoutes);
app.use('/api/planting-forms', plantingFormRoutes);
app.use('/api/sampling-forms', samplingFormRoutes);
app.use('/api/replanting-forms', replantingFormRoutes);

// Manual notification trigger endpoint (for testing)
app.post('/api/notifications/check-harvests', async (req, res) => {
  try {
    const count = await notificationService.triggerManualCheck();
    res.json({ 
      success: true, 
      message: `Checked and sent ${count} notifications` 
    });
  } catch (error) {
    res.status(500).json({ 
      success: false, 
      message: error.message 
    });
  }
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString() 
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    message: 'Something went wrong!', 
    error: process.env.NODE_ENV === 'development' ? err.message : undefined 
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ message: 'Route not found' });
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
  
  // Start notification cron job
  notificationService.startCronJob();
});

module.exports = app;

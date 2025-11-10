const mongoose = require('mongoose');

const varietySchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  averageCycleDays: {
    type: Number,
    required: true,
    min: 1
  },
  isPollinizer: {
    type: Boolean,
    default: false
  },
  description: {
    type: String,
    trim: true
  },
  active: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Variety', varietySchema);

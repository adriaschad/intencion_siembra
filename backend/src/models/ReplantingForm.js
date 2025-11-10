const mongoose = require('mongoose');

const replantingFormSchema = new mongoose.Schema({
  plantingForm: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'PlantingForm',
    required: true
  },
  farmName: {
    type: String,
    required: true,
    trim: true
  },
  lotNumber: {
    type: String,
    required: true,
    trim: true
  },
  variety: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Variety',
    required: true
  },
  replantingDate: {
    type: Date,
    required: true,
    default: Date.now
  },
  additionalSeedsUsed: {
    type: Number,
    required: true,
    min: 1
  },
  reason: {
    type: String,
    trim: true
  },
  affectedArea: {
    type: Number,
    min: 0
  },
  observations: {
    type: String,
    trim: true
  },
  producerId: {
    type: String,
    required: true
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('ReplantingForm', replantingFormSchema);

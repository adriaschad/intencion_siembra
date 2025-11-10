const mongoose = require('mongoose');

const samplingFormSchema = new mongoose.Schema({
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
  valveNumber: {
    type: String,
    trim: true
  },
  variety: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Variety',
    required: true
  },
  samplingDate: {
    type: Date,
    required: true,
    default: Date.now
  },
  brixReadings: [{
    value: {
      type: Number,
      required: true,
      min: 0,
      max: 100
    },
    location: {
      type: String,
      trim: true
    }
  }],
  averageBrix: {
    type: Number,
    min: 0,
    max: 100
  },
  observations: {
    type: String,
    trim: true
  },
  photos: [{
    type: String
  }],
  producerId: {
    type: String,
    required: true
  }
}, {
  timestamps: true
});

// Calculate average brix before saving
samplingFormSchema.pre('save', function(next) {
  if (this.brixReadings && this.brixReadings.length > 0) {
    const sum = this.brixReadings.reduce((acc, reading) => acc + reading.value, 0);
    this.averageBrix = sum / this.brixReadings.length;
  }
  next();
});

module.exports = mongoose.model('SamplingForm', samplingFormSchema);

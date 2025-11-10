const mongoose = require('mongoose');

const plantingFormSchema = new mongoose.Schema({
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
  area: {
    type: Number,
    required: true,
    min: 0
  },
  originalArea: {
    type: Number
  },
  plantingDate: {
    type: Date,
    required: true
  },
  expectedHarvestDate: {
    type: Date
  },
  confirmedHarvestDate: {
    type: Date
  },
  status: {
    type: String,
    enum: ['pending', 'approved', 'rejected', 'harvested'],
    default: 'pending'
  },
  approvedBy: {
    type: String,
    trim: true
  },
  approvalDate: {
    type: Date
  },
  approvalPhotos: [{
    type: String
  }],
  observations: {
    type: String,
    trim: true
  },
  producerId: {
    type: String,
    required: true
  },
  notificationSent: {
    type: Boolean,
    default: false
  },
  notificationDate: {
    type: Date
  }
}, {
  timestamps: true
});

// Calculate expected harvest date based on variety cycle
plantingFormSchema.pre('save', async function(next) {
  if (this.isNew || this.isModified('plantingDate') || this.isModified('variety')) {
    const Variety = mongoose.model('Variety');
    const variety = await Variety.findById(this.variety);
    if (variety && this.plantingDate) {
      const expectedDate = new Date(this.plantingDate);
      expectedDate.setDate(expectedDate.getDate() + variety.averageCycleDays);
      this.expectedHarvestDate = expectedDate;
    }
  }
  if (this.isNew && this.area) {
    this.originalArea = this.area;
  }
  next();
});

module.exports = mongoose.model('PlantingForm', plantingFormSchema);

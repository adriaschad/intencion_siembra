const PlantingForm = require('../models/PlantingForm');
const Variety = require('../models/Variety');

// Get all planting forms
exports.getAllPlantingForms = async (req, res) => {
  try {
    const { producerId, status } = req.query;
    const filter = {};
    if (producerId) filter.producerId = producerId;
    if (status) filter.status = status;

    const forms = await PlantingForm.find(filter)
      .populate('variety')
      .sort({ createdAt: -1 });
    res.json(forms);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get planting form by ID
exports.getPlantingFormById = async (req, res) => {
  try {
    const form = await PlantingForm.findById(req.params.id).populate('variety');
    if (!form) {
      return res.status(404).json({ message: 'Planting form not found' });
    }
    res.json(form);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create planting form
exports.createPlantingForm = async (req, res) => {
  try {
    const form = new PlantingForm(req.body);
    const newForm = await form.save();
    await newForm.populate('variety');
    res.status(201).json(newForm);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Update planting form
exports.updatePlantingForm = async (req, res) => {
  try {
    const form = await PlantingForm.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    ).populate('variety');
    if (!form) {
      return res.status(404).json({ message: 'Planting form not found' });
    }
    res.json(form);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Approve planting form
exports.approvePlantingForm = async (req, res) => {
  try {
    const { approvedBy, approvalPhotos, observations } = req.body;
    
    const form = await PlantingForm.findByIdAndUpdate(
      req.params.id,
      {
        status: 'approved',
        approvedBy,
        approvalDate: new Date(),
        approvalPhotos: approvalPhotos || [],
        observations: observations || form.observations
      },
      { new: true }
    ).populate('variety');

    if (!form) {
      return res.status(404).json({ message: 'Planting form not found' });
    }

    res.json(form);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Rectify area
exports.rectifyArea = async (req, res) => {
  try {
    const { area } = req.body;
    
    if (!area || area < 0) {
      return res.status(400).json({ message: 'Valid area is required' });
    }

    const form = await PlantingForm.findByIdAndUpdate(
      req.params.id,
      { area },
      { new: true, runValidators: true }
    ).populate('variety');

    if (!form) {
      return res.status(404).json({ message: 'Planting form not found' });
    }

    res.json(form);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Confirm harvest date
exports.confirmHarvestDate = async (req, res) => {
  try {
    const { confirmedHarvestDate } = req.body;
    
    const form = await PlantingForm.findByIdAndUpdate(
      req.params.id,
      { 
        confirmedHarvestDate: new Date(confirmedHarvestDate),
        notificationSent: false
      },
      { new: true }
    ).populate('variety');

    if (!form) {
      return res.status(404).json({ message: 'Planting form not found' });
    }

    res.json(form);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Get dashboard statistics
exports.getDashboardStats = async (req, res) => {
  try {
    const { producerId } = req.query;
    const filter = producerId ? { producerId } : {};

    // Get all planting forms with variety details
    const forms = await PlantingForm.find(filter).populate('variety');

    // Calculate totals excluding pollinizers
    let totalArea = 0;
    let totalAreaWithPollinizers = 0;
    const stats = {
      totalForms: forms.length,
      pendingForms: 0,
      approvedForms: 0,
      rejectedForms: 0,
      totalArea: 0,
      totalAreaWithPollinizers: 0,
      varietyBreakdown: {},
      pollinizers: []
    };

    forms.forEach(form => {
      // Count by status
      if (form.status === 'pending') stats.pendingForms++;
      else if (form.status === 'approved') stats.approvedForms++;
      else if (form.status === 'rejected') stats.rejectedForms++;

      // Calculate areas
      totalAreaWithPollinizers += form.area;
      
      if (!form.variety.isPollinizer) {
        totalArea += form.area;
      } else {
        stats.pollinizers.push({
          variety: form.variety.name,
          area: form.area
        });
      }

      // Variety breakdown
      const varietyName = form.variety.name;
      if (!stats.varietyBreakdown[varietyName]) {
        stats.varietyBreakdown[varietyName] = {
          area: 0,
          count: 0,
          isPollinizer: form.variety.isPollinizer
        };
      }
      stats.varietyBreakdown[varietyName].area += form.area;
      stats.varietyBreakdown[varietyName].count++;
    });

    stats.totalArea = totalArea;
    stats.totalAreaWithPollinizers = totalAreaWithPollinizers;

    res.json(stats);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

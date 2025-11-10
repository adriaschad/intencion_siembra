const SamplingForm = require('../models/SamplingForm');
const PlantingForm = require('../models/PlantingForm');

// Get all sampling forms
exports.getAllSamplingForms = async (req, res) => {
  try {
    const { producerId, plantingFormId } = req.query;
    const filter = {};
    if (producerId) filter.producerId = producerId;
    if (plantingFormId) filter.plantingForm = plantingFormId;

    const forms = await SamplingForm.find(filter)
      .populate('variety')
      .populate('plantingForm')
      .sort({ samplingDate: -1 });
    res.json(forms);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get sampling form by ID
exports.getSamplingFormById = async (req, res) => {
  try {
    const form = await SamplingForm.findById(req.params.id)
      .populate('variety')
      .populate('plantingForm');
    if (!form) {
      return res.status(404).json({ message: 'Sampling form not found' });
    }
    res.json(form);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create sampling form
exports.createSamplingForm = async (req, res) => {
  try {
    // Verify planting form exists
    const plantingForm = await PlantingForm.findById(req.body.plantingForm);
    if (!plantingForm) {
      return res.status(404).json({ message: 'Planting form not found' });
    }

    // Auto-populate fields from planting form if not provided
    const formData = {
      ...req.body,
      farmName: req.body.farmName || plantingForm.farmName,
      lotNumber: req.body.lotNumber || plantingForm.lotNumber,
      valveNumber: req.body.valveNumber || plantingForm.valveNumber,
      variety: req.body.variety || plantingForm.variety
    };

    const form = new SamplingForm(formData);
    const newForm = await form.save();
    await newForm.populate(['variety', 'plantingForm']);
    res.status(201).json(newForm);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Update sampling form
exports.updateSamplingForm = async (req, res) => {
  try {
    const form = await SamplingForm.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    ).populate(['variety', 'plantingForm']);
    
    if (!form) {
      return res.status(404).json({ message: 'Sampling form not found' });
    }
    res.json(form);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Delete sampling form
exports.deleteSamplingForm = async (req, res) => {
  try {
    const form = await SamplingForm.findByIdAndDelete(req.params.id);
    if (!form) {
      return res.status(404).json({ message: 'Sampling form not found' });
    }
    res.json({ message: 'Sampling form deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

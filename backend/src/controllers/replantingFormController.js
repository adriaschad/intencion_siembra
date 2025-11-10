const ReplantingForm = require('../models/ReplantingForm');
const PlantingForm = require('../models/PlantingForm');

// Get all replanting forms
exports.getAllReplantingForms = async (req, res) => {
  try {
    const { producerId, plantingFormId } = req.query;
    const filter = {};
    if (producerId) filter.producerId = producerId;
    if (plantingFormId) filter.plantingForm = plantingFormId;

    const forms = await ReplantingForm.find(filter)
      .populate('variety')
      .populate('plantingForm')
      .sort({ replantingDate: -1 });
    res.json(forms);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get replanting form by ID
exports.getReplantingFormById = async (req, res) => {
  try {
    const form = await ReplantingForm.findById(req.params.id)
      .populate('variety')
      .populate('plantingForm');
    if (!form) {
      return res.status(404).json({ message: 'Replanting form not found' });
    }
    res.json(form);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create replanting form
exports.createReplantingForm = async (req, res) => {
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
      variety: req.body.variety || plantingForm.variety
    };

    const form = new ReplantingForm(formData);
    const newForm = await form.save();
    await newForm.populate(['variety', 'plantingForm']);
    res.status(201).json(newForm);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Update replanting form
exports.updateReplantingForm = async (req, res) => {
  try {
    const form = await ReplantingForm.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    ).populate(['variety', 'plantingForm']);
    
    if (!form) {
      return res.status(404).json({ message: 'Replanting form not found' });
    }
    res.json(form);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Delete replanting form
exports.deleteReplantingForm = async (req, res) => {
  try {
    const form = await ReplantingForm.findByIdAndDelete(req.params.id);
    if (!form) {
      return res.status(404).json({ message: 'Replanting form not found' });
    }
    res.json({ message: 'Replanting form deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

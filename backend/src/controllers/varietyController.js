const Variety = require('../models/Variety');

// Get all varieties
exports.getAllVarieties = async (req, res) => {
  try {
    const varieties = await Variety.find({ active: true });
    res.json(varieties);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get variety by ID
exports.getVarietyById = async (req, res) => {
  try {
    const variety = await Variety.findById(req.params.id);
    if (!variety) {
      return res.status(404).json({ message: 'Variety not found' });
    }
    res.json(variety);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create variety
exports.createVariety = async (req, res) => {
  try {
    const variety = new Variety(req.body);
    const newVariety = await variety.save();
    res.status(201).json(newVariety);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Update variety
exports.updateVariety = async (req, res) => {
  try {
    const variety = await Variety.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );
    if (!variety) {
      return res.status(404).json({ message: 'Variety not found' });
    }
    res.json(variety);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Delete variety (soft delete)
exports.deleteVariety = async (req, res) => {
  try {
    const variety = await Variety.findByIdAndUpdate(
      req.params.id,
      { active: false },
      { new: true }
    );
    if (!variety) {
      return res.status(404).json({ message: 'Variety not found' });
    }
    res.json({ message: 'Variety deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

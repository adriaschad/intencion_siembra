const express = require('express');
const router = express.Router();
const varietyController = require('../controllers/varietyController');

router.get('/', varietyController.getAllVarieties);
router.get('/:id', varietyController.getVarietyById);
router.post('/', varietyController.createVariety);
router.put('/:id', varietyController.updateVariety);
router.delete('/:id', varietyController.deleteVariety);

module.exports = router;

const express = require('express');
const router = express.Router();
const plantingFormController = require('../controllers/plantingFormController');
const upload = require('../middleware/upload');

router.get('/', plantingFormController.getAllPlantingForms);
router.get('/dashboard', plantingFormController.getDashboardStats);
router.get('/:id', plantingFormController.getPlantingFormById);
router.post('/', plantingFormController.createPlantingForm);
router.put('/:id', plantingFormController.updatePlantingForm);
router.put('/:id/approve', upload.array('approvalPhotos', 10), plantingFormController.approvePlantingForm);
router.put('/:id/rectify-area', plantingFormController.rectifyArea);
router.put('/:id/confirm-harvest', plantingFormController.confirmHarvestDate);

module.exports = router;

const express = require('express');
const router = express.Router();
const samplingFormController = require('../controllers/samplingFormController');
const upload = require('../middleware/upload');

router.get('/', samplingFormController.getAllSamplingForms);
router.get('/:id', samplingFormController.getSamplingFormById);
router.post('/', upload.array('photos', 20), samplingFormController.createSamplingForm);
router.put('/:id', upload.array('photos', 20), samplingFormController.updateSamplingForm);
router.delete('/:id', samplingFormController.deleteSamplingForm);

module.exports = router;

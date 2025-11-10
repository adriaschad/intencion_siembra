const express = require('express');
const router = express.Router();
const replantingFormController = require('../controllers/replantingFormController');

router.get('/', replantingFormController.getAllReplantingForms);
router.get('/:id', replantingFormController.getReplantingFormById);
router.post('/', replantingFormController.createReplantingForm);
router.put('/:id', replantingFormController.updateReplantingForm);
router.delete('/:id', replantingFormController.deleteReplantingForm);

module.exports = router;

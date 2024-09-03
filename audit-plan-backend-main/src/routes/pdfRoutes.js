const express = require('express');
const router = express.Router();
const pdfController = require('../controllers/pdfController')


router.post(`/generate-pdf`, pdfController.generate_report);
router.post(`/generate-specific-pdf`, pdfController.generate_specific_task_report);


module.exports = router;
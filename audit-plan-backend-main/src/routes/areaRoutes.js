const express = require('express');
const router = express.Router();
const areaController = require('../controllers/areaController')


router.get(`/remote_area_weekly`,areaController.remote_area_weekly);
router.post(`/area_questions`,areaController.area_register);
router.get(`/main_area`,areaController.main_area);
router.get(`/main_area_by_spec`,areaController.main_area_bySpec);
router.get(`/specific_areas`,areaController.specific_areas);
router.get(`/questions`,areaController.questions);
router.get(`/questionsBySpecArea`,areaController.questionBySpecArea);
router.get(`/reportby-specific/:specific_area/:audit_date`,areaController.report_by_spec_areadate);


module.exports = router;
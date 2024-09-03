const express = require('express');
const router = express.Router();
const specificTaskController = require('../controllers/sppecificTaskController')


router.post(`/specific-task`, specificTaskController.assign_specific_task);
router.get(`/specific-task/:weekNumber/:month/:year`, specificTaskController.get_report_by_week);
router.get(`/specific-task-pending`, specificTaskController.pending_tasks);
router.post(`/update-status`, specificTaskController.update_progress);


module.exports = router;
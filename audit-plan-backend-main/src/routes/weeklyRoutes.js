const express = require('express');
const router = express.Router();
const weeklyController = require('../controllers/weeklyController')


router.post(`/tasks`,weeklyController.post_weekly_taskID);
router.get(`/tasks`,weeklyController.view_weekly_taskId);
router.get(`/tasksbyweek/:weekNumber/:month/:year`,weeklyController.get_tasks_by_week);
router.post(`/weeklyPersonAssign`,weeklyController.weekly_assign);
router.get(`/weeklyPersonAssign/:username`,weeklyController.get_assign);
// router.get(`/weeklyreport/:weekNumber/:month/:year`,weeklyController.get_data_by_week);
router.get('/audit/area/:specific_area/:weekNumber/:month/:year', weeklyController.get_data_by_area_and_week);
router.get(`/weeklyreport/:weekNumber/:month/:year`,weeklyController.get_report_by_week);


module.exports = router;
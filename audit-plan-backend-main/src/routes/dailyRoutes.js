const express = require('express');
const router = express.Router();
const dailyController = require('../controllers/dailycontroller')


router.post(`/assignTask`,dailyController.post_daily_taskID);
router.get(`/dailytasks`,dailyController.view_daily_tasks);
router.post(`/dailyPersonAssign`,dailyController.daily_assign);
router.get(`/dailyPersonAssign/:username`,dailyController.get_assign);


module.exports = router;
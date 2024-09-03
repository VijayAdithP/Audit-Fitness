const express = require('express');
const router = express.Router();
const upload = require('../middleware/multerConfig'); 
const auditController = require('../controllers/auditDataController');


router.post('/storeAuditData', upload.any(), auditController.storeAuditData);
router.post('/WeekAuditData', upload.any(), auditController.WeekAuditData);


module.exports = router;
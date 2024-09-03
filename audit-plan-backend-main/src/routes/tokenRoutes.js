const express = require('express');
const router = express.Router();
const tokenController = require('../controllers/tokenController')


router.post(`/store-token`,tokenController.save_token);
router.delete(`/logout-token`,tokenController.delete_token);


module.exports = router;
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const verifyToken = require('../middleware/verifyToken'); 

router.post('/login', authController.login);
router.post('/register', authController.register);
router.get('/roles', authController.roles);
router.get('/users/me',verifyToken, authController.current_user);


module.exports = router;
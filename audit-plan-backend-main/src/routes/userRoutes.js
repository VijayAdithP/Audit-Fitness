const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController')


router.get('/users',userController.users);
router.get(`/users/:username`,userController.get_users_byName);
router.put('/users/:id',userController.edit_user);
router.delete('/users/:id',userController.delete_user);


module.exports = router;
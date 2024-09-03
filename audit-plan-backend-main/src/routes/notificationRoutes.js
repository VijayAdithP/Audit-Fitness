const express = require('express');
const router = express.Router();
const { getUserTokens, sendNotification } = require('../controllers/notificationController');

router.post('/send-user-Notification', async (req, res) => {
  const { message } = req.body;

  if (!message) {
    return res.status(400).json({ error: 'Message is required' });
  }
  try {
    const tokens = await getUserTokens();

    if (tokens.length === 0) {
      return res.status(404).json({ error: 'No users found' });
    }

    const result = await sendNotification(tokens, message);
    return res.status(200).json(result);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});


module.exports = router;

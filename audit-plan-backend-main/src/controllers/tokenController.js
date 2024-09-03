const pool = require('../config/db');

exports.save_token = async(req,res) =>{
    const {username, fcmtoken} = req.body;
    if (!username || !fcmtoken) {
        return res.status(400).json({ error: 'Username and FCM token are required' });
      }
    
      try {
        const [rows] = await pool.query('SELECT * FROM users WHERE username = ?', [username]);
    
        if (rows.length === 0) {
          return res.status(404).json({ error: 'User not found' });
        }
    
        const [result] = await pool.query(
          `INSERT INTO user_tokens (username, fcmtoken, created_at, updated_at)
           VALUES (?, ?, NOW(), NOW())
           ON DUPLICATE KEY UPDATE fcmtoken = VALUES(fcmtoken), updated_at = NOW()`,
          [username, fcmtoken]
        );
    
        res.status(200).json({ message: 'Token stored successfully' });
      } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while storing the token' });
      }
    };


exports.delete_token = async(req,res) =>{
    const { fcmtoken} = req.body;
      
      try {
        const query = `DELETE FROM user_tokens WHERE fcmtoken =?`
        const [result] = await pool.query(query, [fcmtoken]);
       
        res.status(200).json({ message: 'Token deleted successfully' });
      } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while deleting the token' });
      }
    };
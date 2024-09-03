require('dotenv').config();
const admin = require('firebase-admin');

const serviceAccount = {
  type: 'service_account',
  project_id: process.env.FIREBASE_PROJECT_ID,
  private_key: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
  client_email: process.env.FIREBASE_CLIENT_EMAIL,
};

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

exports.sendNotification = async (tokens, message) => {
  if (!Array.isArray(tokens)) {
    throw new Error('Tokens must be an array');
  }

  const payload = {
    notification: {
      title: 'Audit Task Manager',
      body: message,
    }
  };

  try {
    const response = await admin.messaging().sendToDevice(tokens, payload);
    console.log('Notification sent successfully:', response);
    if (response.failureCount > 0) {
      response.results.forEach((result, index) => {
        if (result.error) {
          console.error(`Error sending to token ${tokens[index]}:`, result.error);
        }
      });
    }
    return { success: true, response };
  } catch (error) {
    console.error('Error sending notification:', error);
    throw new Error(`Failed to send notification: ${error.message}`);
  }
};


exports.sendtaskupdate = async (tokens, message) => {
  if (!Array.isArray(tokens)) {
    throw new Error('Tokens must be an array');
  }

  const payload = {
    notification: {
      title: 'Campus Maintenance',
      body: message,
    }
  };

  try {
    const response = await admin.messaging().sendToDevice(tokens, payload);
    console.log('Notification sent successfully:', response);
    if (response.failureCount > 0) {
      response.results.forEach((result, index) => {
        if (result.error) {
          console.error(`Error sending to token ${tokens[index]}:`, result.error);
        }
      });
    }
    return { success: true, response };
  } catch (error) {
    console.error('Error sending notification:', error);
    throw new Error(`Failed to send notification: ${error.message}`);
  }
};


const pool = require('../config/db')

exports.getUserTokens = async () => {
  try {
    const [rows] = await pool.query(`
      SELECT fcmtoken 
      FROM user_tokens 
      WHERE username IN (
        SELECT username 
        FROM users 
        WHERE role = 2
      )
    `);

    if (rows.length === 0) {
      return [];
    }

    return rows.map(row => row.fcmtoken);
  } catch (error) {
    console.error('Error retrieving user tokens:', error);
    throw new Error(`Failed to retrieve user tokens: ${error.message}`);
  }
};
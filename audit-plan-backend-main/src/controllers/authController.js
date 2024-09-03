const pool = require('../config/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken'); 

exports.login = async(req,res) =>{

    const { username, password } = req.body;

    try{
        const query = 
            `SELECT users.*, user_role.role as role_name 
            FROM users 
            JOIN user_role ON users.role = user_role.id 
            WHERE username = ?
            `;
        const [results] = await pool.query(query, [username])

        if (results.length === 0) {
            return res.status(404).send({ message: 'User not found' });
        }

        const user = results[0];
        const passwordMatch = await bcrypt.compare(password, user.password);

        if (passwordMatch) {
            const token = jwt.sign(
                { id: user.id, role: user.role_name },
                process.env.JWT_SECRET || 'your_secret_key',
                { expiresIn: '1h' }
            );
            res.send({ message: 'Login successful', token, role: user.role_name });
        } else {
            res.status(401).send({ message: 'Invalid credentials' });
        }

    }catch (err){
        console.error('Error:', err);
        res.status(500).send({ message: 'Internal server error' });
    }
};

exports.register = async (req,res) => {
    const { username, password, roleId, firstName, lastName, phoneNumber, staffId } = req.body;

    try {
        // Check if the username already exists
        const checkQuery = 'SELECT * FROM users WHERE username = ?';
        const [resultsCheck] = await pool.query(checkQuery, [username]);
            
        if (resultsCheck.length > 0) {
            return res.status(400).send({ message: 'User already exists' });
        } 
        const hashedPassword = await bcrypt.hash(password, 10);

        const insertQuery = 'INSERT INTO users (username, password, role, firstName, lastName, phoneNumber, staffId) VALUES (?, ?, ?, ?, ?, ?, ?)';
        const [results] = await pool.query(insertQuery, [username, hashedPassword, roleId, firstName, lastName, phoneNumber, staffId ])
            
        res.send({ message: 'User registered successfully' });
            
    } catch (error) {
        console.error('Error:', error);
        res.status(500).send({ message: 'Internal server error' });
 }
};

//roles
exports.roles = async (req,res) => {
    try{
        const query = 'SELECT * FROM user_role'
        const [results] = await pool.query(query);
        res.send(results);
    }catch (err){
        console.error('problem in users...', err)
        res.status(500).send('problem in users...', err);
    }
};

// Endpoint to fetch the details of the currently logged-in user
exports.current_user = async(req,res) => {
    try{
        const query = 'SELECT * FROM users WHERE id = ?';
        const [results] = await pool.query(query, [req.userId]);

        if (results.length === 0) {
            res.status(404).send({ message: 'User not found' });
        } else {
            const user = results[0];
            res.send({
                id: user.id,
                username: user.username,
                role: user.role,
            });
        }
    }catch (error) {
        console.error('Database error:', error);
        res.status(500).send({ message: 'Database error', error: error.message });
    }
};


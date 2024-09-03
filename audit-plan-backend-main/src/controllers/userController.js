const pool = require('../config/db');

//get all users
exports.users = async (req,res) => {
    try{
        const query = 'SELECT * FROM users'
        const [results] = await pool.query(query);
        res.send(results);
    }catch (err){
        console.error('problem in user details...',err)
        res.status(500).send('problem in user details...');
    }
};

//get users by username stored in localstorage
exports.get_users_byName = async(req,res) => {
    const { username } = req.params;

    try{
        const query = 'SELECT firstName, lastName, phoneNumber FROM users WHERE username =?';
        const [results] = await pool.query(query,[username]);
        if (results.length > 0) {
            return res.send(results[0]);
        } else {
            return res.status(404).send({ message: 'User not found' });
        }
    }catch (error) {
        console.error('Database error:', error);
        res.status(500).send({ message: 'Database error', error: error.message });
    }
};

//edit users
exports.edit_user = async(req,res) => {
    const { id } = req.params;
    const { username, firstName, lastName, phoneNumber, staffId } = req.body;
     try{
        const query = `
        UPDATE users 
        SET username =?, firstName =?, lastName =?, phoneNumber =?, staffId =?
        WHERE id =?`;

        const[result] = await pool.query(query,[username, firstName, lastName, phoneNumber, staffId, id]);
        res.send(result);
     }catch(err) {
        console.error('Error updating users:', err);
        res.status(500).send('Error updating users');
     }
};

//delete users
exports.delete_user = async(req, res) => {
    const { id } = req.params;
    const query = 'DELETE FROM users WHERE id = ?';
    try{
        const [result] = await pool.query(query,[id]);
        res.send(result);
    }catch(err){
        console.error('Error deleting users:', err);
        res.status(500).send('Error deleting users');
    }
};
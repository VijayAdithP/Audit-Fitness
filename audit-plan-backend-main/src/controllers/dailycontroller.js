const pool = require('../config/db');

//assign daily tasks
exports.post_daily_taskID = async (req, res) => {
  const { date, taskId } = req.body;

  if (!date || !taskId) {
    return res.status(400).send({ message: 'Date and taskId must be provided.' });
  }

  try {
    // Check if taskId already exists
    const checkTaskQuery = 'SELECT * FROM audit_tasks WHERE task_id = ?';
    const [taskResults] = await pool.query(checkTaskQuery, [taskId]); 

    if (taskResults.length > 0) {
      return res.status(400).send({ message: 'Task already exists' });
    }

    // Check if a taskId already exists for the given date
    const checkQuery = 'SELECT * FROM audit_tasks WHERE date = ?';
    const [dateResults] = await pool.query(checkQuery, [date]); 

    if (dateResults.length > 0) {
      return res.status(409).send({ message: 'A taskId is already assigned for this date.' });
    }

    // Insert the new task assignment
    const insertQuery = 'INSERT INTO audit_tasks (date, task_id) VALUES (?, ?)';
    const [insertResults] = await pool.query(insertQuery, [date, taskId]);

    res.send({ message: 'Task assigned successfully' });

  } catch (error) {
    console.error('Error in /assignTask endpoint:', error);
    res.status(500).send({ message: 'Internal server error', error: error.message });
  }
};

//view entire daily tasks
exports.view_daily_tasks = async (req, res) => {
    try{
        const query = `SELECT * FROM audit_tasks`;
        const [results] = await pool.query(query);
        res.send(results);
    }catch(error){
        console.error("cannot get daily tasks")
        res.status(500).send({mesage: "cannot get daily tasks",error:error.message})
    }
};

//assign person and area for daily task
exports.daily_assign = async (req, res) => {
    const { daily_audit_id, date, username, selected_areas } = req.body;
  
    const rowsToInsert = selected_areas.map(area => ({
      daily_audit_id,
      date,
      username,
      selected_area: area
    }));
  
    const query = 'INSERT INTO daily_audit_assign (daily_audit_id, date, username, selected_area) VALUES ?';

    try{
        const [result] = await pool.query(query,[rowsToInsert.map(row => Object.values(row))]);
        res.status(200).send('Data stored successfully');
    }
    catch (err){
        console.error('Error inserting rows:', err);
        res.status(500).send('Error inserting rows');
    }
};

//get tasks assigned individually
exports.get_assign = async (req, res) => {

    const username = req.params.username;

    try{
        const query = `SELECT * FROM daily_audit_assign WHERE username = ?`;
        const[results] = await pool.query(query, [username]);
        res.send(results);
    }
    catch(err){
        console.error('Error fetching assigned areas: ' + err.stack);
        res.status(500).json({ error: 'Database error' });
    }
};
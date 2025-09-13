const pool = require('../config/db');
const { sendNotification } = require('./notificationController');

//assign weekly tasks
exports.post_weekly_taskID = async (req,res) =>{
    const { weekly_taskId, weekNumber, month, year } = req.body;

    try{
        // Check if weekly_taskId already exists
        const checkTaskQuery = 'SELECT * FROM weekly_tasks WHERE weekly_taskId = ?';
        const [resultsTask] = await pool.query(checkTaskQuery, [weekly_taskId]);

        if(resultsTask.length > 0){
           return res.status(400).send({ message: 'Task already exists' });
        }

        // Check if task with same weekNumber, month, and year exists
        const checkDuplicateQuery = 'SELECT * FROM weekly_tasks WHERE weekNumber = ? AND month = ? AND year = ?';
        const [resultsDate] = await pool.query(checkDuplicateQuery, [weekNumber, month, year]);

        if(resultsDate.length > 0){
         return res.status(400).send({ message: 'Task with same weekNumber, month, and year already exists' });    
        }

         // Insert new task into weekly_tasks table
         const insertTaskQuery = 'INSERT INTO weekly_tasks (weekly_taskId, weekNumber, month, year, created_at) VALUES (?, ?, ?, ?, NOW())';
         const [results] = await pool.query(insertTaskQuery, [weekly_taskId, weekNumber, month, year]);
         
         console.log('Weekly task inserted successfully:', results.insertId);
         res.send('weekly task id inserted successfully!')

    }catch (err){
        console.error('Error inserting task:', err);
        res.status(500).json({ error: 'Failed to insert task' });
    }
};

//view entire weekly task id
exports.view_weekly_taskId = async (req,res) => {
    try{
        const query = `SELECT * FROM weekly_tasks`
        const [results] = await pool.query(query);
        res.send(results);
    }catch (err){
        console.error("cannot get weekly tasks",err)
        res.status(500).send("cannot get weekly tasks")
    }
}


//gety task id by week
exports.get_tasks_by_week = async (req, res) => {
    const { weekNumber, month, year } = req.params;

    const query = `
        SELECT *
        FROM weekly_tasks
        WHERE weekNumber = ? 
          AND month = ? 
          AND year = ?;
    `;

    try {
        const [results] = await pool.query(query, [weekNumber, month, year]);
        res.send(results);
    } catch (err) {
        console.error('Error retrieving tasks:', err);
        res.status(500).json({ error: 'Database error in getting weekly tasks' });
    }
};



//assign person and area for weekly task
exports.weekly_assign = async (req, res) => {
    const { username, weekNumber, weekly_taskId, year, month, selected_areas } = req.body;
  
    try {
        const checkQuery = `
            SELECT selected_area 
            FROM weekly_audit_assign 
            WHERE week_number = ? AND month = ? AND year = ? AND selected_area IN (?)
        `;
  
        // Check for existing assignments
        const [existingRows] = await pool.query(checkQuery, [weekNumber, month, year, selected_areas]);
        const existingAreas = existingRows.map(row => row.selected_area);
  
        const newAreas = selected_areas.filter(area => !existingAreas.includes(area));
  
        const alreadyAssignedAreas = selected_areas.filter(area => existingAreas.includes(area));

        if (newAreas.length === 0) {
            return res.status(400).send(`All selected areas are already assigned for the given week.`);
        }
  
        const rowsToInsert = newAreas.map(area => ({
            username,
            weekly_taskId,
            weekNumber,
            month,
            year,
            selected_area: area
        }));
  
        const insertQuery = `
            INSERT INTO weekly_audit_assign (username, weekly_taskId, week_number, month, year, selected_area) 
            VALUES ?
        `;
  
        await pool.query(insertQuery, [rowsToInsert.map(row => Object.values(row))]);
  
        const message = `${alreadyAssignedAreas.length > 0 ? `${alreadyAssignedAreas.join(', ')} already assigned for this week. ` : ''}Data stored for ${newAreas.join(', ')}.`;
        
        const [userRows] = await pool.query(`
            SELECT DISTINCT u.username, ut.fcmtoken
            FROM users u
            JOIN user_tokens ut ON u.username = ut.username
            WHERE u.username = ?`, [username]);

        const tokens = userRows.map(row => row.fcmtoken);

        if (tokens.length > 0) {
            const message = "பணி ஐடி: ${weekly_taskId} இந்த வாரத்திற்கு ஒதுக்கப்பட்டுள்ளது. பணிகளை விரைவாக நிறைவு செய்யவும்.";
            await sendNotification(tokens, message);
            // console.log(tokens)
            // console.log(message)
        }

        res.status(200).send(message);
        
    } catch (err) {
        console.error('Error inserting rows:', err);
        res.status(500).send('Error inserting rows');
    }
};

//get tasks assigned individually
exports.get_assign = async (req, res) => {

    const username = req.params.username;

    try{
        const query = `
            SELECT waa.* 
            FROM weekly_audit_assign waa
            LEFT JOIN weekly_audits wa ON 
                wa.specific_area = waa.selected_area 
                AND waa.username = ?
                AND waa.week_number = wa.week_number 
                AND waa.month = wa.month 
                AND waa.year = wa.year
            WHERE 
                waa.username = ? 
                AND wa.id IS NULL; 
        `;
        const[results] = await pool.query(query, [username, username]);
        res.send(results);
    }
    catch(err){
        console.error('Error fetching assigned areas: ' + err.stack);
        res.status(500).json({ error: 'Database error' });
    }
};

exports.get_data_by_week = async(req,res) => {

    const {weekNumber,month,year} =req.params

    const query = `
    SELECT 
        wa.id AS audit_id,
        wa.main_area,
        wa.specific_area,
        wa.task_id,
        wa.audit_date,
        wa.week_number,
        wa.month,
        wa.year,
        wa.auditor_name,
        wa.auditor_phone,
        wa.suggestions,
        wa.submitted_at,
        wad.id AS detail_id,
        wad.question_number,
        wad.question,
        wad.remark,
        wad.image_path,
        wad.comment
    FROM 
        weekly_audits wa
    JOIN 
        weekly_audit_details wad
    ON 
        wa.id = wad.audit_id
    WHERE 
        wa.week_number = ? 
        AND wa.month = ? 
        AND wa.year = ?;
    `

try{
    const [results] = await pool.query(query,[weekNumber,month,year]);
    res.send(results);
}catch(err){
    console.error(err);
    res.status(500).json({ error: 'Database error in weekly data by weeknumber' });
}
};

exports.get_data_by_area_and_week = async (req, res) => {
    const { specific_area, weekNumber, month, year } = req.params;

    const query = `
        SELECT 
            wa.main_area,
            wa.specific_area,
            wa.task_id,
            wa.audit_date,
            wa.week_number,
            wa.month,
            wa.year,
            wa.auditor_name,
            wa.auditor_phone,
            wa.suggestions,
            wa.submitted_at,
            wad.question_number,
            wad.question,
            wad.remark,
            wad.image_path,
            wad.comment
        FROM 
            weekly_audits wa
        JOIN 
            weekly_audit_details wad
        ON 
            wa.id = wad.audit_id
        WHERE 
            wa.specific_area = ? 
            AND wa.week_number = ? 
            AND wa.month = ? 
            AND wa.year = ?;
    `;

    try {
        const [results] = await pool.query(query, [specific_area, weekNumber, month, year]);
        const groupedResults = results.reduce((acc, row) => {
            const {
                main_area,
                specific_area,
                task_id,
                audit_date,
                week_number,
                month,
                year,
                auditor_name,
                auditor_phone,
                suggestions,
                submitted_at,
                question_number,
                question,
                remark,
                image_path,
                comment
            } = row;

            const auditId = `${main_area}-${specific_area}-${task_id}-${audit_date}-${auditor_name}`;

            if (!acc[auditId]) {
                acc[auditId] = {
                    main_area,
                    specific_area,
                    task_id,
                    audit_date,
                    week_number,
                    month,
                    year,
                    auditor_name,
                    auditor_phone,
                    suggestions,
                    submitted_at,
                    audit_data: []
                };
            }

            acc[auditId].audit_data.push({
                question_number,
                question,
                remark,
                image_path,
                comment
            });

            return acc;
        }, {});

        const resultArray = Object.values(groupedResults);

        res.json(resultArray);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database error in getting audit data by specific area and week' });
    }
};

exports.get_all_areas = async () => {
    const queryMainAreas = 'SELECT id, main_area FROM main_areas';
    const querySpecificAreas = 'SELECT id, main_area_id, area_specific FROM specific_areas';

    try {
        const [mainAreas] = await pool.query(queryMainAreas);
        const [specificAreas] = await pool.query(querySpecificAreas);

        return {
            mainAreas,
            specificAreas
        };
    } catch (error) {
        console.error('Error retrieving areas:', error);
        throw error;
    }
};


exports.get_report_by_week = async (req, res) => {
    const { weekNumber, month, year } = req.params;

    try {
        // Fetch all areas
        const { mainAreas, specificAreas } = await exports.get_all_areas();

        // fetch weekly task id
        const taskQuery = `
            SELECT *
            FROM weekly_tasks
            WHERE weekNumber = ? 
              AND month = ? 
              AND year = ?;
        `;
        const [taskResults] = await pool.query(taskQuery, [weekNumber, month, year]);
        const taskData = taskResults.length > 0 ? taskResults[0] : { weekly_taskId: null };

        // Fetch audit data
        const query = `
            SELECT 
                wa.audit_date,
                wa.week_number,
                wa.month,
                wa.year,
                wa.task_id,
                wa.main_area AS audit_area,
                wa.specific_area,
                GROUP_CONCAT(wad.comment SEPARATOR ', ') AS report_observation,
                GROUP_CONCAT(wad.remark SEPARATOR ', ') AS remarks,
                GROUP_CONCAT(wad.image_path SEPARATOR ', ') AS images
            FROM 
                weekly_audits wa
            JOIN 
                weekly_audit_details wad
            ON 
                wa.id = wad.audit_id
            WHERE 
                wa.week_number = ? 
                AND wa.month = ? 
                AND wa.year = ?
            GROUP BY 
                wa.audit_date, 
                wa.week_number, 
                wa.month, 
                wa.year, 
                wa.task_id, 
                wa.main_area, 
                wa.specific_area;
        `;
        const [auditData] = await pool.query(query, [weekNumber, month, year]);

        const auditDataMap = new Map();
        auditData.forEach(audit => {
            const key = `${audit.audit_area}-${audit.specific_area}`;
            auditDataMap.set(key, {
                audit_date: audit.audit_date,
                report_observation: audit.report_observation,
                remarks: audit.remarks,
                images: audit.images
            });
        });


        const result = mainAreas.map(mainArea => {
            return {
                main_area: mainArea.main_area,
                task_id: taskData.weekly_taskId,
                specific_areas: specificAreas
                    .filter(specific => specific.main_area_id === mainArea.id)
                    .map(specific => {
                        const key = `${mainArea.main_area}-${specific.area_specific}`;
                        const audit = auditDataMap.get(key);
                        return {
                            specific_area: specific.area_specific,
                            audit_date: audit ? audit.audit_date : null,
                            report_observation: audit ? audit.report_observation : null,
                            remarks: audit ? audit.remarks : null,
                            images: audit ? audit.images : null
                        };
                    })
            };
        });

        res.send(result);
    } catch (err) {
        console.error('Error retrieving report data:', err);
        res.status(500).json({ error: 'Database error in getting audit data by week' });
    }
};

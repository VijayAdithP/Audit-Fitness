const pool = require('../config/db');
const { sendtaskupdate, sendNotification } = require('./notificationController');


exports.assign_specific_task = async (req, res) => {
    const {
        week_number, month, year, task_id, audit_date,
        main_area, specific_area, report_observation,
        specific_task_id, action_taken, status
    } = req.body;

    try {
        //check for repeated specific task id
        const checkTaskQuery = 'SELECT COUNT(*) AS count FROM specific_task_report WHERE specific_task_id = ?';
        const [taskResult] = await pool.query(checkTaskQuery, [specific_task_id]);
        if (taskResult[0].count > 0) {
            return res.status(400).json({ error: 'Specific task ID already exists' });
        }

        //check for repeated submission for same area at the same week
        const checkAreaQuery = `
            SELECT COUNT(*) AS count 
            FROM specific_task_report 
            WHERE week_number = ? AND month = ? AND year = ? AND specific_area = ?
        `;
        const [areaResult] = await pool.query(checkAreaQuery, [week_number, month, year, specific_area]);
        if (areaResult[0].count > 0) {
            return res.status(400).json({ error: 'A specific task id already exists for this week and specific area' });
        }

        //insert data
        const query = `
            INSERT INTO specific_task_report 
            (week_number, month, year, task_id, audit_date, main_area, specific_area, report_observation, specific_task_id, action_taken, status) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;

        const [results] = await pool.query(query, [
            week_number, month, year, task_id, audit_date,
            main_area, specific_area, report_observation,
            specific_task_id, action_taken, status
        ]);

        const message = `Task ID assigned for ${specific_area}. Kindly update the progress.`;

        const [userRows] = await pool.query(`
            SELECT DISTINCT ut.fcmtoken
            FROM users u
            JOIN user_tokens ut ON u.username = ut.username
            WHERE u.role = 3
        `);

        const tokens = userRows.map(row => row.fcmtoken);

        if (tokens.length > 0) {
            await sendNotification(tokens, message);
        }

        res.status(201).json({ message: 'Data submitted successfully'});

    } catch (error) {
        console.error('Error processing request:', error);
        res.status(400).json({ error: error.message });
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

// exports.get_report_by_week = async (req, res) => {
//     const { weekNumber, month, year } = req.params;

//     try {
//         // Fetch all areas
//         const { mainAreas, specificAreas } = await exports.get_all_areas();

//         // fetch weekly task id
//         const taskQuery = `
//             SELECT *
//             FROM weekly_tasks
//             WHERE weekNumber = ? 
//               AND month = ? 
//               AND year = ?;
//         `;
//         const [taskResults] = await pool.query(taskQuery, [weekNumber, month, year]);
//         const taskData = taskResults.length > 0 ? taskResults[0] : { task_id: null };

//         // Fetch specific task data
//         const query = `
//             SELECT 
//                 sp.week_number,
//                 sp.month,
//                 sp.year,
//                 sp.task_id,
//                 sp.audit_date,
//                 sp.main_area,
//                 sp.specific_area,
//                 sp.report_observation,
//                 sp.specific_task_id,
//                 sp.action_taken,
//                 sp.status
//             FROM 
//                 specific_task_report sp
//             WHERE 
//                 sp.week_number = ? 
//                 AND sp.month = ? 
//                 AND sp.year = ?
//         `;
//         const [auditData] = await pool.query(query, [weekNumber, month, year]);

//         const auditDataMap = new Map();
//         auditData.forEach(audit => {
//             const key = `${audit.task_id}-${audit.main_area}`;
//             if (!auditDataMap.has(key)) {
//                 auditDataMap.set(key, {
//                     task_id: taskData.weekly_taskId,
//                     main_area: audit.main_area,
//                     specific_areas: []
//                 });
//             }
//             const specificAreaData = auditDataMap.get(key).specific_areas;
//             const existingSpecificArea = specificAreaData.find(sa => sa.specific_area === audit.specific_area);
//             if (existingSpecificArea) {
//                 existingSpecificArea.audit_date = audit.audit_date;
//                 existingSpecificArea.report_observation = audit.report_observation;
//                 existingSpecificArea.specific_task_id = audit.specific_task_id;
//                 existingSpecificArea.action_taken = audit.action_taken;
//                 existingSpecificArea.status = audit.status;
//             } else {
//                 specificAreaData.push({
//                     specific_area: audit.specific_area,
//                     audit_date: audit.audit_date,
//                     report_observation: audit.report_observation,
//                     specific_task_id: audit.specific_task_id,
//                     action_taken: audit.action_taken,
//                     status: audit.status
//                 });
//             }
//         });

//         // Format data
//         const result = mainAreas.map(mainArea => {
//             const taskKey = Array.from(auditDataMap.keys()).find(key => key.includes(mainArea.main_area));
//             if (taskKey) {
//                 return auditDataMap.get(taskKey);
//             } else {
//                 return {
//                     task_id: null,
//                     main_area: mainArea.main_area,
//                     specific_areas: specificAreas
//                         .filter(specific => specific.main_area_id === mainArea.id)
//                         .map(specific => ({
//                             specific_area: specific.area_specific,
//                             audit_date: null,
//                             report_observation: null,
//                             specific_task_id: null,
//                             action_taken: null,
//                             status: null
//                         }))
//                 };
//             }
//         });

//         res.send(result);
//     } catch (err) {
//         console.error('Error retrieving report data:', err);
//         res.status(500).json({ error: 'Database error in getting specific task report data by week' });
//     }
// };


exports.get_report_by_week = async (req, res) => {
    const { weekNumber, month, year } = req.params;

    try {
        //all areas
        const { mainAreas, specificAreas } = await exports.get_all_areas();

        //weekly task id
        const taskQuery = `
            SELECT *
            FROM weekly_tasks
            WHERE weekNumber = ? 
              AND month = ? 
              AND year = ?;
        `;
        const [taskResults] = await pool.query(taskQuery, [weekNumber, month, year]);
        const taskData = taskResults.length > 0 ? taskResults[0] : { weekly_taskId: null };

        //audit data
        const auditQuery = `
            SELECT 
                wa.audit_date,
                wa.week_number,
                wa.month,
                wa.year,
                wa.main_area AS audit_area,
                wa.specific_area,
                GROUP_CONCAT(wad.comment SEPARATOR ', ') AS report_observation
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
        const [auditData] = await pool.query(auditQuery, [weekNumber, month, year]);

        //specific task report data
        const taskReportQuery = `
            SELECT 
                week_number,
                month,
                year,
                task_id,
                audit_date,
                main_area,
                specific_area,
                report_observation,
                specific_task_id,
                action_taken,
                status
            FROM 
                specific_task_report
            WHERE 
                week_number = ? 
                AND month = ? 
                AND year = ?;
        `;
        const [taskReportData] = await pool.query(taskReportQuery, [weekNumber, month, year]);

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

        const taskReportMap = new Map();
        taskReportData.forEach(report => {
            const key = `${report.main_area}-${report.specific_area}`;
            taskReportMap.set(key, {
                audit_date: report.audit_date,
                report_observation: report.report_observation,
                specific_task_id: report.specific_task_id,
                action_taken: report.action_taken,
                status: report.status
            });
        });

        const result = mainAreas.map(mainArea => {
            return {
                task_id: taskData.weekly_taskId,
                main_area: mainArea.main_area,
                specific_areas: specificAreas
                    .filter(specific => specific.main_area_id === mainArea.id)
                    .map(specific => {
                        const key = `${mainArea.main_area}-${specific.area_specific}`;
                        const audit = auditDataMap.get(key) || {};
                        const taskReport = taskReportMap.get(key) || {};
                        return {
                            specific_area: specific.area_specific,
                            audit_date: audit.audit_date || taskReport.audit_date || null,
                            report_observation: audit.report_observation || taskReport.report_observation || null,
                            specific_task_id: taskReport.specific_task_id || null,
                            action_taken: taskReport.action_taken || null,
                            status: taskReport.status || null
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

exports.pending_tasks = async (req,res) => {
    const query = `SELECT * FROM specific_task_report WHERE status = 'In Progress'`

    try{
        const [results] = await pool.query(query);
        res.send(results);
    }catch(err){
        console.error('Error retrieving the pending report data:', err);
        res.status(500).json({ error: 'Database error in getting specific task report data ' }); 
    }
};

exports.update_progress = async (req, res) => {
    const { taskId, newProgress } = req.body;

    if (!taskId || !newProgress) {
        return res.status(400).send({ message: 'Both taskId and newProgress must be provided.' });
    }

    try {
        const updateQuery = 'UPDATE specific_task_report SET status = ? WHERE specific_task_id = ?';
        const [updateResult] = await pool.query(updateQuery, [newProgress, taskId]);

        if (updateResult.affectedRows === 0) {
            return res.status(404).send({ message: 'Task not found' });
        }

        const fetchQuery = 'SELECT * FROM specific_task_report WHERE specific_task_id = ?';
        const [fetchResult] = await pool.query(fetchQuery, [taskId]);

        if (fetchResult.length === 0) {
            return res.status(404).send({ message: 'Task not found' });
        }

        const [adminRows] = await pool.query(`
            SELECT DISTINCT ut.fcmtoken
            FROM users u
            JOIN user_tokens ut ON u.username = ut.username
            WHERE u.role = 1
        `);

        const tokens = adminRows.map(row => row.fcmtoken);

        if (tokens.length > 0) {
            const notificationMessage = `Task ID: ${taskId} progress has been updated`;
            await sendtaskupdate(tokens, notificationMessage);
        }

        res.status(200).send({message:'Task Updated Successfully!'})
        // res.send(fetchResult[0]);
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).send({ message: 'Database error', error: error.message });
    }
};
const pool = require('../config/db');
const multer = require('multer');
const upload = require('../middleware/multerConfig'); 
const { sendNotification } = require('./notificationController');


//daily
exports.storeAuditData = async (req, res) => {
    const {
        main_area,
        specific_area,
        task_id,
        audit_date,
        auditor_name,
        auditor_phone,
        suggestions,
        audit_details 
    } = req.body;

    try {
        const auditQuery = 'INSERT INTO submitted_audits (main_area, specific_area, task_id, audit_date, auditor_name, auditor_phone, suggestions) VALUES (?, ?, ?, ?, ?, ?, ?)';
        const [auditResult] = await pool.query(auditQuery, [main_area, specific_area, task_id, audit_date, auditor_name, auditor_phone, suggestions]);
        const auditId = auditResult.insertId;

        const parsedAuditDetails = JSON.parse(audit_details);

        const fileMapping = {};
        if (req.files) {
            req.files.forEach(file => {
                const match = file.fieldname.match(/image_(\d+)/);
                if (match) {
                    const questionNumber = parseInt(match[1], 10);
                    fileMapping[questionNumber] = file.path;
                }
            });
        }

        parsedAuditDetails.sort((a, b) => a.question_number - b.question_number);

        for (const detail of parsedAuditDetails) {
            const { question_number, question, remark, comment } = detail;
            const image_path = fileMapping[question_number] || null;

            const detailsQuery = 'INSERT INTO submitted_audit_details (audit_id, question_number, question, remark, image_path, comment) VALUES (?, ?, ?, ?, ?, ?)';
            await pool.query(detailsQuery, [auditId, question_number, question, remark, image_path, comment]);
        }

        res.status(200).send('Daily Audit data stored successfully');
    } catch (error) {
        console.error('Error storing daily audit data:', error);
        res.status(500).send('Error storing daily audit data');
    }
};



//weekly
exports.WeekAuditData = async (req, res) => {
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
        audit_details 
    } = req.body;

    try {
        const auditQuery = 'INSERT INTO weekly_audits (main_area, specific_area, task_id, audit_date, week_number, month, year, auditor_name, auditor_phone, suggestions) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ? , ?)';
        const [auditResult] = await pool.query(auditQuery, [main_area, specific_area, task_id, audit_date, week_number, month, year, auditor_name, auditor_phone, suggestions]);
        const auditId = auditResult.insertId;

        const parsedAuditDetails = JSON.parse(audit_details);

        const fileMapping = {};
        if (req.files) {
            req.files.forEach(file => {
                const match = file.fieldname.match(/image_(\d+)/);
                if (match) {
                    const questionNumber = parseInt(match[1], 10);
                    fileMapping[questionNumber] = file.path;
                }
            });
        }

        parsedAuditDetails.sort((a, b) => a.question_number - b.question_number);

        for (const detail of parsedAuditDetails) {
            const { question_number, question, remark, comment } = detail;
            const image_path = fileMapping[question_number] || null;

            const detailsQuery = 'INSERT INTO weekly_audit_details (audit_id, question_number, question, remark, image_path, comment) VALUES (?, ?, ?, ?, ?, ?)';
            await pool.query(detailsQuery, [auditId, question_number, question, remark, image_path, comment]);
        }

        const [adminRows] = await pool.query(`
            SELECT DISTINCT ut.fcmtoken
            FROM users u
            JOIN user_tokens ut ON u.username = ut.username
            WHERE u.role = 1
        `);

        const tokens = adminRows.map(row => row.fcmtoken);

        if (tokens.length > 0) {
            const notificationMessage = `A new weekly audit data has been stored. Task ID: ${task_id}`;
            await sendNotification(tokens, notificationMessage);
        }

        res.status(200).send('Weekly Audit data stored successfully');
    } catch (error) {
        console.error('Error storing weekly audit data:', error);
        res.status(500).send('Error storing weekly audit data');
    }
};

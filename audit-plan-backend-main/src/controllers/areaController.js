const pool = require('../config/db');

exports.remote_area_weekly = async (req, res) => {
    try{
        const query= 'SELECT * FROM remote_area_weekly'
        const [results] = await pool.query(query);
        res.send(results);
    }
    catch(err){
        console.log("Error in Remote area Weekly",err);
        res.send("Error in remote area weekly: ", err);
    }
};

//post main areas
exports.post_main_areas = async (req,res) => {
    const { main_area } = req.body;

    try{
        const query = 'INSERT INTO main_areas (main_area) VALUES (?)';
        const [result] = await pool.query(query,[main_area]);
        res.send('Main Area Inserted successfully!')
    }catch(err){
        console.error('Error inserting into main_areas:', err);
        res.status(500).send('Error inserting into main_areas.');
    }
};

//post specific areas
exports.post_specific_areas = async(req, res) => {
    const { main_area_id, area_specific, area_specific_tamil } = req.body;

    try{
        const query = 'INSERT INTO specific_areas (main_area_id, area_specific, area_specific_tamil) VALUES (?, ?, ?)';
        const result = await pool.query(query,[main_area_id, area_specific,area_specific_tamil]);
        res.send("Inserted into specific_areas successfully.")
    }catch(error){
        console.error('Error inserting into specific_areas:', error);
        res.status(500).send('Error inserting into specific_areas.');
    }
};

//post questions
exports.post_questions = async (req,res) => {
    const { specific_area_id, question_number, question, question_tamil } = req.body;

    try{
        const query = 'INSERT INTO questions (specific_area_id, question_number, question, question_tamil) VALUES (?, ?, ?, ?)';
        const results = await pool.query(query,[specific_area_id,question_number,question,question_tamil]);
        res.send("Questions Inserted Succesfully!");
    }catch(error){
        console.error('Error inserting into questions:', error);
        res.status(500).send('Error inserting into questions.');
    }
};

//post main area, specific area and its questions
exports.area_register = async(req,res) => {
    const { main_area, area_specific, area_specific_tamil, questions } = req.body;

    try{
        //check main area
        const checkMainAreaQuery = 'SELECT id FROM main_areas WHERE main_area = ?';
        const [resMainAreaCheck] = await pool.query(checkMainAreaQuery, [main_area]);

        let mainAreaId;

        //insert main area
        if (resMainAreaCheck.length > 0) {
            // Main area exists, use the existing ID
            mainAreaId = resMainAreaCheck[0].id;
        }else{
        const mainAreaQuery = 'INSERT INTO main_areas (main_area) VALUES (?)';
        const [resmain] = await pool.query(mainAreaQuery,[main_area]);
        mainAreaId = resmain.insertId;
        }

        //check for duplication of specific areas
        const checkQuery = 'SELECT * FROM specific_areas WHERE area_specific = ?'
        const [resCheckQuery] = await pool.query(checkQuery,[area_specific]);

        if (resCheckQuery.length > 0){
            return res.status(409).send({message : "This Specific area with Questions already exist!"})
        }

        // Insert specific area into specific_areas table
        const specificAreaQuery = 'INSERT INTO specific_areas (main_area_id, area_specific, area_specific_tamil) VALUES (?, ?, ?)';
        const [resultSpecific] = await pool.query(specificAreaQuery, [mainAreaId, area_specific, area_specific_tamil]);
        const specificAreaId = resultSpecific.insertId;

        // Insert questions into questions table
        const questionsInserts = questions.map((question, index) => {
            return [
            specificAreaId,
            index + 1, 
            question.question,
            question.question_tamil
            ];
        });

        const questionsQuery = 'INSERT INTO questions (specific_area_id, question_number, question, question_tamil) VALUES ?';
        const [resultQues] = await pool.query(questionsQuery, [questionsInserts]);

        res.status(200).send("Form Submitted Successfully!");
    }catch(error){
        console.error('Error inserting Form Data:', error);
        res.status(500).send('Error inserting Form Data.');
    }
};

//get area name
exports.main_area = async(req,res) => {
    try{
        const query = 'SELECT * FROM main_areas';
        const [results] = await pool.query(query);
        res.send(results);
    }catch(error){
        console.error('Error in fetching main areas', error);
        res.status(500).send('Error in fetching main areas');
    }
};
//get main area by specific area
exports.main_area_bySpec = async(req,res) => {
    const { area_specific } = req.query;

    try{
        const query = `
            SELECT ma.main_area
            FROM main_areas ma
            JOIN specific_areas sa ON ma.id = sa.main_area_id
            WHERE sa.area_specific = ?;
        `;
        const [results] = await pool.query(query,[area_specific]);
        res.send(results);
    }catch(error){
        console.error('Error in fetching main area by specific area', error);
        res.status(500).send('Error in fetching main area by specific area');
    }
};  


//get specific areas
exports.specific_areas = async(req,res) => {
    try{
        const query = 'SELECT * FROM specific_areas';
        const [results] = await pool.query(query);
        res.send(results);
    }catch(error){
        console.error('Error in fetching specific_areas ', error);
        res.status(500).send('Error in fetching specific_areas ');
    }
};

//get questions
exports.questions = async (req,res) => {
    try{
        const query = 'SELECT * FROM questions';
        const [results] = await pool.query(query);
        res.send(results);
    }catch(error){
        console.error('Error in fetching questions ', error);
        res.status(500).send('Error in fetching questions ');
    }
};

//get question by specific area
exports.questionBySpecArea = async(req,res) => {
    const { area_specific } = req.query;
    try{
        const query = `
            SELECT id
            FROM specific_areas
            WHERE area_specific = ?
        `;
        const [specificArea] = await pool.query(query, [area_specific]);

        if (specificArea.length === 0) {
            return res.status(404).json({ error: 'Specific area not found' });
        }

        const specificAreaId = specificArea[0].id;

        const questionsQuery = `
            SELECT *
            FROM questions
            WHERE specific_area_id = ?
            ORDER BY question_number ASC
        `;
        const [questions] = await pool.query(questionsQuery, [specificAreaId]);

        res.send(questions);
    }catch (error) {
        console.error('Error fetching questions:', error);
        res.status(500).json({ error: 'Error fetching questions' });
    }
};

//get area report by specific area and date
exports.report_by_spec_areadate = async (req, res) => {
    try {
        const { specific_area, audit_date } = req.params;

        if (!specific_area || !audit_date) {
            return res.status(400).json({ error: 'specific_area and audit_date are required' });
        }

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
                AND wa.audit_date = ?;
        `;

        const [results] = await pool.query(query, [specific_area, audit_date]);

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
    } catch (error) {
        console.error('Error fetching audit data:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};

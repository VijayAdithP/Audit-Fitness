const puppeteer = require('puppeteer');
const path = require('path');


exports.generate_report =async (req, res) =>{
    try {
        const { totalAreasCovered, totalObservationsFound, date, taskId, analysisWeek, auditsData } = req.body;

        const browser = await puppeteer.launch({
            headless: true, 
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        const page = await browser.newPage();

        const formatReportObservation = (observation) => {
            return observation
                .split(',') 
                .map(item => item.trim()) 
                .filter(item => item.length > 0) 
                .join('<br>'); 
        };

        let htmlContent = `
            <html>
            <head>
                <title>Report</title>
                <style>
                    @page {
                        margin: 1cm; 
                    }
                    body {
                        margin: 1cm; 
                        padding: 0;
                        box-sizing: border-box;
                    }
                    table {
                        border-collapse: collapse;
                        width: 100%;
                    }
                    th, td {
                        border: 1px solid black;
                        padding: 8px;
                        text-align: left;
                        page-break-inside: avoid;
                        page-break-after: auto;
                    }
                    th {
                        background-color: #f2f2f2;
                    }
                    img {
                        display: block;
                        margin-left: auto;
                        margin-right: auto;
                        width: 50%; 
                    }
                    tr:last-child {
                        border-bottom: 1px solid black;
                    }
                </style>
            </head>
            <body>
            <img src="http://localhost:8001/pdf/pdf/logo.png" alt="Logo">
            <h2 style="text-align:center">Office of the IQAC</h2>
            <h3 style="text-align:center">Remote Area Analysis Report - ${analysisWeek}</h3>
            <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                <div>Audit Date: ${date}</div>
                <div>Task ID: ${taskId}</div>
            </div>
            <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                <div>Total Areas Covered: ${totalAreasCovered}</div>
                <div>Total Observations Found: ${totalObservationsFound}</div>
            </div>
                <table>
                    <thead>
                        <tr>
                            <th>Serial Number</th>
                            <th>Audit Area</th>
                            <th>Specific Area</th>
                            <th>Report Observation</th>
                            <th>Remarks</th>
                        </tr>
                    </thead>
                    <tbody>
        `;

        // Generate table rows 
        auditsData.forEach((areaData, areaIndex) => {
            const { main_area, specific_areas } = areaData;

            specific_areas.forEach((specificArea, specificIndex) => {
                const rowspan = specific_areas.length; // Rowspan for the main area

                if (specificIndex === 0) {
                    // First item of the specific areas for the main area
                    htmlContent += `
                        <tr>
                            <td rowSpan="${rowspan}">${areaIndex + 1}</td>
                            <td rowSpan="${rowspan}">${main_area}</td>
                            <td>${specificArea.specific_area}</td>
                            <td>${specificArea.report_observation}</td>
                            <td>${specificArea.remarks}</td>
                        </tr>
                    `;
                } else {
                    // Subsequent items of the same area
                    htmlContent += `
                        <tr>
                            <td>${specificArea.specific_area}</td>
                            <td>${specificArea.report_observation}</td>
                            <td>${specificArea.remarks}</td>
                        </tr>
                    `;
                }
            });
        });

        htmlContent += `
                    </tbody>
                </table>
            </body>
            </html>
        `;

        await page.setContent(htmlContent);
        const pdf = await page.pdf({ format: 'A4', landscape: true });

        await browser.close();

        res.set({
            'Content-Type': 'application/pdf',
            'Content-Length': pdf.length,
        });
        res.send(pdf);
    } catch (error) {
        console.error('Error generating PDF:', error);
        res.status(500).send('Error generating PDF');
    } 
};



exports.generate_specific_task_report =async (req, res) =>{
    try {
        const { totalAreasCovered, totalObservationsFound, date, taskId, analysisWeek, auditsData } = req.body;

        const browser = await puppeteer.launch({
            headless: true, 
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        const page = await browser.newPage();

        const formatReportObservation = (observation) => {
            return observation
                .split(',') 
                .map(item => item.trim()) 
                .filter(item => item.length > 0) 
                .join('<br>'); 
        };

        let htmlContent = `
            <html>
            <head>
                <title>Report</title>
                <style>
                    @page {
                        margin: 1cm; 
                    }
                    body {
                        margin: 1cm; 
                        padding: 0;
                        box-sizing: border-box;
                    }
                    table {
                        border-collapse: collapse;
                        width: 100%;
                    }
                    th, td {
                        border: 1px solid black;
                        padding: 8px;
                        text-align: left;
                        page-break-inside: avoid;
                        page-break-after: auto;
                    }
                    th {
                        background-color: #f2f2f2;
                    }
                    img {
                        display: block;
                        margin-left: auto;
                        margin-right: auto;
                        width: 50%; 
                    }
                    tr:last-child {
                        border-bottom: 1px solid black;
                    }
                </style>
            </head>
            <body>
            <img src="http://localhost:8001/pdf/pdf/logo.png" alt="Logo">
            <h2 style="text-align:center">Office of the IQAC</h2>
            <h3 style="text-align:center">Remote Area Action Taken Report - ${analysisWeek}</h3>
            <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                <div>Audit Date: ${date}</div>
                <div>Task ID: ${taskId}</div>
            </div>
            <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                <div>Total Areas Covered: ${totalAreasCovered}</div>
                <div>Total Observations Found: ${totalObservationsFound}</div>
            </div>
                <table>
                    <thead>
                        <tr>
                            <th>Serial Number</th>
                            <th>Audit Area</th>
                            <th>Specific Area</th>
                            <th>Report Observation</th>
                            <th>Specific Task ID</th>
                            <th>Action Taken</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
        `;

        // Generate table rows 
        auditsData.forEach((areaData, areaIndex) => {
            const { main_area, specific_areas } = areaData;

            specific_areas.forEach((specificArea, specificIndex) => {
                const rowspan = specific_areas.length; // Rowspan for the main area

                if (specificIndex === 0) {
                    // First item of the specific areas for the main area
                    htmlContent += `
                        <tr>
                            <td rowSpan="${rowspan}">${areaIndex + 1}</td>
                            <td rowSpan="${rowspan}">${main_area}</td>
                            <td>${specificArea.specific_area}</td>
                            <td>${specificArea.report_observation}</td>
                            <td>${specificArea.specific_task_id}</td>
                            <td>${specificArea.action_taken}</td>
                            <td>${specificArea.status}</td>
                        </tr>
                    `;
                } else {
                    // Subsequent items of the same area
                    htmlContent += `
                        <tr>
                            <td>${specificArea.specific_area}</td>
                            <td>${specificArea.report_observation}</td>
                            <td>${specificArea.specific_task_id}</td>
                            <td>${specificArea.action_taken}</td>
                            <td>${specificArea.status}</td>
                        </tr>
                    `;
                }
            });
        });

        htmlContent += `
                    </tbody>
                </table>
            </body>
            </html>
        `;

        await page.setContent(htmlContent);
        const pdf = await page.pdf({ format: 'A4', landscape: true });

        await browser.close();

        res.set({
            'Content-Type': 'application/pdf',
            'Content-Length': pdf.length,
        });
        res.send(pdf);
    } catch (error) {
        console.error('Error generating PDF:', error);
        res.status(500).send('Error generating PDF');
    } 
};


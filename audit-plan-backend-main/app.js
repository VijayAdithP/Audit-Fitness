const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const app = express();
const pool = require('./src/config/db');
const path = require('path');

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use('/uploads/images', express.static('uploads/images'));
app.use('/pdf/pdf', express.static(path.join(__dirname, 'pdf', 'pdf')));



const authRoutes = require('./src/routes/authRoutes');
const dailyRoutes = require('./src/routes/dailyRoutes');
const weeklyRoutes = require('./src/routes/weeklyRoutes');
const userRoutes = require('./src/routes/userRoutes');
const areaRoutes = require('./src/routes/areaRoutes');
const auditDataRoutes = require('./src/routes/auditDataRoutes.js');
const pdfRoutes = require('./src/routes/pdfRoutes.js');
const specificTaskRoutes = require('./src/routes/specificTaskRoutes.js');
const tokenRoutes = require('./src/routes/tokenRoutes.js');
const notificationRoutes = require('./src/routes/notificationRoutes.js');

app.use(authRoutes);
app.use(dailyRoutes);
app.use(weeklyRoutes);
app.use(userRoutes);
app.use(areaRoutes);
app.use(auditDataRoutes);
app.use(pdfRoutes);
app.use(specificTaskRoutes);
app.use(tokenRoutes);
app.use(notificationRoutes);





app.get('/', (req, res) => {
    res.send('Welcome to Audit Plan Management Server!');
});

const PORT = process.env.PORT || 8001;
const server = app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

// Handle graceful shutdown
const shutdown = () => {
    console.log('SIGTERM or SIGINT signal received: closing HTTP server');
    server.close(() => {
        console.log('HTTP server closed');
        pool.end(err => {
            if (err) {
                console.error('Error closing database pool:', err);
            } else {
                console.log('Database pool closed');
            }
        });
    });
};

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);


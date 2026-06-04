require('dotenv').config({ quiet: true });

const mysql = require('mysql2');

const db = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'crm_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

db.getConnection((err, connection) => {
  if (err) {
    console.error('Error al conectar a la base de datos:', err.message);
    return;
  }

  connection.release();
  console.log('Conexión a la base de datos exitosa');
});

module.exports = db;

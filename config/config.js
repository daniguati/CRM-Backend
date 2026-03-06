// config.js
const mysql = require('mysql2');

// Configuración de la base de datos
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root', // Tu usuario de MySQL (en XAMPP generalmente es 'root')
  password: '', // Si no tienes contraseña, déjalo vacío, si tienes, ponla aquí
  database: 'crm_db' // El nombre de la base de datos que acabamos de crear
});

db.connect(err => {
  if (err) {
    console.error('Error al conectar a la base de datos:', err.stack);
    return;
  }
  console.log('Conexión a la base de datos exitosa');
});

module.exports = db;
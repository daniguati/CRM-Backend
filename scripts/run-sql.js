const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');
require('dotenv').config({
  path: path.resolve(__dirname, '..', '.env'),
  quiet: true
});

const sqlFile = process.argv[2];

if (!sqlFile) {
  console.error('Uso: node scripts/run-sql.js database/schema.sql');
  process.exit(1);
}

const sqlPath = path.resolve(process.cwd(), sqlFile);
const sql = fs.readFileSync(sqlPath, 'utf8');

async function main() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || '127.0.0.1',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    multipleStatements: true
  });

  await connection.query(sql);
  await connection.end();

  console.log(`SQL ejecutado correctamente: ${sqlFile}`);
}

main().catch((error) => {
  console.error('Error al ejecutar SQL:', error.message);
  process.exit(1);
});

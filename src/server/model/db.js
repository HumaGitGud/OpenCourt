const mysql = require('mysql2')

const path = require('path');
// Try to load a repository-level .env if present (harmless if missing).
require('dotenv').config({ path: path.resolve(__dirname, '../../../.env') });

// Provide safe defaults so the container can connect to the DB service when
// environment variables are not provided (e.g. during local Docker Compose runs).
const db = mysql.createPool({
  host: process.env.DB_HOST || 'db',
  user: process.env.DB_USER || 'opencourt_user',
  password: process.env.DB_PASSWORD || 'password',
  database: process.env.DB_NAME || 'opencourt',
  port: process.env.DB_PORT ? Number(process.env.DB_PORT) : 3306
}).promise();

module.exports = db;
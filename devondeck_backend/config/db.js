
const { Pool } = require("pg");
require("dotenv").config();

// Connexion mta3na b PostgreSQL
const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});

// Nexportiw el connexion bech nesta3mlouha fi les autres fichiers
module.exports = pool;

// db.js
const mysql = require('mysql');

const connection = mysql.createConnection({
  host: 'z4v.h.filess.io',
  user: 'guruku_shakingpen', // ganti dengan user database Anda
  password: 'c61b07749f79e34bb0c6654efe2d2d8849237a62', // ganti dengan password database Anda
  database: 'guruku_shakingpen',
  port: 3307 // ganti dengan nama database Anda
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Connected to the database');
});

module.exports = connection;

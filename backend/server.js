const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(cors());

// Přihlašovací údaje do našeho Dockeru
const pool = new Pool({
  user: 'admin',
  host: 'localhost',
  database: 'bod_app',
  password: 'heslo123',
  port: 5432,
});

// Zde definujeme adresu, na kterou se bude ptát tvůj Flutter
app.get('/api/body', async (req, res) => {
  try {
    const vysledek = await pool.query('SELECT * FROM body_zajmu');
    res.json(vysledek.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Chyba serveru');
  }
});

app.listen(3000, () => {
  console.log('API Server běží! Flutter se může ptát na adrese http://localhost:3000/api/body');
});
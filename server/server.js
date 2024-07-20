const express = require('express');
const bodyParser = require('body-parser');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const db = require('./db');
const bcrypt = require('bcrypt');

const app = express();
app.use(bodyParser.json());

// Rute untuk menambahkan pengguna baru
app.post('/register', (req, res) => {
  const { nama, email, role, password, mata_pelajaran, nohp, kualifikasi, alamat, foto_profil } = req.body;

  if (!nama || !email || !role || !password) {
    return res.status(400).send({ message: 'All fields are required' });
  }

  // Cek apakah email sudah ada
  const checkEmailQuery = 'SELECT * FROM users WHERE email = ?';
  db.query(checkEmailQuery, [email], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error checking email' });
    }

    if (results.length > 0) {
      return res.status(400).send({ message: 'Email sudah ada' });
    }

    // Hash password
    bcrypt.hash(password, 10, (err, hash) => {
      if (err) {
        console.error('Error hashing password:', err);
        return res.status(500).send({ message: 'Error hashing password' });
      }

      // Jika email belum ada, tambahkan pengguna baru
      const query = 'INSERT INTO users (nama, email, role, password, mata_pelajaran, nohp, kualifikasi, alamat,foto_profil) VALUES (?, ?, ?, ?, ?, ?,?,?,?)';
      db.query(query, [nama, email, role, hash, mata_pelajaran, nohp, kualifikasi, alamat, foto_profil], (err, result) => {
        if (err) {
          console.error('Error executing query:', err);
          return res.status(500).send({ message: 'Error adding user' });
        }
        res.status(201).send({ role });
      });
    });
  });
});

app.post('/forgot', async (req, res) => {
  const { email } = req.body;
  
  const query = 'SELECT email FROM users WHERE email = ?';
  db.query(query, [email], (err, result) => { // Changed `res` to `result`
    if(err){
      return res.status(500).send({message: 'Terjadi kesalahan'});
    }
    if(result.length == 0){ // Changed `res` to `result`
      return res.status(404).send({message: 'Email tidak ditemukan'});
    }
    res.status(200).send({message: 'Berhasil'});
  });
  
});


app.post('/booking', async (req, res) => {
  const { id_siswa, id_guru, mata_pelajaran, tanggal, status } = req.body;
  const query = 'INSERT INTO booking (id_siswa, id_guru,mata_pelajaran, tanggal, status) VALUES (?,?,?,?,?)';
  db.query(query, [id_siswa, id_guru, mata_pelajaran, tanggal, status], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching tarif' });
    }
    res.status(200).send(results);
  });
});

app.post('/jadwal', (req, res) => {
  const { id_guru, tanggal } = req.body;
  const query = 'INSERT INTO jadwal (id_guru,tanggal) VALUES (?,?)';
  db.query(query, [id_guru, tanggal], (err, result) => {
    if (err) {
      return res.status(500).send({ message: 'Error' });
    }
    res.status(200).send(result);
  });
});

app.get('/jadwal', (req, res) => {
  const { id_guru } = req.body;
  const query = 'SELECT * FROM jadwal WHERE id_guru = ?';
  db.query(query, [id_guru], (err, result) => {
    if (err) {
      return res.status(500).send({ message: 'Error' });
    }
    res.status(200).send(result);
  });
});

app.post('/booking/terima', async (req, res) => {
  const { id, status } = req.body;
  const query = 'UPDATE booking SET status = ? WHERE id = ?';
  db.query(query, [status, id], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching tarif' });
    }
    res.status(200).send(results);
  });
});

app.post('/booking/selesai', async (req, res) => {
  const { id, status } = req.body;
  const query = 'UPDATE booking SET status = ? WHERE id = ?';
  db.query(query, [status, id], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching tarif' });
    }
    res.status(200).send(results);
  });
});

app.get('/booking', async (req, res) => {
  const { id } = req.body;
  const query = 'SELECT * FROM booking WHERE id_siswa = ?';
  db.query(query, [id], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching tarif' });
    }
    res.status(200).send(results);
  });
});

app.get('/booking/guru', async (req, res) => {
  const { id, status } = req.body;
  const query = 'SELECT * FROM booking WHERE id_guru = ? AND status = ?';
  db.query(query, [id, status], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching tarif' });
    }
    res.status(200).send(results);
  });
});

app.get('/booking/guru/riwayat', async (req, res) => {
  const { id, status } = req.body;
  const query = 'SELECT * FROM booking WHERE id_guru = ? AND status != ?';
  db.query(query, [id, status], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching tarif' });
    }
    res.status(200).send(results);
  });
});

// Rute untuk login
app.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).send({ message: 'Email and password are required' });
  }

  // Cek apakah email ada di database
  const query = 'SELECT * FROM users WHERE email = ?';
  db.query(query, [email], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error checking email' });
    }

    if (results.length === 0) {
      return res.status(401).send({ message: 'Email tidak ditemukan' });
    }

    const user = results[0];

    // Bandingkan password
    bcrypt.compare(password, user.password, (err, isMatch) => {
      if (err) {
        console.error('Error comparing passwords:', err);
        return res.status(500).send({ message: 'Error comparing passwords' });
      }

      if (!isMatch) {
        return res.status(400).send({ message: 'Password salah' });
      }

      // Jika login berhasil
      res.status(200).send({ message: 'Login berhasil', role: user.role });
    });
  });
});




app.put('/update', (req, res) => {
  const { email, nama, alamat, nohp } = req.body;

  if (!email || !nama || !alamat || !nohp) {
    return res.status(400).send({ message: 'All fields are required' });
  }

  // Update user information based on email
  const query = 'UPDATE users SET nama = ?, alamat = ?, nohp = ? WHERE email = ?';
  db.query(query, [nama, alamat, nohp, email], (err, result) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error updating user information' });
    }

    if (result.affectedRows === 0) {
      return res.status(400).send({ message: 'Email not found' });
    }

    res.status(200).send({ message: 'User information updated successfully' });
  });
});

app.put('/update/guru', (req, res) => {
  const { email, nama, alamat, nohp, mata_pelajaran } = req.body;

  if (!email || !nama || !alamat || !nohp || !mata_pelajaran) {
    return res.status(400).send({ message: 'All fields are required' });
  }

  // Update user information based on email
  const query = 'UPDATE users SET nama = ?, alamat = ?, nohp = ?, mata_pelajaran = ? WHERE email = ?';
  db.query(query, [nama, alamat, nohp, mata_pelajaran, email], (err, result) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error updating user information' });
    }

    if (result.affectedRows === 0) {
      return res.status(400).send({ message: 'Email not found' });
    }

    res.status(200).send({ message: 'User information updated successfully' });
  });
});

app.get('/user', (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).send({ message: 'Email is required' });
  }

  const query = 'SELECT * FROM users WHERE email = ?';
  db.query(query, [email], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching user information' });
    }

    if (results.length === 0) {
      return res.status(400).send({ message: 'Email not found' });
    }

    const user = results[0];
    res.status(200).send(user);
  });
});

app.get('/userid', (req, res) => {
  const { id } = req.body;

  if (!id) {
    return res.status(400).send({ message: 'Email is required' });
  }

  const query = 'SELECT * FROM users WHERE id = ?';
  db.query(query, [id], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching user information' });
    }

    if (results.length === 0) {
      return res.status(400).send({ message: 'Email not found' });
    }

    const user = results[0];
    res.status(200).send(user);
  });
});

app.get('/users/guru', (req, res) => {
  const query = 'SELECT * FROM users WHERE role = ?';
  db.query(query, ['guru'], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching users with role guru' });
    }

    res.status(200).send(results);
  });
});

app.get('/users/kategori', (req, res) => {
  const { mata_pelajaran } = req.body;
  const query = 'SELECT * FROM users WHERE role = ? AND mata_pelajaran = ?';
  db.query(query, ['guru', mata_pelajaran], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching users with role guru' });
    }

    res.status(200).send(results);
  });
});

app.get('/users/siswa', (req, res) => {
  const query = 'SELECT * FROM users WHERE role = ?';
  db.query(query, ['siswa'], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching users with role guru' });
    }

    res.status(200).send(results);
  });
});

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'public/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname)); // Appending extension
  }
});

app.get('/tarif', (req, res) => {

  const query = 'SELECT * FROM mata_pelajaran';
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching tarif' });
    }

    res.status(200).send(results);
  });
});

app.get('/mata_pelajaran', async (req, res) => {
  const query = 'SELECT * FROM mata_pelajaran';
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).send({ message: 'Error fetching tarif' });
    }
    res.status(200).send(results);
  });
});



app.delete('/mata_pelajaran', (req, res) => {
  const { id } = req.body;

  const sql = 'DELETE FROM mata_pelajaran WHERE id = ?';
  db.query(sql, [id], (err, result) => {
    if (err) {
      console.error('Error deleting from database:', err);
      return res.status(500).json({ error: 'Error deleting data' });
    }
    console.log(`Deleted ${result.affectedRows} row(s)`);
    res.status(200).json({ message: `Deleted ${result.affectedRows} row(s)` });
  });
});

const upload = multer({ storage: storage });

app.use('/public', express.static('public'));

// Endpoint to handle photo upload
app.post('/upload', upload.single('photo'), async (req, res) => {
  const { email } = req.body;
  const file = req.file;

  if (!file) {
    return res.status(400).send({ message: 'No file uploaded' });
  }

  // Assuming you store the photo URL in public directory
  const photoUrl = `https://pentagonal-crawling-shovel.glitch.me/public/${file.filename}`;

  try {
    // Update foto_profil in users table
    const updateQuery = 'UPDATE users SET foto_profil = ? WHERE email = ?';
    await db.query(updateQuery, [photoUrl, email]);

    res.status(200).send({ photoUrl });
  } catch (error) {
    console.error('Error updating photo URL:', error);
    res.status(500).send({ message: 'Error updating photo URL' });
  }
});

app.post('/setmatapelajaran', upload.single('photo'), async (req, res) => {
  const { deskripsi, tarif } = req.body; // Assuming tarif is sent in the body
  const file = req.file;

  if (!file) {
    return res.status(400).send({ message: 'No file uploaded' });
  }

  // Assuming you store the photo URL in public directory
  const photoUrl = `https://pentagonal-crawling-shovel.glitch.me/public/${file.filename}`;

  try {
    // Insert new record
    upsertMataPelajaranQuery = `
        INSERT INTO mata_pelajaran (deskripsi, tarif, icon)
        VALUES (?, ?, ?)
      `;
    await db.query(upsertMataPelajaranQuery, [deskripsi, parseInt(tarif), photoUrl]);


    res.status(200).send({ photoUrl });
  } catch (error) {
    console.error('Error updating photo URL or mata_pelajaran:', error);
    res.status(500).send({ message: 'Error updating photo URL or mata_pelajaran' });
  }
});

app.post('/update_foto', upload.single('photo'), async (req, res) => {
  const { id } = req.body; // Assuming tarif is sent in the body
  const file = req.file;

  if (!file) {
    return res.status(400).send({ message: 'No file uploaded' });
  }

  // Assuming you store the photo URL in public directory
  const photoUrl = `https://pentagonal-crawling-shovel.glitch.me/public/${file.filename}`;

  try {
    // Insert new record
    upsertMataPelajaranQuery = `UPDATE users SET foto_profil = ? WHERE id = ?`;
    await db.query(upsertMataPelajaranQuery, [photoUrl, id]);


    res.status(200).send({ photoUrl });
  } catch (error) {
    console.error('Error updating photo URL or mata_pelajaran:', error);
    res.status(500).send({ message: 'Error updating photo URL or mata_pelajaran' });
  }
});


// Mulai server
const PORT = 3000;

app.listen(PORT, '0.0.0.0', () => {
  console.log('Server is running on port 3000');
});

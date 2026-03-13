// routes/authRoutes.js
const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const router = express.Router();
const db = require('../config/config'); // Conexión a la base de datos


// Ruta para el login
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email y password son requeridos' });
  }

  const query = 'SELECT * FROM usuarios WHERE email = ?';

  db.query(query, [email], (err, results) => {

    if (err) {
      return res.status(500).json({ message: 'Error al consultar la base de datos' });
    }

    if (results.length === 0) {
      return res.status(400).json({ message: 'Credenciales incorrectas' });
    }

    const usuario = results[0];

    bcrypt.compare(password, usuario.password, (err, isMatch) => {

      if (err) {
        return res.status(500).json({ message: 'Error al comparar contraseñas' });
      }

      if (!isMatch) {
        return res.status(400).json({ message: 'Credenciales incorrectas' });
      }

      const token = jwt.sign(
        { id: usuario.id, email: usuario.email },
        'tu_clave_secreta',
        { expiresIn: '1h' }
      );

      res.json({ message: 'Login exitoso', token });

    });

  });

});


// Ruta para registrar usuario
router.post('/register', async (req, res) => {

  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email y password son requeridos' });
  }

  try {

    const passwordHash = await bcrypt.hash(password, 10);

    const query = 'INSERT INTO usuarios (email, password) VALUES (?, ?)';

    db.query(query, [email, passwordHash], (err, result) => {

      if (err) {
        return res.status(500).json({ message: 'Error al registrar usuario' });
      }

      res.json({ message: 'Usuario registrado correctamente' });

    });

  } catch (error) {
    res.status(500).json({ message: 'Error del servidor' });
  }

});


module.exports = router;
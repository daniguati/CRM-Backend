const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const router = express.Router();
const db = require('../config/config');
const verifyToken = require('../middleware/verifyToken');

const jwtSecret = () => process.env.JWT_SECRET;
const jwtExpiresIn = () => process.env.JWT_EXPIRES_IN || '2h';

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

      if (!jwtSecret()) {
        return res.status(500).json({ message: 'JWT_SECRET no está configurado' });
      }

      const token = jwt.sign(
        { id: usuario.id, email: usuario.email, rol: usuario.rol },
        jwtSecret(),
        { expiresIn: jwtExpiresIn() }
      );

      res.json({
        message: 'Login exitoso',
        token,
        user: {
          id: usuario.id,
          nombre: usuario.nombre,
          email: usuario.email,
          rol: usuario.rol
        }
      });

    });

  });

});


// Ruta para registrar usuario
router.post('/register', async (req, res) => {

  const { nombre = 'Usuario', email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email y password son requeridos' });
  }

  if (password.length < 6) {
    return res.status(400).json({ message: 'La contraseña debe tener mínimo 6 caracteres' });
  }

  try {

    const passwordHash = await bcrypt.hash(password, 10);

    const query = 'INSERT INTO usuarios (nombre, email, password) VALUES (?, ?, ?)';

    db.query(query, [nombre, email, passwordHash], (err) => {

      if (err) {
        if (err.code === 'ER_DUP_ENTRY') {
          return res.status(409).json({ message: 'El email ya está registrado' });
        }

        return res.status(500).json({ message: 'Error al registrar usuario' });
      }

      res.json({ message: 'Usuario registrado correctamente' });

    });

  } catch (error) {
    res.status(500).json({ message: 'Error del servidor' });
  }

});

router.get('/me', verifyToken, (req, res) => {
  const query = 'SELECT id, nombre, email, rol, created_at FROM usuarios WHERE id = ?';

  db.query(query, [req.user.id], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Error al consultar usuario' });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    res.json(results[0]);
  });
});

// Ruta para cambiar contraseña
router.post('/change-password', verifyToken, async (req, res) => {

  const { currentPassword, newPassword, confirmPassword } = req.body;

  // validar campos
  if (!currentPassword || !newPassword || !confirmPassword) {
    return res.status(400).json({ message: 'Todos los campos son obligatorios' });
  }

  if (newPassword !== confirmPassword) {
    return res.status(400).json({ message: 'Las contraseñas no coinciden' });
  }

  const userId = req.user.id;

  const query = 'SELECT * FROM usuarios WHERE id = ?';

  db.query(query, [userId], async (err, results) => {

    if (err) {
      return res.status(500).json({ message: 'Error al consultar usuario' });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    const usuario = results[0];

    try {

      const isMatch = await bcrypt.compare(currentPassword, usuario.password);

      if (!isMatch) {
        return res.status(400).json({ message: 'La contraseña actual es incorrecta' });
      }

      const newPasswordHash = await bcrypt.hash(newPassword, 10);

      const updateQuery = 'UPDATE usuarios SET password = ? WHERE id = ?';

      db.query(updateQuery, [newPasswordHash, userId], (err) => {

        if (err) {
          return res.status(500).json({ message: 'Error al actualizar contraseña' });
        }

        res.json({ message: 'Contraseña actualizada correctamente' });

      });

    } catch (error) {

      res.status(500).json({ message: 'Error del servidor' });

    }

  });

});

module.exports = router;

// routes/contactoRoutes.js
const express = require('express');
const router = express.Router();
const contactoModel = require('../models/contacto');
const db = require('../config/config');  // Esto importa la conexión a la base de datos

// Ruta para obtener todos los contactos
router.get('/', (req, res) => {
  const query = 'SELECT * FROM contactos';
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.json(results);
  });
});

// Ruta para crear un nuevo contacto
router.post('/', (req, res) => {
  const { nombre, telefono, correo, empresa, notas } = req.body;
  const query = 'INSERT INTO contactos (nombre, telefono, correo, empresa, notas) VALUES (?, ?, ?, ?, ?)';
  db.query(query, [nombre, telefono, correo, empresa, notas], (err, result) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.status(201).json({ message: 'Contacto creado', id: result.insertId });
  });
});
// Ruta para editar un contacto
router.put('/:id', async (req, res) => {
  const { nombre, telefono, correo, empresa, notas } = req.body;
  const id = req.params.id;

  try {
    const result = await contactoModel.editarContacto(id, nombre, telefono, correo, empresa, notas);
    res.status(200).json({ message: 'Contacto actualizado', result });
  } catch (err) {
    res.status(500).send(err);
  }
});
// Ruta para eliminar un contacto
router.delete('/:id', async (req, res) => {
  const id = req.params.id;

  try {
    const result = await contactoModel.eliminarContacto(id);
    res.status(200).json({ message: 'Contacto eliminado', result });
  } catch (err) {
    res.status(500).send(err);
  }
});

module.exports = router;
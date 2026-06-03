const express = require('express');
const router = express.Router();
const contactoModel = require('../models/contacto');
const verifyToken = require('../middleware/verifyToken');

router.use(verifyToken);

function validarContacto(req, res, next) {
  const { nombre, telefono, correo } = req.body;

  if (!nombre || !telefono || !correo) {
    return res.status(400).json({
      message: 'Nombre, teléfono y correo son obligatorios'
    });
  }

  next();
}

// Ruta para obtener todos los contactos
router.get('/', async (req, res) => {
  try {
    const contactos = await contactoModel.obtenerContactos(req.query.search || '');
    res.json(contactos);
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener contactos' });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const contacto = await contactoModel.obtenerContactoPorId(req.params.id);

    if (!contacto) {
      return res.status(404).json({ message: 'Contacto no encontrado' });
    }

    res.json(contacto);
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener contacto' });
  }
});

// Ruta para crear un nuevo contacto
router.post('/', validarContacto, async (req, res) => {
  try {
    const contacto = await contactoModel.crearContacto(req.body);
    res.status(201).json(contacto);
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ message: 'Ya existe un contacto con ese correo' });
    }

    res.status(500).json({ message: 'Error al crear contacto' });
  }
});

// Ruta para editar un contacto
router.put('/:id', validarContacto, async (req, res) => {
  try {
    const contacto = await contactoModel.editarContacto(req.params.id, req.body);

    if (!contacto) {
      return res.status(404).json({ message: 'Contacto no encontrado' });
    }

    res.json(contacto);
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ message: 'Ya existe un contacto con ese correo' });
    }

    res.status(500).json({ message: 'Error al actualizar contacto' });
  }
});

// Ruta para eliminar un contacto
router.delete('/:id', async (req, res) => {
  try {
    const eliminado = await contactoModel.eliminarContacto(req.params.id);

    if (!eliminado) {
      return res.status(404).json({ message: 'Contacto no encontrado' });
    }

    res.json({ message: 'Contacto eliminado' });
  } catch (err) {
    res.status(500).json({ message: 'Error al eliminar contacto' });
  }
});

module.exports = router;

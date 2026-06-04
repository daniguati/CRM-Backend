const express = require('express');
const router = express.Router();
const verifyToken = require('../middleware/verifyToken');
const actividadModel = require('../models/actividad');

router.use(verifyToken);

function validarActividad(req, res, next) {
  const { titulo, fecha } = req.body;

  if (!titulo || !fecha) {
    return res.status(400).json({ message: 'Título y fecha son obligatorios' });
  }

  next();
}

router.get('/', async (req, res) => {
  try {
    const actividades = await actividadModel.obtenerActividades({
      estado: req.query.estado || '',
      desde: req.query.desde || '',
      hasta: req.query.hasta || ''
    });

    res.json(actividades);
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener actividades' });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const actividad = await actividadModel.obtenerActividadPorId(req.params.id);

    if (!actividad) {
      return res.status(404).json({ message: 'Actividad no encontrada' });
    }

    res.json(actividad);
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener actividad' });
  }
});

router.post('/', validarActividad, async (req, res) => {
  try {
    const actividad = await actividadModel.crearActividad(req.body);
    res.status(201).json(actividad);
  } catch (err) {
    if (err.code === 'ER_NO_REFERENCED_ROW_2') {
      return res.status(400).json({ message: 'El contacto u oportunidad asociada no existe' });
    }

    res.status(500).json({ message: 'Error al crear actividad' });
  }
});

router.put('/:id', validarActividad, async (req, res) => {
  try {
    const actividad = await actividadModel.editarActividad(req.params.id, req.body);

    if (!actividad) {
      return res.status(404).json({ message: 'Actividad no encontrada' });
    }

    res.json(actividad);
  } catch (err) {
    if (err.code === 'ER_NO_REFERENCED_ROW_2') {
      return res.status(400).json({ message: 'El contacto u oportunidad asociada no existe' });
    }

    res.status(500).json({ message: 'Error al actualizar actividad' });
  }
});

router.delete('/:id', async (req, res) => {
  try {
    const eliminado = await actividadModel.eliminarActividad(req.params.id);

    if (!eliminado) {
      return res.status(404).json({ message: 'Actividad no encontrada' });
    }

    res.json({ message: 'Actividad eliminada' });
  } catch (err) {
    res.status(500).json({ message: 'Error al eliminar actividad' });
  }
});

module.exports = router;

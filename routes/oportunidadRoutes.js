const express = require('express');
const router = express.Router();
const verifyToken = require('../middleware/verifyToken');
const oportunidadModel = require('../models/oportunidad');

router.use(verifyToken);

function validarOportunidad(req, res, next) {
  const { titulo } = req.body;

  if (!titulo) {
    return res.status(400).json({ message: 'El título de la oportunidad es obligatorio' });
  }

  next();
}

router.get('/', async (req, res) => {
  try {
    const oportunidades = await oportunidadModel.obtenerOportunidades({
      search: req.query.search || '',
      etapa: req.query.etapa || ''
    });

    res.json(oportunidades);
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener oportunidades' });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const oportunidad = await oportunidadModel.obtenerOportunidadPorId(req.params.id);

    if (!oportunidad) {
      return res.status(404).json({ message: 'Oportunidad no encontrada' });
    }

    res.json(oportunidad);
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener oportunidad' });
  }
});

router.post('/', validarOportunidad, async (req, res) => {
  try {
    const oportunidad = await oportunidadModel.crearOportunidad(req.body);
    res.status(201).json(oportunidad);
  } catch (err) {
    if (err.code === 'ER_NO_REFERENCED_ROW_2') {
      return res.status(400).json({ message: 'El contacto asociado no existe' });
    }

    res.status(500).json({ message: 'Error al crear oportunidad' });
  }
});

router.put('/:id', validarOportunidad, async (req, res) => {
  try {
    const oportunidad = await oportunidadModel.editarOportunidad(req.params.id, req.body);

    if (!oportunidad) {
      return res.status(404).json({ message: 'Oportunidad no encontrada' });
    }

    res.json(oportunidad);
  } catch (err) {
    if (err.code === 'ER_NO_REFERENCED_ROW_2') {
      return res.status(400).json({ message: 'El contacto asociado no existe' });
    }

    res.status(500).json({ message: 'Error al actualizar oportunidad' });
  }
});

router.delete('/:id', async (req, res) => {
  try {
    const eliminado = await oportunidadModel.eliminarOportunidad(req.params.id);

    if (!eliminado) {
      return res.status(404).json({ message: 'Oportunidad no encontrada' });
    }

    res.json({ message: 'Oportunidad eliminada' });
  } catch (err) {
    res.status(500).json({ message: 'Error al eliminar oportunidad' });
  }
});

module.exports = router;

const express = require('express');
const router = express.Router();
const db = require('../config/config');
const verifyToken = require('../middleware/verifyToken');

router.use(verifyToken);

router.get('/resumen', async (req, res) => {
  try {
    const [
      [[contactos]],
      [[oportunidades]],
      [[ventas]],
      [[actividades]],
      [recientes]
    ] = await Promise.all([
      db.promise().query('SELECT COUNT(*) AS total FROM contactos'),
      db.promise().query("SELECT COUNT(*) AS total FROM oportunidades WHERE etapa NOT IN ('ganada', 'perdida')"),
      db.promise().query("SELECT COALESCE(SUM(valor), 0) AS total FROM oportunidades WHERE etapa = 'ganada'"),
      db.promise().query("SELECT COUNT(*) AS total FROM actividades WHERE estado = 'pendiente'"),
      db.promise().query(`
        SELECT id, nombre, correo, empresa, estado
        FROM contactos
        ORDER BY id DESC
        LIMIT 3
      `)
    ]);

    res.json({
      totales: {
        contactos: Number(contactos.total || 0),
        oportunidades: Number(oportunidades.total || 0),
        ventas: Number(ventas.total || 0),
        actividades: Number(actividades.total || 0)
      },
      contactosRecientes: recientes
    });
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener resumen del dashboard' });
  }
});

router.get('/reportes', async (req, res) => {
  try {
    const [
      [[ventas]],
      [[clientes]],
      [[leads]],
      [ventasPorEtapa],
      [clientesPorEstado]
    ] = await Promise.all([
      db.promise().query("SELECT COALESCE(SUM(valor), 0) AS total FROM oportunidades WHERE etapa = 'ganada'"),
      db.promise().query("SELECT COUNT(*) AS total FROM contactos WHERE estado = 'cliente'"),
      db.promise().query("SELECT COUNT(*) AS total FROM contactos WHERE estado = 'lead'"),
      db.promise().query(`
        SELECT etapa, COALESCE(SUM(valor), 0) AS total
        FROM oportunidades
        GROUP BY etapa
        ORDER BY FIELD(etapa, 'prospecto', 'propuesta', 'negociacion', 'ganada', 'perdida')
      `),
      db.promise().query(`
        SELECT estado, COUNT(*) AS total
        FROM contactos
        GROUP BY estado
        ORDER BY FIELD(estado, 'cliente', 'lead', 'inactivo')
      `)
    ]);

    res.json({
      indicadores: {
        ventas: Number(ventas.total || 0),
        clientes: Number(clientes.total || 0),
        leads: Number(leads.total || 0)
      },
      ventasPorEtapa: ventasPorEtapa.map((item) => ({
        etapa: item.etapa,
        total: Number(item.total || 0)
      })),
      clientesPorEstado: clientesPorEstado.map((item) => ({
        estado: item.estado,
        total: Number(item.total || 0)
      }))
    });
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener reportes' });
  }
});

module.exports = router;

const db = require('../config/config');

const tiposValidos = ['llamada', 'reunion', 'correo', 'tarea'];
const estadosValidos = ['pendiente', 'completada', 'cancelada'];

const normalizarActividad = (data) => ({
  contacto_id: data.contacto_id || null,
  oportunidad_id: data.oportunidad_id || null,
  titulo: data.titulo,
  descripcion: data.descripcion || null,
  tipo: tiposValidos.includes(data.tipo) ? data.tipo : 'tarea',
  fecha: data.fecha,
  hora: data.hora || null,
  estado: estadosValidos.includes(data.estado) ? data.estado : 'pendiente'
});

const obtenerActividades = async ({ estado = '', desde = '', hasta = '' } = {}) => {
  const params = [];
  let query = `
    SELECT
      a.id,
      a.contacto_id,
      a.oportunidad_id,
      a.titulo,
      a.descripcion,
      a.tipo,
      DATE_FORMAT(a.fecha, '%Y-%m-%d') AS fecha,
      TIME_FORMAT(a.hora, '%H:%i') AS hora,
      a.estado,
      a.created_at,
      a.updated_at,
      c.nombre AS contacto_nombre,
      o.titulo AS oportunidad_titulo
    FROM actividades a
    LEFT JOIN contactos c ON c.id = a.contacto_id
    LEFT JOIN oportunidades o ON o.id = a.oportunidad_id
    WHERE 1 = 1
  `;

  if (estado && estadosValidos.includes(estado)) {
    query += ' AND a.estado = ?';
    params.push(estado);
  }

  if (desde) {
    query += ' AND a.fecha >= ?';
    params.push(desde);
  }

  if (hasta) {
    query += ' AND a.fecha <= ?';
    params.push(hasta);
  }

  query += ' ORDER BY a.fecha ASC, a.hora ASC, a.id ASC';

  const [rows] = await db.promise().query(query, params);
  return rows;
};

const obtenerActividadPorId = async (id) => {
  const [rows] = await db.promise().query(
    `SELECT
      id,
      contacto_id,
      oportunidad_id,
      titulo,
      descripcion,
      tipo,
      DATE_FORMAT(fecha, '%Y-%m-%d') AS fecha,
      TIME_FORMAT(hora, '%H:%i') AS hora,
      estado,
      created_at,
      updated_at
     FROM actividades
     WHERE id = ?`,
    [id]
  );

  return rows[0] || null;
};

const crearActividad = async (data) => {
  const actividad = normalizarActividad(data);
  const [result] = await db.promise().query(
    `INSERT INTO actividades
      (contacto_id, oportunidad_id, titulo, descripcion, tipo, fecha, hora, estado)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      actividad.contacto_id,
      actividad.oportunidad_id,
      actividad.titulo,
      actividad.descripcion,
      actividad.tipo,
      actividad.fecha,
      actividad.hora,
      actividad.estado
    ]
  );

  return obtenerActividadPorId(result.insertId);
};

const editarActividad = async (id, data) => {
  const actividad = normalizarActividad(data);
  const [result] = await db.promise().query(
    `UPDATE actividades
     SET contacto_id = ?, oportunidad_id = ?, titulo = ?, descripcion = ?, tipo = ?, fecha = ?, hora = ?, estado = ?
     WHERE id = ?`,
    [
      actividad.contacto_id,
      actividad.oportunidad_id,
      actividad.titulo,
      actividad.descripcion,
      actividad.tipo,
      actividad.fecha,
      actividad.hora,
      actividad.estado,
      id
    ]
  );

  if (result.affectedRows === 0) {
    return null;
  }

  return obtenerActividadPorId(id);
};

const eliminarActividad = async (id) => {
  const [result] = await db.promise().query('DELETE FROM actividades WHERE id = ?', [id]);
  return result.affectedRows > 0;
};

module.exports = {
  tiposValidos,
  estadosValidos,
  obtenerActividades,
  obtenerActividadPorId,
  crearActividad,
  editarActividad,
  eliminarActividad
};

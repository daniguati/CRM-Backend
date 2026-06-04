const db = require('../config/config');

const etapasValidas = ['prospecto', 'propuesta', 'negociacion', 'ganada', 'perdida'];

const normalizarOportunidad = (data) => ({
  contacto_id: data.contacto_id || null,
  titulo: data.titulo,
  valor: Number(data.valor || 0),
  etapa: etapasValidas.includes(data.etapa) ? data.etapa : 'prospecto',
  probabilidad: Number(data.probabilidad || 20),
  fecha_cierre: data.fecha_cierre || null,
  notas: data.notas || null
});

const obtenerOportunidades = async ({ search = '', etapa = '' } = {}) => {
  const params = [];
  let query = `
    SELECT
      o.id,
      o.contacto_id,
      o.titulo,
      o.valor,
      o.etapa,
      o.probabilidad,
      DATE_FORMAT(o.fecha_cierre, '%Y-%m-%d') AS fecha_cierre,
      o.notas,
      o.created_at,
      o.updated_at,
      c.nombre AS contacto_nombre,
      c.empresa AS contacto_empresa
    FROM oportunidades o
    LEFT JOIN contactos c ON c.id = o.contacto_id
    WHERE 1 = 1
  `;

  if (search) {
    query += ' AND (o.titulo LIKE ? OR c.nombre LIKE ? OR c.empresa LIKE ?)';
    const term = `%${search}%`;
    params.push(term, term, term);
  }

  if (etapa && etapasValidas.includes(etapa)) {
    query += ' AND o.etapa = ?';
    params.push(etapa);
  }

  query += ' ORDER BY o.id DESC';

  const [rows] = await db.promise().query(query, params);
  return rows;
};

const obtenerOportunidadPorId = async (id) => {
  const oportunidades = await obtenerOportunidades();
  return oportunidades.find((oportunidad) => Number(oportunidad.id) === Number(id)) || null;
};

const crearOportunidad = async (data) => {
  const oportunidad = normalizarOportunidad(data);
  const [result] = await db.promise().query(
    `INSERT INTO oportunidades
      (contacto_id, titulo, valor, etapa, probabilidad, fecha_cierre, notas)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [
      oportunidad.contacto_id,
      oportunidad.titulo,
      oportunidad.valor,
      oportunidad.etapa,
      oportunidad.probabilidad,
      oportunidad.fecha_cierre,
      oportunidad.notas
    ]
  );

  return obtenerOportunidadPorId(result.insertId);
};

const editarOportunidad = async (id, data) => {
  const oportunidad = normalizarOportunidad(data);
  const [result] = await db.promise().query(
    `UPDATE oportunidades
     SET contacto_id = ?, titulo = ?, valor = ?, etapa = ?, probabilidad = ?, fecha_cierre = ?, notas = ?
     WHERE id = ?`,
    [
      oportunidad.contacto_id,
      oportunidad.titulo,
      oportunidad.valor,
      oportunidad.etapa,
      oportunidad.probabilidad,
      oportunidad.fecha_cierre,
      oportunidad.notas,
      id
    ]
  );

  if (result.affectedRows === 0) {
    return null;
  }

  return obtenerOportunidadPorId(id);
};

const eliminarOportunidad = async (id) => {
  const [result] = await db.promise().query('DELETE FROM oportunidades WHERE id = ?', [id]);
  return result.affectedRows > 0;
};

module.exports = {
  etapasValidas,
  obtenerOportunidades,
  obtenerOportunidadPorId,
  crearOportunidad,
  editarOportunidad,
  eliminarOportunidad
};

const db = require('../config/config');

const obtenerContactos = async (search = '') => {
  const params = [];
  let query = `
    SELECT id, nombre, telefono, correo, empresa, notas, estado, created_at, updated_at
    FROM contactos
  `;

  if (search) {
    query += `
      WHERE nombre LIKE ?
        OR telefono LIKE ?
        OR correo LIKE ?
        OR empresa LIKE ?
    `;

    const term = `%${search}%`;
    params.push(term, term, term, term);
  }

  query += ' ORDER BY id DESC';

  const [rows] = await db.promise().query(query, params);
  return rows;
};

const obtenerContactoPorId = async (id) => {
  const [rows] = await db.promise().query(
    `SELECT id, nombre, telefono, correo, empresa, notas, estado, created_at, updated_at
     FROM contactos
     WHERE id = ?`,
    [id]
  );

  return rows[0] || null;
};

const crearContacto = async ({ nombre, telefono, correo, empresa, notas, estado = 'lead' }) => {
  const query = `
    INSERT INTO contactos (nombre, telefono, correo, empresa, notas, estado)
    VALUES (?, ?, ?, ?, ?, ?)
  `;

  const [result] = await db.promise().query(query, [
    nombre,
    telefono,
    correo,
    empresa || null,
    notas || null,
    estado
  ]);

  return obtenerContactoPorId(result.insertId);
};

const editarContacto = async (id, { nombre, telefono, correo, empresa, notas, estado = 'lead' }) => {
  const query = `
    UPDATE contactos
    SET nombre = ?, telefono = ?, correo = ?, empresa = ?, notas = ?, estado = ?
    WHERE id = ?
  `;

  const [result] = await db.promise().query(query, [
    nombre,
    telefono,
    correo,
    empresa || null,
    notas || null,
    estado,
    id
  ]);

  if (result.affectedRows === 0) {
    return null;
  }

  return obtenerContactoPorId(id);
};

const eliminarContacto = async (id) => {
  const [result] = await db.promise().query('DELETE FROM contactos WHERE id = ?', [id]);
  return result.affectedRows > 0;
};

module.exports = {
  obtenerContactos,
  obtenerContactoPorId,
  crearContacto,
  editarContacto,
  eliminarContacto
};

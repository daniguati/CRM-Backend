// models/contacto.js
const db = require('../config/config');

// Función para obtener todos los contactos
const obtenerContactos = () => {
  return new Promise((resolve, reject) => {
    db.query('SELECT * FROM contactos', (err, results) => {
      if (err) reject(err);
      resolve(results);
    });
  });
};

// Función para crear un nuevo contacto
const crearContacto = (nombre, telefono, correo, empresa, notas) => {
  return new Promise((resolve, reject) => {
    const query = 'INSERT INTO contactos (nombre, telefono, correo, empresa, notas) VALUES (?, ?, ?, ?, ?)';
    db.query(query, [nombre, telefono, correo, empresa, notas], (err, result) => {
      if (err) reject(err);
      resolve(result);
    });
  });
};

// Función para editar un contacto
const editarContacto = (id, nombre, telefono, correo, empresa, notas) => {
  return new Promise((resolve, reject) => {
    const query = `
      UPDATE contactos 
      SET nombre = ?, telefono = ?, correo = ?, empresa = ?, notas = ?
      WHERE id = ?
    `;
    db.query(query, [nombre, telefono, correo, empresa, notas, id], (err, result) => {
      if (err) reject(err);
      resolve(result);
    });
  });
};

// Función para eliminar un contacto
const eliminarContacto = (id) => {
  return new Promise((resolve, reject) => {
    const query = 'DELETE FROM contactos WHERE id = ?';
    db.query(query, [id], (err, result) => {
      if (err) reject(err);
      resolve(result);
    });
  });
};

module.exports = { obtenerContactos, crearContacto,editarContacto, eliminarContacto };
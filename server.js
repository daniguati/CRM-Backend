// server.js
const express = require('express');
const app = express();

// Importamos las rutas
const contactoRoutes = require('./routes/contactoRoutes');

// Middleware
app.use(express.json()); // Express ya tiene este middleware

// Usar las rutas de contactos
app.use('/api/contactos', contactoRoutes);

// Iniciar el servidor
app.listen(3000, () => {
  console.log('Servidor corriendo en http://localhost:3000');
});
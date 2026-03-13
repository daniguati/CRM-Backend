const express = require('express');
const cors = require('cors');
const app = express();

// Importamos las rutas
const contactoRoutes = require('./routes/contactoRoutes');
const authRoutes = require('./routes/authRoutes');

// Middleware
app.use(cors());
app.use(express.json());

// Usar las rutas
app.use('/api/contactos', contactoRoutes);
app.use('/api/auth', authRoutes);

// Iniciar servidor
app.listen(3000, () => {
  console.log('Servidor corriendo en http://localhost:3000');
});
const express = require('express');
const cors = require('cors');  // Mueve esta línea aquí para usar cors después de declarar 'app'
const app = express();  // Aquí está la declaración correcta de 'app'

// Habilitar CORS para todas las rutas
app.use(cors());

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
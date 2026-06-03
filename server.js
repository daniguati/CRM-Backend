const express = require('express');
const cors = require('cors');
require('dotenv').config({ quiet: true });

const app = express();
const port = process.env.PORT || 3000;

// Importamos las rutas
const contactoRoutes = require('./routes/contactoRoutes');
const authRoutes = require('./routes/authRoutes');
const oportunidadRoutes = require('./routes/oportunidadRoutes');
const actividadRoutes = require('./routes/actividadRoutes');
const dashboardRoutes = require('./routes/dashboardRoutes');

// Middleware
app.use(cors({
  origin: process.env.APP_ORIGIN ? process.env.APP_ORIGIN.split(',') : true,
  credentials: true
}));
app.use(express.json());

// Usar las rutas
app.use('/api/contactos', contactoRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/oportunidades', oportunidadRoutes);
app.use('/api/actividades', actividadRoutes);
app.use('/api/dashboard', dashboardRoutes);

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', app: 'CRM SENA API' });
});

// Iniciar servidor
app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});

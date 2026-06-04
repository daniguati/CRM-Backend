USE crm_db;

INSERT INTO usuarios (nombre, email, password, rol)
SELECT
  'Administrador CRM',
  'admin@crm.com',
  '$2b$10$CetXhnk2NhPvhEGVhQC4bOP22xuxFdzuRj/UhtSsm.m1WyUEprNfu',
  'admin'
WHERE NOT EXISTS (
  SELECT 1
  FROM usuarios
  WHERE email = 'admin@crm.com'
);

UPDATE usuarios
SET
  nombre = 'Administrador CRM',
  rol = 'admin'
WHERE email = 'admin@crm.com';

INSERT INTO contactos (nombre, telefono, correo, empresa, notas, estado)
VALUES
  ('Laura Gomez', '3001234567', 'laura.gomez@example.com', 'Acme SAS', 'Colombia. Lead interesado en automatizar seguimiento comercial.', 'lead'),
  ('Carlos Ruiz', '3019876543', 'carlos.ruiz@example.com', 'Soluciones Andinas', 'Colombia. Cliente activo para plan mensual.', 'cliente'),
  ('Ana Martinez', '+57 310 555 0191', 'ana.martinez@andesretail.example', 'Andes Retail Group', 'Colombia. Busca integrar ventas de tiendas fisicas y ecommerce.', 'cliente'),
  ('Diego Torres', '+52 55 1200 4410', 'diego.torres@fintechlatam.example', 'Fintech Latam MX', 'Mexico. Equipo comercial con alto volumen de leads digitales.', 'lead'),
  ('Valentina Rojas', '+56 2 2400 8891', 'valentina.rojas@saludnova.example', 'Salud Nova Chile', 'Chile. Requiere seguimiento de cuentas corporativas.', 'cliente'),
  ('Juan Perez', '+51 1 705 3312', 'juan.perez@agrologica.example', 'Agrologica Peru', 'Peru. Prospecto para CRM agricola B2B.', 'lead'),
  ('Mariana Silva', '+55 11 4002 8922', 'mariana.silva@edutechbrasil.example', 'Edutech Brasil', 'Brasil. Cliente con expansion regional de capacitaciones.', 'cliente'),
  ('Sebastian Ortiz', '+57 320 441 2200', 'sebastian.ortiz@logisticapro.example', 'Logistica Pro', 'Colombia. Necesita pipeline para cuentas empresariales.', 'cliente'),
  ('Camila Fernandez', '+54 11 5217 4300', 'camila.fernandez@hotelpacifico.example', 'Hotel Pacifico AR', 'Argentina. Lead de turismo corporativo.', 'lead'),
  ('Miguel Herrera', '+1 305 555 0134', 'miguel.herrera@cloudworks.example', 'CloudWorks USA', 'Estados Unidos. Cuenta inactiva por cambio de proveedor.', 'inactivo'),
  ('Sofia Ramirez', '+57 318 221 7788', 'sofia.ramirez@energiaandina.example', 'Energia Andina', 'Colombia. Cliente activo con renovacion anual pendiente.', 'cliente'),
  ('Nicolas Castro', '+34 91 555 4821', 'nicolas.castro@legalhub.example', 'LegalHub Iberia', 'Espana. Lead para gestion de relaciones B2B.', 'lead'),
  ('Paula Moreno', '+57 314 801 5577', 'paula.moreno@manufacturasdelta.example', 'Manufacturas Delta', 'Colombia. Cliente de manufactura con equipo de preventa.', 'cliente'),
  ('Mateo Vargas', '+52 81 9000 2134', 'mateo.vargas@startuppagos.example', 'Startup Pagos MX', 'Mexico. Prospecto temprano, comparando herramientas.', 'lead'),
  ('Isabella Navarro', '+1 646 555 0188', 'isabella.navarro@biomedglobal.example', 'Biomed Global', 'Estados Unidos. Cuenta enterprise con decision en comite.', 'cliente'),
  ('Andres Reyes', '+57 315 888 4211', 'andres.reyes@cafenorte.example', 'Cafe Norte Export', 'Colombia. Cliente exportador con seguimiento internacional.', 'cliente'),
  ('Lucia Paredes', '+52 33 1500 7701', 'lucia.paredes@retailmex.example', 'Retail MX 360', 'Mexico. Cuenta inactiva, revisar reactivacion trimestral.', 'inactivo'),
  ('Tomas Arias', '+598 2 900 4411', 'tomas.arias@constructoraaurora.example', 'Constructora Aurora', 'Uruguay. Lead para CRM de proyectos comerciales.', 'lead'),
  ('Diana Suarez', '+507 830 2210', 'diana.suarez@turismoglobal.example', 'Turismo Global PA', 'Panama. Cliente regional con equipos distribuidos.', 'cliente'),
  ('Felipe Molina', '+57 316 552 9821', 'felipe.molina@consultoriab2b.example', 'Consultoria B2B Norte', 'Colombia. Cuenta inactiva por presupuesto congelado.', 'inactivo')
ON DUPLICATE KEY UPDATE
  nombre = VALUES(nombre),
  telefono = VALUES(telefono),
  empresa = VALUES(empresa),
  notas = VALUES(notas),
  estado = VALUES(estado);

INSERT INTO oportunidades (contacto_id, titulo, valor, etapa, probabilidad, fecha_cierre, notas)
SELECT
  c.id,
  data.titulo,
  data.valor,
  data.etapa,
  data.probabilidad,
  data.fecha_cierre,
  data.notas
FROM (
  SELECT 'laura.gomez@example.com' AS correo, 'Implementacion CRM basico' AS titulo, 2500000 AS valor, 'propuesta' AS etapa, 60 AS probabilidad, DATE_ADD(CURDATE(), INTERVAL 20 DAY) AS fecha_cierre, 'Demo MVP para equipo comercial pequeno.' AS notas
  UNION ALL SELECT 'carlos.ruiz@example.com', 'Renovacion plan mensual Andinas', 1800000, 'ganada', 100, DATE_SUB(CURDATE(), INTERVAL 8 DAY), 'Renovacion cerrada con soporte prioritario.'
  UNION ALL SELECT 'ana.martinez@andesretail.example', 'Integracion retail omnicanal', 9200000, 'negociacion', 75, DATE_ADD(CURDATE(), INTERVAL 18 DAY), 'Integracion con ecommerce, tiendas y reportes ejecutivos.'
  UNION ALL SELECT 'diego.torres@fintechlatam.example', 'Automatizacion leads fintech Mexico', 7800000, 'prospecto', 35, DATE_ADD(CURDATE(), INTERVAL 42 DAY), 'Necesitan scoring y seguimiento para leads digitales.'
  UNION ALL SELECT 'valentina.rojas@saludnova.example', 'CRM salud corporativa Chile', 11500000, 'propuesta', 65, DATE_ADD(CURDATE(), INTERVAL 25 DAY), 'Propuesta enviada a direccion comercial.'
  UNION ALL SELECT 'juan.perez@agrologica.example', 'Pipeline agroexportador Peru', 4300000, 'prospecto', 30, DATE_ADD(CURDATE(), INTERVAL 55 DAY), 'Primera etapa de evaluacion con equipo comercial.'
  UNION ALL SELECT 'mariana.silva@edutechbrasil.example', 'Expansion capacitaciones Brasil', 13200000, 'ganada', 100, DATE_SUB(CURDATE(), INTERVAL 14 DAY), 'Contrato cerrado para tres unidades regionales.'
  UNION ALL SELECT 'sebastian.ortiz@logisticapro.example', 'Seguimiento cuentas logisticas', 6800000, 'negociacion', 70, DATE_ADD(CURDATE(), INTERVAL 12 DAY), 'Negociando alcance de usuarios y capacitacion.'
  UNION ALL SELECT 'camila.fernandez@hotelpacifico.example', 'CRM turismo corporativo AR', 3600000, 'perdida', 0, DATE_SUB(CURDATE(), INTERVAL 20 DAY), 'Perdida por prioridad presupuestal.'
  UNION ALL SELECT 'miguel.herrera@cloudworks.example', 'Reactivacion CloudWorks USA', 5100000, 'perdida', 0, DATE_SUB(CURDATE(), INTERVAL 35 DAY), 'Cuenta eligio proveedor actual por contrato vigente.'
  UNION ALL SELECT 'sofia.ramirez@energiaandina.example', 'Renovacion energia enterprise', 16500000, 'propuesta', 80, DATE_ADD(CURDATE(), INTERVAL 10 DAY), 'Renovacion anual con paquete premium.'
  UNION ALL SELECT 'nicolas.castro@legalhub.example', 'CRM legal B2B Iberia', 7400000, 'prospecto', 25, DATE_ADD(CURDATE(), INTERVAL 60 DAY), 'Discovery inicial con socios comerciales.'
  UNION ALL SELECT 'paula.moreno@manufacturasdelta.example', 'Preventas manufactura Delta', 8900000, 'negociacion', 68, DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'Validando integracion con procesos internos.'
  UNION ALL SELECT 'mateo.vargas@startuppagos.example', 'CRM startup pagos Mexico', 2900000, 'prospecto', 20, DATE_ADD(CURDATE(), INTERVAL 50 DAY), 'Prospecto sensible a precio, requiere plan inicial.'
  UNION ALL SELECT 'isabella.navarro@biomedglobal.example', 'Gestion enterprise Biomed Global', 24500000, 'negociacion', 82, DATE_ADD(CURDATE(), INTERVAL 21 DAY), 'Comite revisa cumplimiento y SLA.'
  UNION ALL SELECT 'andres.reyes@cafenorte.example', 'CRM exportaciones Cafe Norte', 5700000, 'ganada', 100, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Cierre ganado para equipo de ventas internacionales.'
  UNION ALL SELECT 'lucia.paredes@retailmex.example', 'Reactivacion Retail MX 360', 4100000, 'perdida', 0, DATE_SUB(CURDATE(), INTERVAL 18 DAY), 'Cliente aplazo compra hasta el proximo semestre.'
  UNION ALL SELECT 'tomas.arias@constructoraaurora.example', 'CRM proyectos constructora Aurora', 6200000, 'propuesta', 58, DATE_ADD(CURDATE(), INTERVAL 35 DAY), 'Propuesta enviada con modulos por etapas.'
  UNION ALL SELECT 'diana.suarez@turismoglobal.example', 'Operacion regional Turismo Global', 9800000, 'ganada', 100, DATE_SUB(CURDATE(), INTERVAL 11 DAY), 'Cierre regional para Panama y Caribe.'
  UNION ALL SELECT 'felipe.molina@consultoriab2b.example', 'Reactivacion consultoria B2B Norte', 3300000, 'perdida', 0, DATE_SUB(CURDATE(), INTERVAL 45 DAY), 'Presupuesto congelado por reestructuracion.'
) data
JOIN contactos c ON c.correo = data.correo
WHERE NOT EXISTS (
  SELECT 1
  FROM oportunidades o
  WHERE o.titulo = data.titulo
);

INSERT INTO actividades (contacto_id, oportunidad_id, titulo, descripcion, tipo, fecha, hora, estado)
SELECT
  c.id,
  o.id,
  data.titulo,
  data.descripcion,
  data.tipo,
  data.fecha,
  data.hora,
  data.estado
FROM (
  SELECT 'laura.gomez@example.com' AS correo, 'Implementacion CRM basico' AS oportunidad_titulo, 'Llamada de seguimiento Acme' AS titulo, 'Confirmar necesidades, presupuesto y fecha de demo.' AS descripcion, 'llamada' AS tipo, CURDATE() AS fecha, '10:00:00' AS hora, 'pendiente' AS estado
  UNION ALL SELECT 'carlos.ruiz@example.com', 'Renovacion plan mensual Andinas', 'Correo de bienvenida renovacion', 'Enviar resumen de renovacion y proximos pasos.', 'correo', DATE_SUB(CURDATE(), INTERVAL 7 DAY), '09:00:00', 'completada'
  UNION ALL SELECT 'ana.martinez@andesretail.example', 'Integracion retail omnicanal', 'Reunion tecnica retail', 'Revisar integracion con ecommerce y tiendas fisicas.', 'reunion', DATE_ADD(CURDATE(), INTERVAL 2 DAY), '14:30:00', 'pendiente'
  UNION ALL SELECT 'ana.martinez@andesretail.example', 'Integracion retail omnicanal', 'Enviar propuesta ajustada retail', 'Actualizar alcance por usuarios y tableros.', 'correo', DATE_ADD(CURDATE(), INTERVAL 5 DAY), '11:15:00', 'pendiente'
  UNION ALL SELECT 'diego.torres@fintechlatam.example', 'Automatizacion leads fintech Mexico', 'Discovery fintech Mexico', 'Levantar proceso actual de captacion digital.', 'llamada', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '16:00:00', 'pendiente'
  UNION ALL SELECT 'valentina.rojas@saludnova.example', 'CRM salud corporativa Chile', 'Demo salud corporativa', 'Presentar flujo de cuentas corporativas y actividades.', 'reunion', DATE_ADD(CURDATE(), INTERVAL 6 DAY), '08:30:00', 'pendiente'
  UNION ALL SELECT 'juan.perez@agrologica.example', 'Pipeline agroexportador Peru', 'Enviar material agro CRM', 'Compartir caso de uso para agroexportadores.', 'correo', DATE_ADD(CURDATE(), INTERVAL 4 DAY), '15:00:00', 'pendiente'
  UNION ALL SELECT 'mariana.silva@edutechbrasil.example', 'Expansion capacitaciones Brasil', 'Kickoff Edutech Brasil', 'Inicio de implementacion con lideres regionales.', 'reunion', DATE_SUB(CURDATE(), INTERVAL 10 DAY), '10:30:00', 'completada'
  UNION ALL SELECT 'sebastian.ortiz@logisticapro.example', 'Seguimiento cuentas logisticas', 'Negociacion usuarios Logistica Pro', 'Revisar numero de licencias y capacitacion.', 'llamada', DATE_ADD(CURDATE(), INTERVAL 3 DAY), '09:45:00', 'pendiente'
  UNION ALL SELECT 'camila.fernandez@hotelpacifico.example', 'CRM turismo corporativo AR', 'Cierre oportunidad Hotel Pacifico', 'Registrar motivo de perdida y proxima ventana.', 'tarea', DATE_SUB(CURDATE(), INTERVAL 19 DAY), '17:00:00', 'completada'
  UNION ALL SELECT 'miguel.herrera@cloudworks.example', 'Reactivacion CloudWorks USA', 'Revisar cuenta CloudWorks', 'Actualizar estado de proveedor actual.', 'tarea', DATE_SUB(CURDATE(), INTERVAL 30 DAY), '12:00:00', 'cancelada'
  UNION ALL SELECT 'sofia.ramirez@energiaandina.example', 'Renovacion energia enterprise', 'Reunion renovacion Energia Andina', 'Validar alcance premium y soporte.', 'reunion', DATE_ADD(CURDATE(), INTERVAL 7 DAY), '13:00:00', 'pendiente'
  UNION ALL SELECT 'nicolas.castro@legalhub.example', 'CRM legal B2B Iberia', 'Llamada discovery LegalHub', 'Entender proceso comercial y aprobadores.', 'llamada', DATE_ADD(CURDATE(), INTERVAL 8 DAY), '10:45:00', 'pendiente'
  UNION ALL SELECT 'paula.moreno@manufacturasdelta.example', 'Preventas manufactura Delta', 'Demo preventas Delta', 'Mostrar pipeline y seguimiento post-demo.', 'reunion', DATE_ADD(CURDATE(), INTERVAL 9 DAY), '15:30:00', 'pendiente'
  UNION ALL SELECT 'mateo.vargas@startuppagos.example', 'CRM startup pagos Mexico', 'Enviar plan inicial Startup Pagos', 'Propuesta ligera para equipo pequeno.', 'correo', DATE_ADD(CURDATE(), INTERVAL 11 DAY), '08:45:00', 'pendiente'
  UNION ALL SELECT 'isabella.navarro@biomedglobal.example', 'Gestion enterprise Biomed Global', 'Comite Biomed Global', 'Resolver dudas de seguridad, SLA y soporte.', 'reunion', DATE_ADD(CURDATE(), INTERVAL 12 DAY), '11:00:00', 'pendiente'
  UNION ALL SELECT 'andres.reyes@cafenorte.example', 'CRM exportaciones Cafe Norte', 'Onboarding Cafe Norte', 'Configurar usuarios y pipeline de exportaciones.', 'tarea', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:20:00', 'pendiente'
  UNION ALL SELECT 'lucia.paredes@retailmex.example', 'Reactivacion Retail MX 360', 'Seguimiento semestre Retail MX', 'Programar recordatorio para proxima ventana comercial.', 'tarea', DATE_ADD(CURDATE(), INTERVAL 45 DAY), '10:00:00', 'pendiente'
  UNION ALL SELECT 'tomas.arias@constructoraaurora.example', 'CRM proyectos constructora Aurora', 'Reunion Constructora Aurora', 'Presentar propuesta por etapas y roles.', 'reunion', DATE_ADD(CURDATE(), INTERVAL 14 DAY), '16:30:00', 'pendiente'
  UNION ALL SELECT 'diana.suarez@turismoglobal.example', 'Operacion regional Turismo Global', 'Capacitacion Turismo Global', 'Sesion para asesores regionales.', 'reunion', DATE_ADD(CURDATE(), INTERVAL 6 DAY), '09:00:00', 'pendiente'
  UNION ALL SELECT 'felipe.molina@consultoriab2b.example', 'Reactivacion consultoria B2B Norte', 'Registrar perdida Consultoria B2B', 'Documentar causa y fecha de reactivacion.', 'tarea', DATE_SUB(CURDATE(), INTERVAL 43 DAY), '16:45:00', 'completada'
  UNION ALL SELECT 'laura.gomez@example.com', 'Implementacion CRM basico', 'Preparar demo Acme', 'Configurar demo con contactos, pipeline y reportes.', 'tarea', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '08:00:00', 'pendiente'
  UNION ALL SELECT 'sebastian.ortiz@logisticapro.example', 'Seguimiento cuentas logisticas', 'Correo resumen Logistica Pro', 'Enviar minuta y propuesta comercial actualizada.', 'correo', DATE_ADD(CURDATE(), INTERVAL 4 DAY), '12:30:00', 'pendiente'
  UNION ALL SELECT 'isabella.navarro@biomedglobal.example', 'Gestion enterprise Biomed Global', 'Enviar documentacion seguridad Biomed', 'Compartir controles de acceso y proteccion de datos.', 'correo', DATE_ADD(CURDATE(), INTERVAL 3 DAY), '14:00:00', 'pendiente'
) data
JOIN contactos c ON c.correo = data.correo
LEFT JOIN oportunidades o ON o.titulo = data.oportunidad_titulo
WHERE NOT EXISTS (
  SELECT 1
  FROM actividades a
  WHERE a.titulo = data.titulo
    AND a.fecha = data.fecha
);

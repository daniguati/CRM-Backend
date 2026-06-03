USE crm_db;

INSERT INTO usuarios (nombre, email, password, rol)
VALUES (
  'Administrador CRM',
  'admin@crm.com',
  '$2b$10$CetXhnk2NhPvhEGVhQC4bOP22xuxFdzuRj/UhtSsm.m1WyUEprNfu',
  'admin'
)
ON DUPLICATE KEY UPDATE
  nombre = VALUES(nombre),
  rol = VALUES(rol);

INSERT INTO contactos (nombre, telefono, correo, empresa, notas, estado)
VALUES
  ('Laura Gomez', '3001234567', 'laura.gomez@example.com', 'Acme SAS', 'Interesada en automatizar seguimiento comercial.', 'lead'),
  ('Carlos Ruiz', '3019876543', 'carlos.ruiz@example.com', 'Soluciones Andinas', 'Cliente potencial para plan mensual.', 'cliente')
ON DUPLICATE KEY UPDATE
  nombre = VALUES(nombre);

INSERT INTO oportunidades (contacto_id, titulo, valor, etapa, probabilidad, fecha_cierre, notas)
SELECT id, 'Implementacion CRM basico', 2500000, 'propuesta', 60, DATE_ADD(CURDATE(), INTERVAL 20 DAY), 'Oportunidad de demo para el MVP.'
FROM contactos
WHERE correo = 'laura.gomez@example.com'
  AND NOT EXISTS (
    SELECT 1
    FROM oportunidades
    WHERE titulo = 'Implementacion CRM basico'
  )
LIMIT 1;

INSERT INTO actividades (contacto_id, titulo, descripcion, tipo, fecha, hora, estado)
SELECT id, 'Llamada de seguimiento', 'Confirmar necesidades y presupuesto.', 'llamada', CURDATE(), '10:00:00', 'pendiente'
FROM contactos
WHERE correo = 'laura.gomez@example.com'
  AND NOT EXISTS (
    SELECT 1
    FROM actividades
    WHERE titulo = 'Llamada de seguimiento'
      AND fecha = CURDATE()
  )
LIMIT 1;

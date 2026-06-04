CREATE DATABASE IF NOT EXISTS crm_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE crm_db;

CREATE TABLE IF NOT EXISTS usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL DEFAULT 'Usuario',
  email VARCHAR(150) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  rol ENUM('admin', 'asesor') NOT NULL DEFAULT 'admin',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SET @schema_name = DATABASE();

SET @has_nombre = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name
    AND TABLE_NAME = 'usuarios'
    AND COLUMN_NAME = 'nombre'
);
SET @sql = IF(
  @has_nombre = 0,
  'ALTER TABLE usuarios ADD COLUMN nombre VARCHAR(120) NOT NULL DEFAULT ''Usuario'' AFTER id',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_rol = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name
    AND TABLE_NAME = 'usuarios'
    AND COLUMN_NAME = 'rol'
);
SET @sql = IF(
  @has_rol = 0,
  'ALTER TABLE usuarios ADD COLUMN rol ENUM(''admin'', ''asesor'') NOT NULL DEFAULT ''admin'' AFTER password',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_usuarios_created_at = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name
    AND TABLE_NAME = 'usuarios'
    AND COLUMN_NAME = 'created_at'
);
SET @sql = IF(
  @has_usuarios_created_at = 0,
  'ALTER TABLE usuarios ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER rol',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_usuarios_updated_at = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name
    AND TABLE_NAME = 'usuarios'
    AND COLUMN_NAME = 'updated_at'
);
SET @sql = IF(
  @has_usuarios_updated_at = 0,
  'ALTER TABLE usuarios ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

ALTER TABLE usuarios
  MODIFY email VARCHAR(150) NOT NULL,
  MODIFY password VARCHAR(255) NOT NULL;

SET @duplicate_usuario_emails = (
  SELECT COUNT(*)
  FROM (
    SELECT email
    FROM usuarios
    GROUP BY email
    HAVING COUNT(*) > 1
  ) duplicated_usuario_emails
);
SET @has_usuario_email_unique = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = @schema_name
    AND TABLE_NAME = 'usuarios'
    AND COLUMN_NAME = 'email'
    AND NON_UNIQUE = 0
);
SET @sql = IF(
  @duplicate_usuario_emails = 0 AND @has_usuario_email_unique = 0,
  'ALTER TABLE usuarios ADD UNIQUE KEY uq_usuarios_email (email)',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS contactos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  telefono VARCHAR(40) NOT NULL,
  correo VARCHAR(150) NOT NULL UNIQUE,
  empresa VARCHAR(150),
  notas TEXT,
  estado ENUM('lead', 'cliente', 'inactivo') NOT NULL DEFAULT 'lead',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_contactos_nombre (nombre),
  INDEX idx_contactos_correo (correo),
  INDEX idx_contactos_estado (estado)
);

SET @has_contactos_estado = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name
    AND TABLE_NAME = 'contactos'
    AND COLUMN_NAME = 'estado'
);
SET @sql = IF(
  @has_contactos_estado = 0,
  'ALTER TABLE contactos ADD COLUMN estado ENUM(''lead'', ''cliente'', ''inactivo'') NOT NULL DEFAULT ''lead'' AFTER notas',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_contactos_created_at = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name
    AND TABLE_NAME = 'contactos'
    AND COLUMN_NAME = 'created_at'
);
SET @sql = IF(
  @has_contactos_created_at = 0,
  'ALTER TABLE contactos ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER estado',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_contactos_updated_at = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name
    AND TABLE_NAME = 'contactos'
    AND COLUMN_NAME = 'updated_at'
);
SET @sql = IF(
  @has_contactos_updated_at = 0,
  'ALTER TABLE contactos ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

ALTER TABLE contactos
  MODIFY nombre VARCHAR(150) NOT NULL,
  MODIFY telefono VARCHAR(40) NOT NULL,
  MODIFY correo VARCHAR(150) NOT NULL,
  MODIFY empresa VARCHAR(150) NULL,
  MODIFY notas TEXT NULL;

SET @duplicate_contacto_correos = (
  SELECT COUNT(*)
  FROM (
    SELECT correo
    FROM contactos
    GROUP BY correo
    HAVING COUNT(*) > 1
  ) duplicated_contacto_correos
);
SET @has_contacto_correo_unique = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = @schema_name
    AND TABLE_NAME = 'contactos'
    AND COLUMN_NAME = 'correo'
    AND NON_UNIQUE = 0
);
SET @sql = IF(
  @duplicate_contacto_correos = 0 AND @has_contacto_correo_unique = 0,
  'ALTER TABLE contactos ADD UNIQUE KEY uq_contactos_correo (correo)',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS oportunidades (
  id INT AUTO_INCREMENT PRIMARY KEY,
  contacto_id INT NULL,
  titulo VARCHAR(160) NOT NULL,
  valor DECIMAL(12, 2) NOT NULL DEFAULT 0,
  etapa ENUM('prospecto', 'propuesta', 'negociacion', 'ganada', 'perdida') NOT NULL DEFAULT 'prospecto',
  probabilidad TINYINT UNSIGNED NOT NULL DEFAULT 20,
  fecha_cierre DATE NULL,
  notas TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_oportunidades_contacto
    FOREIGN KEY (contacto_id) REFERENCES contactos(id)
    ON DELETE SET NULL,
  INDEX idx_oportunidades_etapa (etapa),
  INDEX idx_oportunidades_contacto (contacto_id)
);

CREATE TABLE IF NOT EXISTS actividades (
  id INT AUTO_INCREMENT PRIMARY KEY,
  contacto_id INT NULL,
  oportunidad_id INT NULL,
  titulo VARCHAR(160) NOT NULL,
  descripcion TEXT,
  tipo ENUM('llamada', 'reunion', 'correo', 'tarea') NOT NULL DEFAULT 'tarea',
  fecha DATE NOT NULL,
  hora TIME NULL,
  estado ENUM('pendiente', 'completada', 'cancelada') NOT NULL DEFAULT 'pendiente',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_actividades_contacto
    FOREIGN KEY (contacto_id) REFERENCES contactos(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_actividades_oportunidad
    FOREIGN KEY (oportunidad_id) REFERENCES oportunidades(id)
    ON DELETE SET NULL,
  INDEX idx_actividades_fecha (fecha),
  INDEX idx_actividades_estado (estado)
);

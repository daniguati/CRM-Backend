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

-- ============================================
-- Script de Inicialización de Base de Datos
-- Sistema de Comandas para Restaurantes
-- ============================================

-- Crear extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Crear esquemas
CREATE SCHEMA IF NOT EXISTS public;

-- Mensaje de confirmación
DO $$
BEGIN
  RAISE NOTICE 'Database initialized successfully for Restaurant Management System';
END $$;

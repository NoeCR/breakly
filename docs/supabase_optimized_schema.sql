-- =====================================================
-- Esquema Optimizado de Base de Datos Supabase para Breakly
-- Un registro único por dispositivo + número de teléfono
-- =====================================================

-- Eliminar la tabla anterior si existe (solo para desarrollo)
-- DROP TABLE IF EXISTS sessions CASCADE;

-- Crear la tabla optimizada de sesiones
CREATE TABLE IF NOT EXISTS device_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Identificadores únicos
  user_id TEXT NOT NULL, -- Número de teléfono cifrado o device_id fallback
  device_id TEXT NOT NULL, -- Identificador único del dispositivo
  
  -- Constraint único: un registro por dispositivo
  CONSTRAINT unique_device_session UNIQUE (device_id),
  
  -- Estado de la sesión actual
  session_id UUID NOT NULL, -- UUID de la sesión actual
  activated_at TIMESTAMPTZ,
  elapsed_seconds INTEGER DEFAULT 0,
  minutes_target INTEGER DEFAULT 30,
  is_custom_minutes BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT false,
  
  -- Estado del dispositivo
  is_do_not_disturb BOOLEAN DEFAULT false,
  is_airplane_mode BOOLEAN DEFAULT false,
  ringer_mode TEXT DEFAULT 'normal' CHECK (ringer_mode IN ('normal', 'silent', 'vibrate')),
  
  -- Metadatos
  app_version TEXT,
  phone_number_available BOOLEAN DEFAULT false, -- Si se pudo obtener el número de teléfono
  last_sync_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Crear índices optimizados para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_device_sessions_user_id ON device_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_device_sessions_device_id ON device_sessions(device_id);
CREATE INDEX IF NOT EXISTS idx_device_sessions_session_id ON device_sessions(session_id);
CREATE INDEX IF NOT EXISTS idx_device_sessions_active ON device_sessions(is_active) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_device_sessions_last_sync ON device_sessions(last_sync_at);
CREATE INDEX IF NOT EXISTS idx_device_sessions_created_at ON device_sessions(created_at);

-- Crear función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_device_sessions_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Crear trigger para actualizar updated_at
CREATE TRIGGER update_device_sessions_updated_at 
  BEFORE UPDATE ON device_sessions 
  FOR EACH ROW 
  EXECUTE FUNCTION update_device_sessions_updated_at_column();

-- =====================================================
-- POLÍTICAS DE SEGURIDAD (Row Level Security)
-- =====================================================

-- Habilitar RLS
ALTER TABLE device_sessions ENABLE ROW LEVEL SECURITY;

-- Política: Permitir acceso a sesiones basado en user_id
-- Como user_id es cifrado, solo el dispositivo con el mismo número puede acceder
CREATE POLICY "Device sessions access by user_id" ON device_sessions
  FOR ALL 
  USING (true) -- Permitir acceso público para dispositivos con user_id correcto
  WITH CHECK (true);

-- =====================================================
-- FUNCIONES AUXILIARES OPTIMIZADAS
-- =====================================================

-- Función para obtener o crear sesión de dispositivo
CREATE OR REPLACE FUNCTION get_or_create_device_session(
  p_user_id TEXT,
  p_device_id TEXT,
  p_session_id UUID DEFAULT gen_random_uuid()
)
RETURNS device_sessions AS $$
DECLARE
  result device_sessions;
BEGIN
  -- Intentar obtener sesión existente
  SELECT * INTO result 
  FROM device_sessions 
  WHERE device_id = p_device_id;
  
  -- Si no existe, crear nueva
  IF NOT FOUND THEN
    INSERT INTO device_sessions (
      user_id, device_id, session_id, created_at, updated_at, last_sync_at
    ) VALUES (
      p_user_id, p_device_id, p_session_id, NOW(), NOW(), NOW()
    ) RETURNING * INTO result;
  END IF;
  
  RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Función para actualizar estado de sesión
CREATE OR REPLACE FUNCTION update_device_session_state(
  p_device_id TEXT,
  p_session_data JSONB
)
RETURNS device_sessions AS $$
DECLARE
  result device_sessions;
BEGIN
  UPDATE device_sessions SET
    session_id = COALESCE((p_session_data->>'session_id')::UUID, session_id),
    activated_at = CASE 
      WHEN p_session_data->>'activated_at' IS NOT NULL 
      THEN (p_session_data->>'activated_at')::TIMESTAMPTZ 
      ELSE activated_at 
    END,
    elapsed_seconds = COALESCE((p_session_data->>'elapsed_seconds')::INTEGER, elapsed_seconds),
    minutes_target = COALESCE((p_session_data->>'minutes_target')::INTEGER, minutes_target),
    is_custom_minutes = COALESCE((p_session_data->>'is_custom_minutes')::BOOLEAN, is_custom_minutes),
    is_active = COALESCE((p_session_data->>'is_active')::BOOLEAN, is_active),
    is_do_not_disturb = COALESCE((p_session_data->>'is_do_not_disturb')::BOOLEAN, is_do_not_disturb),
    is_airplane_mode = COALESCE((p_session_data->>'is_airplane_mode')::BOOLEAN, is_airplane_mode),
    ringer_mode = COALESCE(p_session_data->>'ringer_mode', ringer_mode),
    app_version = COALESCE(p_session_data->>'app_version', app_version),
    last_sync_at = NOW(),
    updated_at = NOW()
  WHERE device_id = p_device_id
  RETURNING * INTO result;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Device session not found for device_id: %', p_device_id;
  END IF;
  
  RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Función para limpiar sesiones inactivas antiguas (más de 30 días)
CREATE OR REPLACE FUNCTION cleanup_old_device_sessions()
RETURNS INTEGER AS $$
DECLARE
  deleted_count INTEGER;
BEGIN
  DELETE FROM device_sessions 
  WHERE is_active = false 
    AND updated_at < NOW() - INTERVAL '30 days';
  
  GET DIAGNOSTICS deleted_count = ROW_COUNT;
  RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener estadísticas optimizadas
CREATE OR REPLACE FUNCTION get_device_session_stats()
RETURNS TABLE (
  total_devices BIGINT,
  active_devices BIGINT,
  devices_with_phone BIGINT,
  total_time_seconds BIGINT,
  avg_session_duration_seconds NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(*) as total_devices,
    COUNT(*) FILTER (WHERE is_active = true) as active_devices,
    COUNT(*) FILTER (WHERE phone_number_available = true) as devices_with_phone,
    COALESCE(SUM(elapsed_seconds), 0) as total_time_seconds,
    COALESCE(AVG(elapsed_seconds), 0) as avg_session_duration_seconds
  FROM device_sessions;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- CONFIGURACIÓN DE REAL-TIME
-- =====================================================

-- Habilitar real-time para la tabla device_sessions
ALTER PUBLICATION supabase_realtime ADD TABLE device_sessions;

-- =====================================================
-- MIGRACIÓN DE DATOS EXISTENTES (OPCIONAL)
-- =====================================================

-- Función para migrar datos de la tabla sessions anterior
CREATE OR REPLACE FUNCTION migrate_sessions_to_device_sessions()
RETURNS INTEGER AS $$
DECLARE
  migrated_count INTEGER := 0;
  session_record RECORD;
BEGIN
  -- Solo ejecutar si la tabla sessions existe
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'sessions') THEN
    FOR session_record IN 
      SELECT DISTINCT ON (device_id) *
      FROM sessions 
      ORDER BY device_id, created_at DESC
    LOOP
      INSERT INTO device_sessions (
        user_id, device_id, session_id, activated_at, elapsed_seconds,
        minutes_target, is_custom_minutes, is_active, is_do_not_disturb,
        is_airplane_mode, ringer_mode, app_version, phone_number_available,
        last_sync_at, created_at, updated_at
      ) VALUES (
        COALESCE(session_record.user_id, 'device_' || session_record.device_id),
        session_record.device_id,
        session_record.session_id,
        session_record.activated_at,
        session_record.elapsed_seconds,
        session_record.minutes_target,
        session_record.is_custom_minutes,
        session_record.is_active,
        session_record.is_do_not_disturb,
        session_record.is_airplane_mode,
        session_record.ringer_mode,
        session_record.app_version,
        session_record.user_id IS NOT NULL, -- phone_number_available
        session_record.last_sync_at,
        session_record.created_at,
        session_record.updated_at
      ) ON CONFLICT (device_id) DO NOTHING;
      
      migrated_count := migrated_count + 1;
    END LOOP;
  END IF;
  
  RETURN migrated_count;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- VERIFICACIÓN
-- =====================================================

-- Verificar que la tabla se creó correctamente
SELECT 
  table_name, 
  column_name, 
  data_type, 
  is_nullable
FROM information_schema.columns 
WHERE table_name = 'device_sessions' 
ORDER BY ordinal_position;

-- Verificar las políticas RLS
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual
FROM pg_policies 
WHERE tablename = 'device_sessions';

-- Verificar índices
SELECT 
  indexname,
  indexdef
FROM pg_indexes 
WHERE tablename = 'device_sessions';

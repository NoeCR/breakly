-- =====================================================
-- Configuración de Base de Datos Supabase para Breakly
-- =====================================================

-- Crear la tabla de sesiones
CREATE TABLE IF NOT EXISTS sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  device_id TEXT NOT NULL,
  session_id UUID NOT NULL UNIQUE,
  
  -- Estado de la sesión
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
  last_sync_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Crear índices para optimización
CREATE INDEX IF NOT EXISTS idx_sessions_user_id ON sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_device_id ON sessions(device_id);
CREATE INDEX IF NOT EXISTS idx_sessions_session_id ON sessions(session_id);
CREATE INDEX IF NOT EXISTS idx_sessions_active ON sessions(is_active) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_sessions_last_sync ON sessions(last_sync_at);
CREATE INDEX IF NOT EXISTS idx_sessions_created_at ON sessions(created_at);

-- Crear función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Crear trigger para actualizar updated_at
CREATE TRIGGER update_sessions_updated_at 
  BEFORE UPDATE ON sessions 
  FOR EACH ROW 
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- POLÍTICAS DE SEGURIDAD (Row Level Security)
-- =====================================================

-- Habilitar RLS
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;

-- Política: Los usuarios autenticados pueden ver sus propias sesiones
CREATE POLICY "Users can view own sessions" ON sessions
  FOR SELECT 
  USING (
    auth.uid() = user_id OR 
    user_id IS NULL -- Permitir sesiones anónimas
  );

-- Política: Los usuarios autenticados pueden insertar sus propias sesiones
CREATE POLICY "Users can insert own sessions" ON sessions
  FOR INSERT 
  WITH CHECK (
    auth.uid() = user_id OR 
    user_id IS NULL -- Permitir sesiones anónimas
  );

-- Política: Los usuarios autenticados pueden actualizar sus propias sesiones
CREATE POLICY "Users can update own sessions" ON sessions
  FOR UPDATE 
  USING (
    auth.uid() = user_id OR 
    user_id IS NULL -- Permitir sesiones anónimas
  )
  WITH CHECK (
    auth.uid() = user_id OR 
    user_id IS NULL -- Permitir sesiones anónimas
  );

-- Política: Los usuarios autenticados pueden eliminar sus propias sesiones
CREATE POLICY "Users can delete own sessions" ON sessions
  FOR DELETE 
  USING (
    auth.uid() = user_id OR 
    user_id IS NULL -- Permitir sesiones anónimas
  );

-- =====================================================
-- FUNCIONES AUXILIARES
-- =====================================================

-- Función para limpiar sesiones inactivas antiguas (más de 7 días)
CREATE OR REPLACE FUNCTION cleanup_old_sessions()
RETURNS INTEGER AS $$
DECLARE
  deleted_count INTEGER;
BEGIN
  DELETE FROM sessions 
  WHERE is_active = false 
    AND updated_at < NOW() - INTERVAL '7 days';
  
  GET DIAGNOSTICS deleted_count = ROW_COUNT;
  RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener estadísticas de sesiones
CREATE OR REPLACE FUNCTION get_session_stats(user_uuid UUID DEFAULT NULL)
RETURNS TABLE (
  total_sessions BIGINT,
  active_sessions BIGINT,
  total_time_seconds BIGINT,
  avg_session_duration_seconds NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(*) as total_sessions,
    COUNT(*) FILTER (WHERE is_active = true) as active_sessions,
    COALESCE(SUM(elapsed_seconds), 0) as total_time_seconds,
    COALESCE(AVG(elapsed_seconds), 0) as avg_session_duration_seconds
  FROM sessions 
  WHERE (user_uuid IS NULL OR user_id = user_uuid);
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- CONFIGURACIÓN DE REAL-TIME
-- =====================================================

-- Habilitar real-time para la tabla sessions
ALTER PUBLICATION supabase_realtime ADD TABLE sessions;

-- =====================================================
-- DATOS DE PRUEBA (OPCIONAL - SOLO PARA DESARROLLO)
-- =====================================================

-- Insertar datos de prueba (comentar en producción)
/*
INSERT INTO sessions (
  device_id, 
  session_id, 
  activated_at, 
  elapsed_seconds, 
  minutes_target, 
  is_active,
  is_do_not_disturb
) VALUES (
  'test_device_123',
  gen_random_uuid(),
  NOW() - INTERVAL '10 minutes',
  600,
  30,
  true,
  true
);
*/

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
WHERE table_name = 'sessions' 
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
WHERE tablename = 'sessions';


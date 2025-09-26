# Análisis de Requerimientos - Persistencia Remota del Estado del Dispositivo

## 📋 Resumen Ejecutivo

**Objetivo**: Implementar persistencia remota del estado de la sesión actual del dispositivo usando Supabase, permitiendo sincronización entre dispositivos y recuperación de sesiones.

**Alcance**: Solo la sesión actual (no historial de sesiones).

**Tecnología**: Supabase (PostgreSQL + Real-time + Auth).

---

## 🎯 Datos a Persistir

### Estado de la Sesión Actual
Basado en el análisis del código existente, necesitamos persistir:

#### 1. **SessionState**
```dart
{
  "activatedAt": "2024-01-15T10:30:00Z",     // Timestamp de inicio
  "elapsed": "00:15:30",                     // Tiempo transcurrido
  "minutesTarget": 30,                       // Objetivo en minutos
  "isCustomMinutes": false                   // Si es duración personalizada
}
```

#### 2. **DeviceModeState**
```dart
{
  "isDoNotDisturb": true,                    // Modo no molestar activo
  "isAirplaneMode": false,                   // Modo avión activo
  "ringerMode": "silent"                     // Modo del timbre (normal/silent/vibrate)
}
```

#### 3. **Metadatos de Sesión**
```dart
{
  "sessionId": "uuid-v4",                    // ID único de sesión
  "deviceId": "device-identifier",           // Identificador del dispositivo
  "userId": "user-uuid",                     // ID del usuario (opcional)
  "lastSyncAt": "2024-01-15T10:45:00Z",     // Última sincronización
  "isActive": true,                          // Si la sesión está activa
  "appVersion": "1.0.0"                     // Versión de la app
}
```

---

## 🗄️ Diseño de Base de Datos

### Tabla: `sessions`
```sql
CREATE TABLE sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
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
  ringer_mode TEXT DEFAULT 'normal',
  
  -- Metadatos
  app_version TEXT,
  last_sync_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices para optimización
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_device_id ON sessions(device_id);
CREATE INDEX idx_sessions_active ON sessions(is_active) WHERE is_active = true;
CREATE INDEX idx_sessions_last_sync ON sessions(last_sync_at);
```

### Políticas de Seguridad (RLS)
```sql
-- Habilitar RLS
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;

-- Los usuarios solo pueden ver sus propias sesiones
CREATE POLICY "Users can view own sessions" ON sessions
  FOR SELECT USING (auth.uid() = user_id);

-- Los usuarios solo pueden insertar sus propias sesiones
CREATE POLICY "Users can insert own sessions" ON sessions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Los usuarios solo pueden actualizar sus propias sesiones
CREATE POLICY "Users can update own sessions" ON sessions
  FOR UPDATE USING (auth.uid() = user_id);

-- Los usuarios solo pueden eliminar sus propias sesiones
CREATE POLICY "Users can delete own sessions" ON sessions
  FOR DELETE USING (auth.uid() = user_id);
```

---

## 🔄 Flujos de Sincronización

### 1. **Sincronización al Iniciar Sesión**
```
App Start → Check Remote Session → Merge with Local → Update UI
```

### 2. **Sincronización Durante la Sesión**
```
Timer Tick → Update Local State → Sync to Remote → Handle Conflicts
```

### 3. **Sincronización al Finalizar Sesión**
```
Session End → Final Sync → Mark as Inactive → Cleanup
```

### 4. **Recuperación de Sesión**
```
App Start → Check for Active Remote Session → Restore State → Continue Session
```

---

## 🛠️ Arquitectura Técnica

### Interfaces a Crear
```dart
// lib/interfaces/remote_session_repository.dart
abstract class RemoteSessionRepository {
  Future<SessionData?> getActiveSession(String deviceId);
  Future<void> createSession(SessionData session);
  Future<void> updateSession(String sessionId, SessionData session);
  Future<void> endSession(String sessionId);
  Stream<SessionData> watchSession(String sessionId);
}
```

### Servicios a Implementar
```dart
// lib/services/supabase_session_repository.dart
class SupabaseSessionRepository implements RemoteSessionRepository {
  // Implementación usando Supabase client
}
```

### Integración con Notifier
```dart
// Modificar BreaklyNotifier para incluir sincronización remota
class BreaklyNotifier extends StateNotifier<AppState> {
  final RemoteSessionRepository _remoteRepository;
  
  // Métodos de sincronización
  Future<void> _syncToRemote();
  Future<void> _loadFromRemote();
  Future<void> _handleSyncConflict();
}
```

---

## 📱 Casos de Uso

### 1. **Usuario Inicia Sesión en Dispositivo A**
- App crea sesión local
- Sincroniza con Supabase
- Otros dispositivos pueden ver la sesión activa

### 2. **Usuario Cambia a Dispositivo B**
- App detecta sesión activa remota
- Restaura estado desde Supabase
- Continúa la sesión donde la dejó

### 3. **Sesión Activa en Múltiples Dispositivos**
- Último dispositivo en actualizar gana
- Resolución de conflictos por timestamp
- Notificación al usuario sobre conflicto

### 4. **Pérdida de Conectividad**
- App funciona offline con estado local
- Sincronización automática al recuperar conexión
- Manejo de conflictos al reconectar

---

## 🔒 Consideraciones de Seguridad

### 1. **Autenticación**
- Opcional: Usuario puede usar app sin cuenta
- Con cuenta: Sincronización entre dispositivos
- Sin cuenta: Solo persistencia local + backup remoto anónimo

### 2. **Privacidad**
- Datos de sesión no contienen información personal
- Solo estado técnico del dispositivo y app
- Cifrado en tránsito (HTTPS)

### 3. **Rate Limiting**
- Límite de actualizaciones por minuto
- Debouncing de actualizaciones frecuentes
- Optimización de queries

---

## 🚀 Plan de Implementación

### Fase 1: Infraestructura Base
1. Configurar Supabase project
2. Crear tabla y políticas
3. Agregar dependencias Flutter

### Fase 2: Servicios Core
1. Implementar RemoteSessionRepository
2. Crear modelos de datos
3. Configurar autenticación básica

### Fase 3: Integración
1. Modificar BreaklyNotifier
2. Implementar sincronización
3. Agregar manejo de errores

### Fase 4: UI/UX
1. Indicadores de sincronización
2. Manejo de conflictos
3. Configuración de usuario

### Fase 5: Testing
1. Tests unitarios
2. Tests de integración
3. Tests de conectividad

---

## 📊 Métricas de Éxito

- **Disponibilidad**: 99.9% uptime de sincronización
- **Latencia**: < 2 segundos para sincronización
- **Conflicto Rate**: < 1% de sesiones con conflictos
- **User Experience**: Transición transparente entre dispositivos
- **Performance**: < 100ms overhead en operaciones locales

---

## 🔄 Próximos Pasos

1. **Configurar proyecto Supabase**
2. **Diseñar esquema de base de datos**
3. **Implementar interfaces y servicios**
4. **Integrar con notifier existente**
5. **Testing y validación**

---

*Documento creado: $(date)*
*Versión: 1.0*
*Autor: AI Assistant*


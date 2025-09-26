# Guía de Configuración de Supabase para Breakly

## 📋 Pasos para Configurar Supabase

### 1. Crear Proyecto en Supabase

1. Ve a [supabase.com](https://supabase.com)
2. Crea una cuenta o inicia sesión
3. Haz clic en "New Project"
4. Completa la información:
   - **Name**: `breakly`
   - **Database Password**: Genera una contraseña segura
   - **Region**: Elige la región más cercana
5. Haz clic en "Create new project"

### 2. Configurar la Base de Datos

1. Ve a la sección **SQL Editor** en tu dashboard de Supabase
2. Copia y pega el contenido del archivo `docs/supabase_setup.sql`
3. Ejecuta el script SQL
4. Verifica que la tabla `sessions` se haya creado correctamente

### 3. Obtener Credenciales

1. Ve a **Settings** → **API**
2. Copia los siguientes valores:
   - **Project URL** (ej: `https://xxxxx.supabase.co`)
   - **anon public** key (clave pública anónima)

### 4. Configurar la Aplicación Flutter

1. Abre `lib/config/supabase_config.dart`
2. Reemplaza los valores placeholder:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://tu-proyecto.supabase.co';
  static const String supabaseAnonKey = 'tu-clave-anonima-aqui';
  // ... resto del código
}
```

### 5. Configurar Autenticación (Opcional)

Si quieres habilitar autenticación de usuarios:

1. Ve a **Authentication** → **Settings**
2. Configura los proveedores que desees (email, Google, etc.)
3. Ajusta las políticas de RLS según tus necesidades

### 6. Configurar Real-time (Opcional)

Para sincronización en tiempo real:

1. Ve a **Database** → **Replication**
2. Asegúrate de que la tabla `sessions` esté habilitada para real-time
3. O ejecuta: `ALTER PUBLICATION supabase_realtime ADD TABLE sessions;`

## 🔧 Configuración de Desarrollo vs Producción

### Desarrollo
```dart
static Future<void> initialize() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
    debug: true, // Habilitar logs de debug
  );
}
```

### Producción
```dart
static Future<void> initialize() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
    debug: false, // Deshabilitar logs
  );
}
```

## 🔒 Consideraciones de Seguridad

### Variables de Entorno (Recomendado)

Para mayor seguridad, usa variables de entorno:

1. Crea un archivo `.env` en la raíz del proyecto:
```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-clave-anonima
```

2. Agrega `.env` al `.gitignore`

3. Usa el paquete `flutter_dotenv` para cargar las variables

### Políticas RLS

Las políticas configuradas permiten:
- ✅ Usuarios autenticados pueden gestionar sus propias sesiones
- ✅ Sesiones anónimas (sin usuario) funcionan normalmente
- ❌ Usuarios no pueden acceder a sesiones de otros usuarios

## 📊 Monitoreo y Mantenimiento

### Limpieza Automática

La función `cleanup_old_sessions()` elimina sesiones inactivas de más de 7 días.

Para ejecutarla manualmente:
```sql
SELECT cleanup_old_sessions();
```

### Estadísticas

Obtener estadísticas de sesiones:
```sql
-- Para un usuario específico
SELECT * FROM get_session_stats('user-uuid-here');

-- Para todos los usuarios
SELECT * FROM get_session_stats();
```

## 🚨 Solución de Problemas

### Error: "relation 'sessions' does not exist"
- Verifica que ejecutaste el script SQL completo
- Asegúrate de estar en el proyecto correcto

### Error: "permission denied for table sessions"
- Verifica que las políticas RLS están configuradas
- Asegúrate de que el usuario está autenticado (si es requerido)

### Error: "real-time subscription failed"
- Verifica que real-time está habilitado para la tabla
- Revisa la configuración de replicación

## 📱 Testing

### Datos de Prueba

Para testing, puedes insertar datos de prueba:

```sql
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
```

### Verificación

Verifica que todo funciona:

```sql
-- Ver todas las sesiones
SELECT * FROM sessions;

-- Ver sesiones activas
SELECT * FROM sessions WHERE is_active = true;

-- Ver estadísticas
SELECT * FROM get_session_stats();
```

## 🔄 Próximos Pasos

Una vez configurado Supabase:

1. ✅ Implementar `SupabaseSessionRepository`
2. ✅ Integrar con `BreaklyNotifier`
3. ✅ Agregar indicadores de sincronización en UI
4. ✅ Testing completo
5. ✅ Deploy a producción

---

*Documento creado: $(date)*
*Versión: 1.0*


# Explicación de las Claves de Supabase

## 🔑 Tipos de Claves en Supabase

Supabase proporciona diferentes tipos de claves para diferentes propósitos. Es importante entender cuál usar en cada caso.

### 1. **Publishable Key** (Recomendada para Apps Móviles)

**¿Qué es?**
- Clave optimizada para aplicaciones cliente (móviles, desktop, web)
- Diseñada específicamente para ser expuesta en el lado del cliente
- Optimizada para rendimiento en aplicaciones móviles

**¿Cuándo usarla?**
- ✅ Aplicaciones Flutter (móviles)
- ✅ Aplicaciones de escritorio
- ✅ Aplicaciones web del lado del cliente
- ✅ Cualquier aplicación que se ejecute en el dispositivo del usuario

**¿Dónde encontrarla?**
1. Ve a tu proyecto en Supabase
2. Settings → API
3. Busca "publishable" key

### 2. **Anon Key** (Clave Pública Tradicional)

**¿Qué es?**
- Clave pública tradicional de Supabase
- Funciona en aplicaciones cliente
- Menos optimizada que la publishable key

**¿Cuándo usarla?**
- ✅ Como fallback si no hay publishable key
- ✅ Aplicaciones web tradicionales
- ✅ Compatibilidad con versiones anteriores

**¿Dónde encontrarla?**
1. Ve a tu proyecto en Supabase
2. Settings → API
3. Busca "anon public" key

### 3. **Service Role Key** (⚠️ NUNCA en Cliente)

**¿Qué es?**
- Clave con permisos administrativos completos
- Omite todas las políticas de seguridad (RLS)
- Acceso total a la base de datos

**¿Cuándo usarla?**
- ✅ Solo en backend/servidor
- ✅ Scripts de administración
- ✅ Procesos del lado del servidor
- ❌ **NUNCA** en aplicaciones cliente

**⚠️ ADVERTENCIA**: Esta clave nunca debe estar en aplicaciones móviles o web del lado del cliente.

## 🎯 Para Breakly (Aplicación Flutter)

### Configuración Recomendada

```env
# Usar publishable key (recomendada)
SUPABASE_PUBLISHABLE_KEY=tu-publishable-key-aqui

# O como fallback, anon key
SUPABASE_ANON_KEY=tu-anon-key-aqui
```

### ¿Por qué Publishable Key?

1. **Optimización**: Diseñada específicamente para apps móviles
2. **Rendimiento**: Mejor rendimiento en dispositivos móviles
3. **Recomendación**: Supabase recomienda explícitamente su uso
4. **Futuro**: Es la dirección que está tomando Supabase

## 🔧 Configuración en el Código

Nuestro código está configurado para usar la publishable key con fallback a anon key:

```dart
// lib/config/supabase_config.dart
_supabaseAnonKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? 
                  dotenv.env['SUPABASE_ANON_KEY']; // Fallback
```

Esto significa que:
1. **Primero** intenta usar `SUPABASE_PUBLISHABLE_KEY`
2. **Si no existe**, usa `SUPABASE_ANON_KEY` como fallback
3. **Si ninguna existe**, muestra un error claro

## 📱 Mensaje de Supabase

Cuando ves este mensaje en Supabase:
> "prefer publishable key instead of anon key for mobile and desktop apps"

Significa que:
- Supabase detectó que estás usando anon key
- Te recomienda cambiar a publishable key
- La publishable key está optimizada para tu caso de uso

## 🚀 Migración

### Si ya tienes anon key configurada:

1. **No es urgente**: La anon key sigue funcionando
2. **Recomendado**: Cambiar a publishable key cuando sea conveniente
3. **Pasos**:
   - Obtén la publishable key de Supabase
   - Actualiza tu archivo `.env`
   - Cambia `SUPABASE_ANON_KEY` por `SUPABASE_PUBLISHABLE_KEY`

### Si estás empezando:

1. **Usa publishable key** desde el principio
2. **Configura** `SUPABASE_PUBLISHABLE_KEY` en tu `.env`
3. **No necesitas** configurar anon key

## 🔒 Seguridad

### Todas las claves públicas son seguras para usar en cliente:

- ✅ **Publishable Key**: Segura para cliente
- ✅ **Anon Key**: Segura para cliente
- ❌ **Service Role Key**: NUNCA en cliente

### ¿Por qué son seguras?

- Dependen de **Row Level Security (RLS)** para proteger datos
- No tienen permisos administrativos
- Están diseñadas para ser expuestas públicamente
- Las políticas de seguridad las controlan

## 📚 Referencias

- [Documentación oficial de Supabase](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)
- [API Keys en Supabase](https://supabase.com/docs/guides/api/api-keys)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

---

*Documento creado: $(date)*
*Versión: 1.0*


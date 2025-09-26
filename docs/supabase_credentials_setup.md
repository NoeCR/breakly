# Configuración Segura de Credenciales de Supabase

## 🔐 Configuración de Variables de Entorno

Para mantener las credenciales de Supabase seguras y no exponerlas en el repositorio, hemos implementado un sistema de variables de entorno.

### 📋 Pasos para Configurar

#### 1. **Crear el archivo .env**

Copia el archivo de ejemplo y crea tu archivo de configuración:

```bash
# En la raíz del proyecto
cp env.example .env
```

#### 2. **Configurar las Credenciales**

Edita el archivo `.env` con tus credenciales reales:

```env
# Supabase Configuration
SUPABASE_URL=https://tu-proyecto-id.supabase.co
SUPABASE_PUBLISHABLE_KEY=tu-clave-publishable-aqui
ENVIRONMENT=development
```

#### 3. **Obtener las Credenciales de Supabase**

1. Ve a tu proyecto en [supabase.com](https://supabase.com)
2. Ve a **Settings** → **API**
3. Copia los siguientes valores:
   - **Project URL** → `SUPABASE_URL`
   - **publishable** key → `SUPABASE_PUBLISHABLE_KEY` (recomendada para apps móviles)
   - **anon public** key → `SUPABASE_ANON_KEY` (fallback, si no hay publishable)

#### 4. **Diferencias entre las Claves**

- **Publishable Key**: Recomendada para aplicaciones móviles y de escritorio. Optimizada para clientes.
- **Anon Key**: Clave pública tradicional. Funciona como fallback si no hay publishable key.
- **Service Role Key**: ⚠️ **NUNCA** la uses en aplicaciones cliente. Solo para backend/servidor.

> **Nota**: Supabase muestra el mensaje "prefer publishable key instead of anon key for mobile and desktop apps" porque la publishable key está optimizada para aplicaciones cliente.

### 🛡️ Seguridad

#### ✅ **Lo que SÍ se incluye en el repositorio:**
- `env.example` - Plantilla con valores de ejemplo
- `lib/config/supabase_config.dart` - Código de configuración
- `docs/supabase_credentials_setup.md` - Esta documentación

#### ❌ **Lo que NO se incluye en el repositorio:**
- `.env` - Archivo con credenciales reales
- `.env.local` - Archivos de configuración local
- Cualquier archivo con credenciales reales

### 🔧 Configuración por Entorno

#### **Desarrollo**
```env
ENVIRONMENT=development
```
- Habilita logs de debug
- Muestra información adicional de errores

#### **Producción**
```env
ENVIRONMENT=production
```
- Deshabilita logs de debug
- Configuración optimizada para producción

### 🚨 Solución de Problemas

#### **Error: "SUPABASE_URL no está configurada"**
- Verifica que el archivo `.env` existe en la raíz del proyecto
- Asegúrate de que `SUPABASE_URL` esté definida en el archivo

#### **Error: "SUPABASE_PUBLISHABLE_KEY no está configurada"**
- Verifica que `SUPABASE_PUBLISHABLE_KEY` esté definida en el archivo `.env`
- Como fallback, también puedes usar `SUPABASE_ANON_KEY`
- Asegúrate de que la clave sea la correcta de tu proyecto

#### **Error: "Supabase no ha sido inicializado"**
- Verifica que `SupabaseConfig.initialize()` se llame en `main()`
- Asegúrate de que las credenciales sean válidas

### 📱 Configuración para Diferentes Entornos

#### **Para el Equipo de Desarrollo:**

1. Cada desarrollador debe crear su propio archivo `.env`
2. Usar el mismo proyecto de Supabase o crear uno para desarrollo
3. Nunca compartir el archivo `.env` por email o chat

#### **Para CI/CD:**

```yaml
# GitHub Actions / GitLab CI
env:
  SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
  SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_ANON_KEY }}
  ENVIRONMENT: production
```

#### **Para Deploy en Producción:**

1. Configurar variables de entorno en la plataforma de deploy
2. No incluir archivo `.env` en el build de producción
3. Usar variables de entorno del sistema

### 🔄 Migración desde Configuración Hardcodeada

Si ya tienes credenciales hardcodeadas:

1. **Crear archivo .env** con las credenciales actuales
2. **Actualizar código** para usar `SupabaseConfig`
3. **Verificar funcionamiento** en desarrollo
4. **Hacer commit** solo del código (sin .env)
5. **Configurar** variables de entorno en producción

### 📚 Ejemplo de Uso

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase con variables de entorno
  await SupabaseConfig.initialize();
  
  runApp(const ProviderScope(child: MyApp()));
}

// En cualquier parte de la app
final client = SupabaseConfig.client;
final isDev = SupabaseConfig.isDevelopment;
```

### 🎯 Beneficios de esta Configuración

- ✅ **Seguridad**: Credenciales no expuestas en el código
- ✅ **Flexibilidad**: Diferentes configuraciones por entorno
- ✅ **Mantenibilidad**: Fácil cambio de credenciales
- ✅ **Colaboración**: Cada desarrollador puede tener su configuración
- ✅ **CI/CD**: Integración fácil con pipelines de deploy

---

*Documento creado: $(date)*
*Versión: 1.0*

# 🚀 Configuración Rápida de Supabase

## ⚡ Solución al Problema: "No se ha creado la tabla en Supabase"

### 🔍 **Diagnóstico**
El problema es que **no tienes configurado el archivo `.env`** con las credenciales de Supabase, por lo que la aplicación no puede conectarse a la base de datos.

---

## 📋 **Solución en 4 Pasos**

### **Paso 1: Crear Proyecto en Supabase** (si no lo tienes)

1. Ve a [supabase.com](https://supabase.com)
2. Crea una cuenta o inicia sesión
3. Haz clic en **"New Project"**
4. Completa:
   - **Name**: `breakly`
   - **Database Password**: Genera una contraseña segura
   - **Region**: Elige la región más cercana
5. Haz clic en **"Create new project"**

### **Paso 2: Obtener Credenciales**

1. En tu dashboard de Supabase, ve a **Settings** → **API**
2. Copia estos valores:
   - **Project URL** (ej: `https://xxxxx.supabase.co`)
   - **anon public** key (clave pública anónima)

### **Paso 3: Configurar la Aplicación**

**Opción A - Script Automático (Recomendado):**
```bash
# En Windows
scripts\setup_supabase.bat

# En Linux/Mac
./scripts/setup_supabase.sh
```

**Opción B - Manual:**
1. Crea un archivo `.env` en la raíz del proyecto
2. Agrega este contenido:
```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_PUBLISHABLE_KEY=tu-clave-anonima-aqui
ENVIRONMENT=development
```

### **Paso 4: Crear la Tabla en Supabase**

1. Ve a **SQL Editor** en tu dashboard de Supabase
2. Copia todo el contenido del archivo `docs/supabase_setup.sql`
3. Pégalo en el editor SQL
4. Haz clic en **"Run"**
5. Verifica que aparezca el mensaje de éxito

---

## ✅ **Verificación**

Para verificar que todo funciona:

1. **Ejecuta la aplicación:**
   ```bash
   flutter pub get
   flutter run
   ```

2. **Verifica en Supabase:**
   - Ve a **Table Editor**
   - Deberías ver la tabla `sessions`
   - Haz clic en ella para ver su estructura

3. **Prueba la funcionalidad:**
   - Activa el modo DND en tu dispositivo
   - La aplicación debería sincronizar con Supabase
   - Verifica en la tabla `sessions` que se creó un registro

---

## 🚨 **Solución de Problemas**

### Error: "SUPABASE_URL no está configurada"
- ✅ Verifica que el archivo `.env` existe
- ✅ Verifica que `SUPABASE_URL` tiene el valor correcto

### Error: "relation 'sessions' does not exist"
- ✅ Ejecuta el script SQL completo en Supabase
- ✅ Verifica que estás en el proyecto correcto

### Error: "permission denied"
- ✅ Verifica que las políticas RLS están configuradas
- ✅ El script SQL incluye las políticas automáticamente

---

## 📱 **Resultado Esperado**

Una vez configurado correctamente:

1. ✅ El icono del reloj se oculta en modo DND
2. ✅ La aplicación se conecta a Supabase
3. ✅ Las sesiones se sincronizan automáticamente
4. ✅ Puedes ver los datos en la tabla `sessions`

---

*¿Necesitas ayuda? Revisa los logs de la aplicación o contacta al equipo de desarrollo.*

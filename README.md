# Breakly

Una aplicación Flutter para sesiones de trabajo sin interrupciones con sincronización remota.

## 🚀 Características

- **Modo sin interrupciones**: Activa automáticamente el modo no molestar
- **Sesiones personalizables**: Duración configurable (30, 60, 90 minutos o personalizada)
- **Notificaciones**: Alerta cuando termina la sesión
- **Sincronización remota**: Estado sincronizado entre dispositivos usando Supabase
- **Arquitectura limpia**: Implementada con Riverpod y principios SOLID

## 📋 Requisitos Previos

- Flutter SDK (versión 3.7.2 o superior)
- Cuenta en [Supabase](https://supabase.com)
- Android Studio / VS Code
- Git

## ⚙️ Configuración

### 1. Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/breakly.git
cd breakly
```

### 2. Instalar Dependencias

```bash
flutter pub get
```

### 3. Configurar Supabase

#### Opción A: Script Automático (Recomendado)

**En Windows:**
```bash
scripts\setup_env.bat
```

**En Linux/Mac:**
```bash
chmod +x scripts/setup_env.sh
./scripts/setup_env.sh
```

#### Opción B: Manual

1. Copia el archivo de ejemplo:
```bash
cp env.example .env
```

2. Edita el archivo `.env` con tus credenciales:
```env
SUPABASE_URL=https://tu-proyecto-id.supabase.co
SUPABASE_PUBLISHABLE_KEY=tu-clave-publishable-aqui
ENVIRONMENT=development
```

3. Obtén las credenciales de [Supabase Dashboard](https://supabase.com/dashboard)

### 4. Configurar Base de Datos

1. Ve a tu proyecto en Supabase
2. Abre el **SQL Editor**
3. Copia y ejecuta el contenido de `docs/supabase_setup.sql`

### 5. Ejecutar la Aplicación

```bash
flutter run
```

## 📚 Documentación

- [Configuración de Credenciales](docs/supabase_credentials_setup.md)
- [Análisis de Requerimientos](docs/requirements_analysis.md)
- [Guía de Setup de Supabase](docs/supabase_setup_guide.md)

## 🏗️ Arquitectura

```
lib/
├── config/           # Configuración de Supabase
├── interfaces/       # Contratos de servicios
├── models/          # Modelos de datos (Freezed)
├── services/        # Implementaciones de servicios
├── notifiers/       # State management (Riverpod)
├── widgets/         # Componentes UI reutilizables
└── main.dart        # Punto de entrada
```

## 🔧 Tecnologías Utilizadas

- **Flutter**: Framework de UI
- **Riverpod**: State management
- **Supabase**: Backend y sincronización
- **Freezed**: Generación de código
- **SharedPreferences**: Persistencia local
- **flutter_local_notifications**: Notificaciones

## 🚨 Solución de Problemas

### Error de Credenciales
- Verifica que el archivo `.env` existe y tiene las credenciales correctas
- Asegúrate de que las credenciales sean de tu proyecto de Supabase

### Error de Base de Datos
- Verifica que ejecutaste el script SQL en Supabase
- Comprueba que las políticas RLS están configuradas

### Error de Notificaciones
- Verifica permisos de notificaciones en el dispositivo
- Comprueba que las notificaciones están habilitadas en la app

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 📞 Soporte

Si tienes problemas o preguntas:

1. Revisa la [documentación](docs/)
2. Busca en [Issues](https://github.com/tu-usuario/breakly/issues)
3. Crea un nuevo issue si no encuentras la solución

---

**⚠️ Importante**: Nunca subas el archivo `.env` al repositorio. Contiene credenciales sensibles.

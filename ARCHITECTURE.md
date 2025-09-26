# Arquitectura de Breakly

Este documento describe la arquitectura implementada en Breakly usando Riverpod y buenas prácticas de Flutter.

## 📁 Estructura del Proyecto

```
lib/
├── models/                    # Modelos de estado inmutables
│   ├── app_state.dart        # Estado principal de la aplicación
│   ├── device_mode_state.dart # Estado de los modos del dispositivo
│   └── session_state.dart    # Estado de la sesión de trabajo
├── interfaces/               # Contratos/Interfaces
│   ├── preferences_repository.dart
│   ├── notification_service.dart
│   └── device_mode_service.dart
├── services/                 # Implementaciones concretas
│   ├── preferences_repository_impl.dart
│   ├── notification_service_impl.dart
│   └── device_mode_service_impl.dart
├── notifiers/               # Gestión de estado con Riverpod
│   ├── providers.dart       # Providers de dependencias
│   └── breakly_notifier.dart # Notifier principal
├── widgets/                 # Componentes UI reutilizables
├── bottom_sheets/           # Modales reutilizables
└── main.dart               # Punto de entrada de la aplicación
```

## 🏗️ Principios Arquitectónicos

### 1. **Separación de Responsabilidades (SRP)**
- **Models**: Contienen solo datos inmutables
- **Interfaces**: Definen contratos sin implementación
- **Services**: Implementan lógica de negocio y acceso a datos
- **Notifiers**: Gestionan el estado de la aplicación
- **Widgets**: Se enfocan únicamente en la presentación

### 2. **Inversión de Dependencias**
- Los notifiers dependen de interfaces, no de implementaciones concretas
- Facilita el testing y el intercambio de implementaciones

### 3. **Inmutabilidad**
- Todos los modelos usan `freezed` para garantizar inmutabilidad
- Los estados se actualizan creando nuevas instancias

### 4. **Gestión de Estado Reactiva**
- Usa `StateNotifier` de Riverpod para gestión de estado
- El UI reacciona automáticamente a cambios de estado

## 🔄 Flujo de Datos

```
UI Widget → Notifier → Service → Repository → Data Source
    ↑                                        ↓
    ←────────── State Update ←────────────────
```

1. **UI** llama a métodos del notifier
2. **Notifier** ejecuta lógica de negocio usando servicios
3. **Services** interactúan con repositorios
4. **Repositories** acceden a fuentes de datos (SharedPreferences, APIs, etc.)
5. **Estado** se actualiza y notifica a la UI

## 📦 Componentes Principales

### Models (Estados)

#### `AppState`
Estado principal que contiene:
- `DeviceModeState`: Estado de los modos del dispositivo
- `SessionState`: Estado de la sesión de trabajo
- `isVideoInitialized`: Estado de inicialización del video
- `isLoading`: Estado de carga
- `error`: Mensajes de error

#### `DeviceModeState`
- `isDoNotDisturb`: Modo no molestar activo
- `isAirplaneMode`: Modo avión activo
- `ringerMode`: Modo del timbre ('normal', 'silent', etc.)

#### `SessionState`
- `activatedAt`: Momento de activación de la sesión
- `elapsed`: Tiempo transcurrido
- `minutesTarget`: Objetivo de minutos
- `isCustomDuration`: Si es una duración personalizada

### Services

#### `PreferencesRepository`
Maneja la persistencia de datos usando SharedPreferences:
- Configuración de minutos objetivo
- Persistencia de sesiones activas

#### `NotificationService`
Gestiona las notificaciones locales:
- Programación de notificaciones de fin de sesión
- Cancelación de notificaciones

#### `DeviceModeService`
Interactúa con los modos del dispositivo:
- Stream de cambios de estado
- Control de modo no molestar
- Control del timbre

### Notifier

#### `BreaklyNotifier`
Centraliza toda la lógica de negocio:
- Inicialización de servicios
- Gestión de sesiones
- Control de modos del dispositivo
- Actualización de estado reactivo

## 🧪 Testing

La arquitectura facilita el testing:

```dart
// Ejemplo de test del notifier
test('should update minutes target', () async {
  // Arrange
  final mockRepository = MockPreferencesRepository();
  final notifier = BreaklyNotifier(
    preferencesRepository: mockRepository,
    // ... otros mocks
  );
  
  // Act
  await notifier.updateMinutesTarget(60);
  
  // Assert
  expect(notifier.state.session.minutesTarget, 60);
  verify(mockRepository.setMinutesTarget(60)).called(1);
});
```

## 🚀 Beneficios

1. **Mantenibilidad**: Código organizado y fácil de entender
2. **Testabilidad**: Componentes desacoplados y fáciles de testear
3. **Escalabilidad**: Fácil agregar nuevas funcionalidades
4. **Reutilización**: Componentes reutilizables y modulares
5. **Reactividad**: UI que se actualiza automáticamente
6. **Inmutabilidad**: Estados predecibles y sin efectos secundarios

## 🔧 Configuración

### Dependencias Principales
- `flutter_riverpod`: Gestión de estado
- `freezed`: Modelos inmutables
- `build_runner`: Generación de código

### Comandos Útiles
```bash
# Instalar dependencias
flutter pub get

# Generar código (freezed, etc.)
flutter packages pub run build_runner build

# Análisis de código
flutter analyze

# Ejecutar tests
flutter test
```

## 📝 Convenciones

- **Naming**: PascalCase para clases, camelCase para variables
- **Files**: snake_case para archivos
- **Imports**: Organizados por tipo (dart, flutter, packages, local)
- **Documentation**: Comentarios en inglés para código público
- **Error Handling**: Manejo silencioso de errores en servicios

Esta arquitectura sigue las mejores prácticas de Flutter y facilita el desarrollo, mantenimiento y testing de la aplicación.


import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String? _supabaseUrl;
  static String? _supabaseAnonKey;
  static bool _isInitialized = false;

  /// Inicializa la configuración de Supabase cargando las variables de entorno
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Cargar variables de entorno desde el archivo .env
      await dotenv.load(fileName: ".env");

      _supabaseUrl = dotenv.env['SUPABASE_URL'];
      _supabaseAnonKey =
          dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ??
          dotenv.env['SUPABASE_ANON_KEY']; // Fallback para compatibilidad
      final environment = dotenv.env['ENVIRONMENT'] ?? 'development';

      // Validar que las credenciales estén presentes
      if (_supabaseUrl == null || _supabaseUrl!.isEmpty) {
        throw Exception('SUPABASE_URL no está configurada en el archivo .env');
      }

      if (_supabaseAnonKey == null || _supabaseAnonKey!.isEmpty) {
        throw Exception(
          'SUPABASE_PUBLISHABLE_KEY (o SUPABASE_ANON_KEY) no está configurada en el archivo .env',
        );
      }

      // Inicializar Supabase
      await Supabase.initialize(
        url: _supabaseUrl!,
        anonKey: _supabaseAnonKey!,
        debug: environment == 'development',
      );

      _isInitialized = true;
    } catch (e) {
      throw Exception('Error al inicializar Supabase: $e');
    }
  }

  /// Obtiene el cliente de Supabase
  static SupabaseClient get client {
    if (!_isInitialized) {
      throw Exception(
        'Supabase no ha sido inicializado. Llama a SupabaseConfig.initialize() primero.',
      );
    }
    return Supabase.instance.client;
  }

  /// Verifica si Supabase está inicializado
  static bool get isInitialized => _isInitialized;

  /// Obtiene la URL de Supabase (para debugging)
  static String? get supabaseUrl => _supabaseUrl;

  /// Obtiene el entorno actual
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

  /// Verifica si estamos en modo desarrollo
  static bool get isDevelopment => environment == 'development';
}

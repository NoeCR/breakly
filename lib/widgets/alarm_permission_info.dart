import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlarmPermissionInfo extends StatelessWidget {
  const AlarmPermissionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.alarm, color: Colors.orange),
          SizedBox(width: 8),
          Text('Permisos de Alarmas'),
        ],
      ),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Para que las notificaciones funcionen correctamente, necesitas habilitar las notificaciones:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            _StepItem(
              step: '✓',
              text:
                  'Habilitar notificaciones en Configuración > Aplicaciones > Breakly > Notificaciones',
            ),
            SizedBox(height: 16),
            Text(
              'Pasos para habilitar:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            _StepItem(
              step: '1',
              text: 'Ve a Configuración > Aplicaciones > Breakly',
            ),
            _StepItem(
              step: '2',
              text: 'Toca en "Permisos especiales" o "Permisos adicionales"',
            ),
            _StepItem(step: '3', text: 'Activa las notificaciones'),
            SizedBox(height: 16),
            Text(
              'Si el switch está deshabilitado:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            _StepItem(
              step: '•',
              text: 'Desactiva el modo de ahorro de energía',
            ),
            _StepItem(
              step: '•',
              text: 'Quita Breakly de la optimización de batería',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Entendido'),
        ),
        ElevatedButton(
          onPressed: () {
            // Abrir configuración de la app
            _openAppSettings();
            Navigator.of(context).pop();
          },
          child: const Text('Abrir Configuración'),
        ),
      ],
    );
  }

  void _openAppSettings() {
    // Intentar abrir la configuración de la app
    const platform = MethodChannel('app_settings');
    platform.invokeMethod('openAppSettings');
  }
}

class _StepItem extends StatelessWidget {
  final String step;
  final String text;

  const _StepItem({required this.step, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                step,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

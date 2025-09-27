import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/alarm_settings_widget.dart';

class AlarmSettingsBottomSheet extends ConsumerWidget {
  const AlarmSettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Configuración de Alarma',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          // Settings widget - wrapped in Flexible to prevent overflow
          Flexible(
            child: SingleChildScrollView(child: const AlarmSettingsWidget()),
          ),
          const SizedBox(height: 16),
          // Close button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Cerrar'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AlarmSettingsBottomSheet(),
    );
  }
}

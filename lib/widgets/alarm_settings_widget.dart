import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/alarm_settings.dart';
import '../notifiers/breakly_notifier.dart';

class AlarmSettingsWidget extends ConsumerWidget {
  const AlarmSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(breaklyNotifierProvider.notifier);
    final state = ref.watch(breaklyNotifierProvider);
    final alarmSettings = state.alarmSettings;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.alarm, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: const Text(
                    'Configuración de Alarma',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: alarmSettings.isEnabled,
                  onChanged: (value) {
                    notifier.toggleAlarmEnabled(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (alarmSettings.isEnabled) ...[
              _buildSoundSelector(context, notifier, alarmSettings),
              const SizedBox(height: 12),
              _buildVolumeSlider(context, notifier, alarmSettings),
              const SizedBox(height: 12),
              _buildDurationSlider(context, notifier, alarmSettings),
              const SizedBox(height: 12),
              _buildVibrationToggle(context, notifier, alarmSettings),
              const SizedBox(height: 12),
              _buildTestButton(context, notifier, alarmSettings),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSoundSelector(
    BuildContext context,
    BreaklyNotifier notifier,
    AlarmSettings alarmSettings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sonido de Alarma',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: alarmSettings.soundUri,
          isExpanded: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            hintText:
                alarmSettings.currentSound?.description ??
                'Selecciona un sonido',
            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          items:
              AlarmSettings.systemSounds.map((sound) {
                return DropdownMenuItem<String>(
                  value: sound.uri,
                  child: Text(
                    sound.name,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
          onChanged: (value) {
            if (value != null) {
              final sound = AlarmSettings.systemSounds.firstWhere(
                (s) => s.uri == value,
              );
              notifier.updateAlarmSound(value, sound.name);
            }
          },
        ),
      ],
    );
  }

  Widget _buildVolumeSlider(
    BuildContext context,
    BreaklyNotifier notifier,
    AlarmSettings alarmSettings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Volumen',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              '${(alarmSettings.volume * 100).round()}%',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        Slider(
          value: alarmSettings.volume.toDouble(),
          min: 0.0,
          max: 1.0,
          divisions: 10,
          onChanged: (value) {
            notifier.updateAlarmVolume(value.round());
          },
        ),
      ],
    );
  }

  Widget _buildDurationSlider(
    BuildContext context,
    BreaklyNotifier notifier,
    AlarmSettings alarmSettings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Duración',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              '${alarmSettings.duration}s',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        Slider(
          value: alarmSettings.duration.toDouble(),
          min: 1.0,
          max: 30.0,
          divisions: 29,
          onChanged: (value) {
            notifier.updateAlarmDuration(value.round());
          },
        ),
      ],
    );
  }

  Widget _buildVibrationToggle(
    BuildContext context,
    BreaklyNotifier notifier,
    AlarmSettings alarmSettings,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Vibración',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Switch(
          value: alarmSettings.vibrate,
          onChanged: (value) {
            final updatedSettings = alarmSettings.copyWith(vibrate: value);
            notifier.updateAlarmSettings(updatedSettings);
          },
        ),
      ],
    );
  }

  Widget _buildTestButton(
    BuildContext context,
    BreaklyNotifier notifier,
    AlarmSettings alarmSettings,
  ) {
    return Column(
      children: [
        // Información sobre limitaciones de DND
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.orange.shade50,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Nota: El modo "No Molestar" puede bloquear el sonido de la alarma. La vibración siempre funcionará.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Botones de prueba y parar
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    // Detener cualquier alarma actual
                    await notifier.stopAlarmSound();

                    // Reproducir alarma de prueba
                    await notifier.playTestAlarm();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '🔊 Reproduciendo: ${alarmSettings.soundName}',
                          ),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('❌ Error al reproducir alarma: $e'),
                          duration: const Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Probar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await notifier.stopAlarmSound();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🔇 Alarma detenida'),
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('❌ Error al detener alarma: $e'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.stop),
                label: const Text('Parar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

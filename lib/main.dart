import 'package:breakly/bottom_sheets/add_minutes_bottom_sheet.dart';
import 'package:breakly/widgets/add_duration_chip.dart';
import 'package:breakly/widgets/clear_chip.dart';
import 'package:breakly/widgets/duration_chip.dart';
import 'package:breakly/widgets/alarm_permission_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:breakly/notifiers/breakly_notifier.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breakly',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Breakly'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/black_hole.mp4')
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            if (mounted) {
              final notifier = ref.read(breaklyNotifierProvider.notifier);
              notifier.setVideoInitialized(true);
              // Registrar el callback para controlar el video
              notifier.setVideoController(_controlVideo);
            }
          });
  }

  void _controlVideo(bool shouldPlay) {
    if (shouldPlay) {
      _videoController?.play();
    } else {
      _videoController?.pause();
    }
  }

  Future<void> _showAddMinutesSheet() async {
    final value = await AddMinutesBottomSheet.show<int>(context);

    if (value != null) {
      await ref
          .read(breaklyNotifierProvider.notifier)
          .updateMinutesTarget(value);
    }
  }

  Future<void> _clearCustomDuration() async {
    await ref.read(breaklyNotifierProvider.notifier).updateMinutesTarget(30);
  }

  Future<void> _showAlarmPermissionInfo() async {
    final notifier = ref.read(breaklyNotifierProvider.notifier);
    final notificationsEnabled = await notifier.areNotificationsEnabled();
    final exactAlarmsPermission = await notifier.checkExactAlarmsPermission();

    if (kDebugMode) {
      print('🔔 Notifications enabled: $notificationsEnabled');
      print('🔍 Exact alarms permission: $exactAlarmsPermission');
    }

    // Verificar notificaciones pendientes
    await notifier.checkPendingNotifications();

    if ((!notificationsEnabled || !exactAlarmsPermission) && mounted) {
      showDialog(
        context: context,
        builder: (context) => const AlarmPermissionInfo(),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '✅ Todos los permisos de notificaciones están habilitados',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(breaklyNotifierProvider);
    final notifier = ref.read(breaklyNotifierProvider.notifier);

    final idleBg = const DecorationImage(
      image: AssetImage('assets/canyon.avif'),
      fit: BoxFit.cover,
    );
    final buttonColor =
        appState.isAnyModeActive ? Colors.redAccent : Colors.green;
    final buttonText =
        appState.isAnyModeActive
            ? 'Desactivar y salir'
            : 'Activar modo sin interrupciones';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breakly'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.alarm),
            onPressed: _showAlarmPermissionInfo,
            tooltip: 'Verificar permisos de alarmas',
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!appState.isAnyModeActive)
            Positioned.fill(
              child: Container(decoration: BoxDecoration(image: idleBg)),
            ),
          if (appState.isAnyModeActive &&
              _videoController != null &&
              _videoController!.value.isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),
          if (!appState.isAnyModeActive)
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.35)),
            ),
          if (appState.isAnyModeActive)
            Positioned(
              left: 16,
              right: 16,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Center(
                    child: Text(
                      'Tiempo: ${appState.session.formattedElapsed}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () async {
                      if (appState.isAnyModeActive) {
                        await notifier.disableAllModes();
                      } else {
                        await notifier.enablePreferredMode();
                      }
                    },
                    child: Text(
                      buttonText,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (appState.session.isCustomDuration)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${appState.session.minutesTarget}m',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'hasta ${appState.session.formattedEndTime}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ClearChip(onClear: _clearCustomDuration),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DurationChip(
                          label: '30m',
                          selected: appState.session.minutesTarget == 30,
                          onTap: () => notifier.updateMinutesTarget(30),
                        ),
                        const SizedBox(width: 8),
                        DurationChip(
                          label: '60m',
                          selected: appState.session.minutesTarget == 60,
                          onTap: () => notifier.updateMinutesTarget(60),
                        ),
                        const SizedBox(width: 8),
                        DurationChip(
                          label: '90m',
                          selected: appState.session.minutesTarget == 90,
                          onTap: () => notifier.updateMinutesTarget(90),
                        ),
                        const SizedBox(width: 8),
                        AddDurationChip(onAdd: _showAddMinutesSheet),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

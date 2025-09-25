import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(const MyApp());
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const EventChannel _events = EventChannel('device_modes/events');
  static const MethodChannel _methods = MethodChannel('device_modes/methods');

  StreamSubscription? _sub;
  bool _dnd = false;
  bool _airplane = false;
  String _ringer = 'normal';

  DateTime? _activatedAt;
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  VideoPlayerController? _videoController;
  final FlutterLocalNotificationsPlugin _notifs =
      FlutterLocalNotificationsPlugin();
  int _minutesTarget = 30;
  bool get _isCustomMinutes => !const {30, 60, 90}.contains(_minutesTarget);

  @override
  void initState() {
    super.initState();
    _restoreSessionIfAny();
    _initNotifications();
    _videoController =
        VideoPlayerController.asset('assets/black_hole.mp4')
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            if (mounted) setState(() {});
          });
    _sub = _events.receiveBroadcastStream().listen((event) {
      final map = Map<dynamic, dynamic>.from(event as Map);
      final dnd = map['dnd'] == true;
      final airplane = map['airplane'] == true;
      final ringer = (map['ringer'] as String?) ?? 'normal';
      final active = dnd || airplane || ringer == 'silent';

      setState(() {
        _dnd = dnd;
        _airplane = airplane;
        _ringer = ringer;
      });

      _handleActiveState(active);
    });
  }

  Future<void> _initNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _notifs.initialize(initSettings);
    tz.initializeTimeZones();
    final prefs = await SharedPreferences.getInstance();
    _minutesTarget = prefs.getInt('minutes_target') ?? 30;
    if (mounted) setState(() {});
  }

  Future<void> _restoreSessionIfAny() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final millis = prefs.getInt('active_session_started_at');
      if (millis != null) {
        _activatedAt = DateTime.fromMillisecondsSinceEpoch(millis);
        _startTimer();
        if (mounted) setState(() {});
      }
    } catch (_) {}
  }

  void _handleActiveState(bool active) {
    if (active) {
      if (_activatedAt == null) {
        _activatedAt = DateTime.now();
        _startTimer();
        _persistStart();
        _scheduleEndNotification();
      }
      _videoController?.play();
    } else {
      _activatedAt = null;
      _stopTimer();
      setState(() {
        _elapsed = Duration.zero;
      });
      _videoController?.pause();
      _clearPersistedStart();
      _cancelEndNotification();
    }
  }

  Future<void> _persistStart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'active_session_started_at',
        _activatedAt!.millisecondsSinceEpoch,
      );
    } catch (_) {}
  }

  Future<void> _clearPersistedStart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('active_session_started_at');
    } catch (_) {}
  }

  Future<void> _scheduleEndNotification() async {
    try {
      final now = DateTime.now();
      final scheduled = now.add(Duration(minutes: _minutesTarget));
      await _notifs.zonedSchedule(
        1001,
        'Tiempo cumplido',
        'Has completado $_minutesTarget minutos en modo sin interrupciones',
        tz.TZDateTime.from(scheduled, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'breakly_session',
            'Fin de sesión',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: null,
      );
    } catch (_) {}
  }

  Future<void> _cancelEndNotification() async {
    try {
      await _notifs.cancel(1001);
    } catch (_) {}
  }

  Future<void> _updateMinutesTarget(int minutes) async {
    setState(() {
      _minutesTarget = minutes;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('minutes_target', minutes);
    } catch (_) {}
    // Si hay sesión activa, reprogramamos la notificación
    if (_activatedAt != null) {
      await _cancelEndNotification();
      await _scheduleEndNotification();
    }
  }

  Future<void> _showAddMinutesSheet() async {
    final controller = TextEditingController(text: _minutesTarget.toString());
    final value = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Minutos personalizados',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Introduce minutos (entero)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final parsed = int.tryParse(controller.text.trim());
                      if (parsed != null && parsed > 0 && parsed < 24 * 60) {
                        Navigator.of(ctx).pop(parsed);
                      }
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    if (value != null) {
      await _updateMinutesTarget(value);
    }
  }

  Future<void> _clearCustomDuration() async {
    // Volver a presets mostrando 30/60/90. Elegimos 30 por defecto.
    await _updateMinutesTarget(30);
  }

  String _formatEndTime() {
    final base = _activatedAt ?? DateTime.now();
    final end = base.add(Duration(minutes: _minutesTarget));
    final hh = end.hour.toString().padLeft(2, '0');
    final mm = end.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_activatedAt != null) {
        setState(() {
          _elapsed = DateTime.now().difference(_activatedAt!);
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _sub?.cancel();
    _stopTimer();
    _videoController?.dispose();
    super.dispose();
  }

  bool get _isAnyModeActive => _dnd || _airplane || _ringer == 'silent';

  Future<void> _disableAll() async {
    try {
      // Preferimos desactivar DND directamente si hay permiso; si no, normalizamos timbre
      final hasAccess =
          await _methods.invokeMethod('hasDndAccess') as bool? ?? false;
      if (hasAccess) {
        await _methods.invokeMethod('setDoNotDisturb', {'enable': false});
      }
      await _methods.invokeMethod('toggleRinger', {'mode': 'normal'});
    } catch (_) {}
  }

  Future<void> _enablePreferred() async {
    try {
      final hasAccess =
          await _methods.invokeMethod('hasDndAccess') as bool? ?? false;
      if (hasAccess) {
        await _methods.invokeMethod('setDoNotDisturb', {'enable': true});
      } else {
        // Fallback: silenciar y abrir ajustes para conceder permiso DND
        try {
          await _methods.invokeMethod('toggleRinger', {'mode': 'silent'});
        } catch (_) {}
        await _methods.invokeMethod('openDoNotDisturbSettings');
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // Video se usa como fondo cuando está activo
    final idleBg = const DecorationImage(
      image: AssetImage('assets/canyon.avif'),
      fit: BoxFit.cover,
    );

    final buttonColor = _isAnyModeActive ? Colors.redAccent : Colors.green;
    final buttonText =
        _isAnyModeActive
            ? 'Desactivar y salir'
            : 'Activar modo sin interrupciones';

    final elapsedStr = _elapsed.toString().split('.').first.padLeft(8, '0');

    return Scaffold(
      body: Stack(
        children: [
          if (!_isAnyModeActive)
            Positioned.fill(
              child: Container(decoration: BoxDecoration(image: idleBg)),
            ),
          if (_isAnyModeActive &&
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
          // Overlay oscuro solo cuando NO está activo (no afectar al video)
          if (!_isAnyModeActive)
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.35)),
            ),
          // Contador arriba
          if (_isAnyModeActive)
            Positioned(
              left: 16,
              right: 16,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Center(
                    child: Text(
                      'Tiempo: $elapsedStr',
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
          // Botón abajo, selector de duración y texto de estado
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
                      if (_isAnyModeActive) {
                        await _disableAll();
                      } else {
                        await _enablePreferred();
                      }
                    },
                    child: Text(
                      buttonText,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Selector de duración o badge de personalizado
                  if (_isCustomMinutes)
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
                                '${_minutesTarget}m',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'hasta ${_formatEndTime()}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _ClearChip(onClear: _clearCustomDuration),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _DurationChip(
                          label: '30m',
                          selected: _minutesTarget == 30,
                          onTap: () => _updateMinutesTarget(30),
                        ),
                        const SizedBox(width: 8),
                        _DurationChip(
                          label: '60m',
                          selected: _minutesTarget == 60,
                          onTap: () => _updateMinutesTarget(60),
                        ),
                        const SizedBox(width: 8),
                        _DurationChip(
                          label: '90m',
                          selected: _minutesTarget == 90,
                          onTap: () => _updateMinutesTarget(90),
                        ),
                        const SizedBox(width: 8),
                        _AddDurationChip(onAdd: _showAddMinutesSheet),
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

class _DurationChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DurationChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white70 : Colors.white24,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white60),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black87 : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AddDurationChip extends StatelessWidget {
  final Future<void> Function() onAdd;

  const _AddDurationChip({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white60),
        ),
        child: const Text(
          'Add',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _ClearChip extends StatelessWidget {
  final Future<void> Function() onClear;

  const _ClearChip({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClear,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white60),
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 18),
      ),
    );
  }
}

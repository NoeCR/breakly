import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/black_hole.mp4')
          ..setLooping(true)
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

  void _handleActiveState(bool active) {
    if (active) {
      if (_activatedAt == null) {
        _activatedAt = DateTime.now();
        _startTimer();
      }
      _videoController?.play();
    } else {
      _activatedAt = null;
      _stopTimer();
      setState(() {
        _elapsed = Duration.zero;
      });
      _videoController?.pause();
    }
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
      await _methods.invokeMethod('toggleRinger', {'mode': 'normal'});
      // DND/Airplane cannot be toggled programáticamente en Android moderno sin privilegios; abrimos settings.
      if (_dnd) {
        await _methods.invokeMethod('openDoNotDisturbSettings');
      }
      if (_airplane) {
        await _methods.invokeMethod('openAirplaneSettings');
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
      image: NetworkImage(
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1600&auto=format&fit=crop',
      ),
      fit: BoxFit.cover,
    );

    final buttonColor = _isAnyModeActive ? Colors.redAccent : Colors.green;
    final buttonText =
        _isAnyModeActive
            ? 'Desactivar y salir'
            : 'Activar modo sin interrupciones';

    final elapsedStr = _elapsed.toString().split('.').first.padLeft(8, '0');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
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
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isAnyModeActive)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Tiempo: $elapsedStr',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                      // Activar todos: poner silencio y abrir settings para DND/avión
                      try {
                        await _methods.invokeMethod('toggleRinger', {
                          'mode': 'silent',
                        });
                      } catch (_) {}
                      await _methods.invokeMethod('openDoNotDisturbSettings');
                      await _methods.invokeMethod('openAirplaneSettings');
                    }
                  },
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'DND: ${_dnd ? 'ON' : 'OFF'} | Silencio: ${_ringer == 'silent' ? 'ON' : 'OFF'} | Avión: ${_airplane ? 'ON' : 'OFF'}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

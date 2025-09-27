package com.example.breakly

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.Ringtone
import android.media.RingtoneManager
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.provider.Settings
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val eventsChannelName = "device_modes/events"
    private val methodsChannelName = "device_modes/methods"
    private val phoneChannelName = "phone_number/methods"
    private val alarmChannelName = "alarm_sound/methods"

    private var eventSink: EventChannel.EventSink? = null
    private var registered = false
    private var currentRingtone: Ringtone? = null
    private var currentMediaPlayer: MediaPlayer? = null

    private val broadcastReceiver =
            object : BroadcastReceiver() {
                override fun onReceive(context: Context?, intent: Intent?) {
                    emitCurrentState()
                }
            }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventsChannelName)
                .setStreamHandler(
                        object : EventChannel.StreamHandler {
                            override fun onListen(
                                    arguments: Any?,
                                    events: EventChannel.EventSink?
                            ) {
                                eventSink = events
                                registerReceivers()
                                emitCurrentState()
                            }

                            override fun onCancel(arguments: Any?) {
                                unregisterReceivers()
                                eventSink = null
                            }
                        }
                )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodsChannelName)
                .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                    when (call.method) {
                        "hasDndAccess" -> {
                            result.success(hasDndAccess())
                        }
                        "setDoNotDisturb" -> {
                            val enable = call.argument<Boolean>("enable") ?: false
                            result.success(setDoNotDisturb(enable))
                        }
                        "toggleRinger" -> {
                            val mode = call.argument<String>("mode")
                            result.success(toggleRinger(mode))
                        }
                        "openDoNotDisturbSettings" -> {
                            openDoNotDisturbSettings()
                            result.success(true)
                        }
                        "openAirplaneSettings" -> {
                            openAirplaneSettings()
                            result.success(true)
                        }
                        else -> result.notImplemented()
                    }
                }

        // Canal para obtener número de teléfono
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, phoneChannelName)
                .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                    when (call.method) {
                        "getPhoneNumber" -> {
                            result.success(getPhoneNumber())
                        }
                        else -> result.notImplemented()
                    }
                }

        // Canal para alarmas sonoras
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, alarmChannelName)
                .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                    when (call.method) {
                        "playSystemSound" -> {
                            val soundUri = call.argument<String>("soundUri") ?: "default"
                            result.success(playSystemSoundSimple(soundUri))
                        }
                        "stopSystemSound" -> {
                            result.success(stopSystemSound())
                        }
                        "getSystemSounds" -> {
                            result.success(getSystemSounds())
                        }
                        "triggerVibration" -> {
                            val duration = call.argument<Long>("duration") ?: 1000L
                            result.success(triggerVibration(duration))
                        }
                        else -> result.notImplemented()
                    }
                }
    }

    private fun registerReceivers() {
        if (registered) return
        val filter =
                IntentFilter().apply {
                    addAction(AudioManager.RINGER_MODE_CHANGED_ACTION)
                    addAction(Intent.ACTION_AIRPLANE_MODE_CHANGED)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        addAction(NotificationManager.ACTION_INTERRUPTION_FILTER_CHANGED)
                        addAction(
                                NotificationManager
                                        .ACTION_NOTIFICATION_POLICY_ACCESS_GRANTED_CHANGED
                        )
                    }
                }
        registerReceiver(broadcastReceiver, filter)
        registered = true
    }

    private fun unregisterReceivers() {
        if (!registered) return
        unregisterReceiver(broadcastReceiver)
        registered = false
    }

    private fun emitCurrentState() {
        val context = applicationContext
        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val ringerMode =
                when (audioManager.ringerMode) {
                    AudioManager.RINGER_MODE_SILENT -> "silent"
                    AudioManager.RINGER_MODE_VIBRATE -> "vibrate"
                    else -> "normal"
                }

        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        var dndActive = false
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            dndActive =
                    when (nm.currentInterruptionFilter) {
                        NotificationManager.INTERRUPTION_FILTER_ALL -> false
                        else -> true
                    }
        }

        val airplaneOn =
                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
                        Settings.Global.getInt(
                                context.contentResolver,
                                Settings.Global.AIRPLANE_MODE_ON,
                                0
                        ) == 1
                    } else {
                        @Suppress("DEPRECATION")
                        Settings.System.getInt(
                                context.contentResolver,
                                Settings.System.AIRPLANE_MODE_ON,
                                0
                        ) == 1
                    }
                } catch (e: Exception) {
                    false
                }

        val payload =
                mapOf(
                        "dnd" to dndActive,
                        "ringer" to ringerMode,
                        "airplane" to airplaneOn,
                        "timestamp" to System.currentTimeMillis()
                )
        eventSink?.success(payload)
    }

    private fun hasDndAccess(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val nm =
                    applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as
                            NotificationManager
            nm.isNotificationPolicyAccessGranted
        } else false
    }

    private fun setDoNotDisturb(enable: Boolean): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val nm =
                    applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as
                            NotificationManager
            if (!nm.isNotificationPolicyAccessGranted) return false
            try {
                nm.setInterruptionFilter(
                        if (enable) NotificationManager.INTERRUPTION_FILTER_NONE
                        else NotificationManager.INTERRUPTION_FILTER_ALL
                )
                true
            } catch (e: Exception) {
                false
            }
        } else false
    }

    private fun toggleRinger(mode: String?): Boolean {
        val audioManager =
                applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        return try {
            when (mode) {
                "silent" -> audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
                "vibrate" -> audioManager.ringerMode = AudioManager.RINGER_MODE_VIBRATE
                else -> audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
            }
            true
        } catch (e: Exception) {
            false
        }
    }

    private fun openDoNotDisturbSettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        } else {
            val intent = Intent(Settings.ACTION_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }
    }

    private fun openAirplaneSettings() {
        val intent = Intent(Settings.ACTION_AIRPLANE_MODE_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    private fun getPhoneNumber(): String? {
        return try {
            // Verificar permisos
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (checkSelfPermission(android.Manifest.permission.READ_PHONE_STATE) !=
                                android.content.pm.PackageManager.PERMISSION_GRANTED
                ) {
                    return null
                }
            }

            val phoneNumber =
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        // Android 13+ (API 33+): Usar SubscriptionManager
                        getPhoneNumberModern()
                    } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        // Android 10+ (API 29+): line1Number está deprecado pero aún funciona
                        // Intentar obtener el número usando el método moderno primero
                        getPhoneNumberModern() ?: getPhoneNumberLegacy()
                    } else {
                        // Android 9 y anteriores: Usar el método legacy
                        getPhoneNumberLegacy()
                    }

            // Verificar que el número no esté vacío
            if (phoneNumber.isNullOrEmpty()) {
                null
            } else {
                phoneNumber
            }
        } catch (e: Exception) {
            null
        }
    }

    @Suppress("DEPRECATION")
    private fun getPhoneNumberLegacy(): String? {
        return try {
            val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            telephonyManager.line1Number
        } catch (e: Exception) {
            null
        }
    }

    private fun getPhoneNumberModern(): String? {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                val subscriptionManager =
                        getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as
                                SubscriptionManager
                val subscriptionInfoList = subscriptionManager.activeSubscriptionInfoList

                // Verificar que la lista no sea null antes de iterar
                if (subscriptionInfoList != null) {
                    // Buscar el primer número de teléfono disponible
                    for (subscriptionInfo in subscriptionInfoList) {
                        val phoneNumber = subscriptionInfo.number
                        if (!phoneNumber.isNullOrEmpty()) {
                            return phoneNumber
                        }
                    }
                }
            }
            null
        } catch (e: Exception) {
            null
        }
    }

    private fun playSystemSoundSimple(soundUri: String): Boolean {
        return try {
            println("🔊 [Android] Playing system sound (simple): $soundUri")

            stopSystemSound()

            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager

            // Verificar el modo de sonido actual
            val ringerMode = audioManager.ringerMode
            println("🔊 [Android] Current ringer mode: $ringerMode")

            // Forzar volumen máximo en múltiples streams
            val maxNotificationVolume =
                    audioManager.getStreamMaxVolume(AudioManager.STREAM_NOTIFICATION)
            val maxAlarmVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_ALARM)
            val maxMusicVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
            val maxRingVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_RING)

            println(
                    "🔊 [Android] Max volumes - Notification: $maxNotificationVolume, Alarm: $maxAlarmVolume, Music: $maxMusicVolume, Ring: $maxRingVolume"
            )

            // Establecer volúmenes máximos
            audioManager.setStreamVolume(AudioManager.STREAM_NOTIFICATION, maxNotificationVolume, 0)
            audioManager.setStreamVolume(AudioManager.STREAM_ALARM, maxAlarmVolume, 0)
            audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, maxMusicVolume, 0)
            audioManager.setStreamVolume(AudioManager.STREAM_RING, maxRingVolume, 0)

            // Si está en modo silencioso, intentar cambiarlo temporalmente
            if (ringerMode == AudioManager.RINGER_MODE_SILENT) {
                println("🔊 [Android] Device is in silent mode, temporarily changing to normal...")
                audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
            }

            // Seleccionar el URI correcto basado en el soundUri
            val selectedUri =
                    when (soundUri) {
                        "alarm" -> android.provider.Settings.System.DEFAULT_ALARM_ALERT_URI
                        "notification" -> android.provider.Settings.System.DEFAULT_NOTIFICATION_URI
                        "ringtone" -> android.provider.Settings.System.DEFAULT_RINGTONE_URI
                        "default" -> android.provider.Settings.System.DEFAULT_NOTIFICATION_URI
                        else -> android.provider.Settings.System.DEFAULT_NOTIFICATION_URI
                    }

            println("🔊 [Android] Using URI: $selectedUri for sound: $soundUri")

            // Intentar múltiples enfoques para reproducir el sonido
            var success = false

            // Enfoque 1: MediaPlayer con STREAM_ALARM
            try {
                println("🔊 [Android] Trying MediaPlayer with STREAM_ALARM...")
                currentMediaPlayer =
                        MediaPlayer().apply {
                            setAudioStreamType(AudioManager.STREAM_ALARM)
                            setDataSource(applicationContext, selectedUri)
                            setVolume(1.0f, 1.0f)
                            isLooping = false
                            prepare()
                            start()
                        }
                println("🔊 [Android] MediaPlayer with STREAM_ALARM started successfully")
                success = true
            } catch (e: Exception) {
                println("❌ [Android] MediaPlayer with STREAM_ALARM failed: $e")
            }

            // Enfoque 2: RingtoneManager como respaldo
            if (!success) {
                try {
                    println("🔊 [Android] Trying RingtoneManager fallback...")
                    val ringtoneType =
                            when (soundUri) {
                                "alarm" -> RingtoneManager.TYPE_ALARM
                                "notification" -> RingtoneManager.TYPE_NOTIFICATION
                                "ringtone" -> RingtoneManager.TYPE_RINGTONE
                                else -> RingtoneManager.TYPE_NOTIFICATION
                            }

                    val ringtoneUri = RingtoneManager.getDefaultUri(ringtoneType)
                    currentRingtone = RingtoneManager.getRingtone(applicationContext, ringtoneUri)
                    currentRingtone?.play()
                    println("🔊 [Android] RingtoneManager fallback successful")
                    success = true
                } catch (e2: Exception) {
                    println("❌ [Android] RingtoneManager fallback failed: $e2")
                }
            }

            // Enfoque 3: AudioManager sound effects como último recurso
            if (!success) {
                try {
                    println("🔊 [Android] Using AudioManager sound effects as last resort...")
                    audioManager.playSoundEffect(AudioManager.FX_KEY_CLICK)
                    Thread.sleep(200)
                    audioManager.playSoundEffect(AudioManager.FX_KEY_CLICK)
                    Thread.sleep(200)
                    audioManager.playSoundEffect(AudioManager.FX_KEY_CLICK)
                    println("🔊 [Android] AudioManager sound effects played")
                    success = true
                } catch (e3: Exception) {
                    println("❌ [Android] AudioManager sound effects failed: $e3")
                }
            }

            success
        } catch (e: Exception) {
            println("❌ [Android] playSystemSoundSimple failed: $e")
            false
        }
    }

    private fun playSystemSound(soundUri: String): Boolean {
        return try {
            println("🔊 [Android] Playing system sound: $soundUri")

            // Parar cualquier sonido que esté reproduciéndose
            stopSystemSound()

            val ringtoneType =
                    when (soundUri) {
                        "alarm" -> RingtoneManager.TYPE_ALARM
                        "notification" ->
                                RingtoneManager.TYPE_ALARM // Usar alarma para saltarse DND
                        "ringtone" -> RingtoneManager.TYPE_ALARM // Usar alarma para saltarse DND
                        "default" -> RingtoneManager.TYPE_ALARM // Usar alarma para saltarse DND
                        else -> RingtoneManager.TYPE_ALARM // Usar alarma para saltarse DND
                    }

            // Intentar múltiples URIs para mayor compatibilidad
            val uris =
                    listOf(
                            RingtoneManager.getDefaultUri(ringtoneType),
                            RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM),
                            RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION),
                            RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE),
                            android.provider.Settings.System.DEFAULT_ALARM_ALERT_URI,
                            android.provider.Settings.System.DEFAULT_NOTIFICATION_URI,
                            android.provider.Settings.System.DEFAULT_RINGTONE_URI
                    )

            var workingUri: android.net.Uri? = null
            for (uri in uris) {
                if (uri != null) {
                    try {
                        val testRingtone = RingtoneManager.getRingtone(applicationContext, uri)
                        if (testRingtone != null) {
                            workingUri = uri
                            println("🔊 [Android] Found working URI: $uri")
                            break
                        }
                    } catch (e: Exception) {
                        println("🔊 [Android] URI failed: $uri - $e")
                    }
                }
            }

            if (workingUri == null) {
                println("❌ [Android] No working URI found")
                return false
            }

            currentRingtone = RingtoneManager.getRingtone(applicationContext, workingUri)

            if (currentRingtone == null) {
                println("❌ [Android] Failed to create ringtone")
                return false
            }

            // Configurar el ringtone para que se reproduzca incluso con DND activo
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                currentRingtone?.isLooping = false
            }

            // Intentar reproducir con diferentes configuraciones
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager

            // Verificar el modo de audio actual
            val ringerMode = audioManager.ringerMode
            println("🔊 [Android] Current ringer mode: $ringerMode")

            // Intentar reproducir con Ringtone primero
            currentRingtone?.play()
            println("🔊 [Android] Ringtone played")

            // Intentar también con MediaPlayer como respaldo para mayor compatibilidad
            try {
                println("🔊 [Android] Also trying MediaPlayer as backup...")
                currentMediaPlayer =
                        MediaPlayer().apply {
                            setAudioStreamType(AudioManager.STREAM_ALARM)
                            setDataSource(applicationContext, workingUri)
                            setVolume(1.0f, 1.0f)
                            prepare()
                            start()
                        }
                println("🔊 [Android] MediaPlayer started successfully")
            } catch (e: Exception) {
                println("❌ [Android] MediaPlayer failed: $e")

                // Último intento: forzar volumen máximo y reproducir ringtone
                println("🔊 [Android] Final attempt with max volume...")
                val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_ALARM)
                audioManager.setStreamVolume(AudioManager.STREAM_ALARM, maxVolume, 0)
                currentRingtone?.play()

                // Intentar con un tono de sistema más básico
                try {
                    println("🔊 [Android] Trying system beep...")
                    val systemBeep =
                            MediaPlayer().apply {
                                setAudioStreamType(AudioManager.STREAM_ALARM)
                                setDataSource(
                                        applicationContext,
                                        android.provider.Settings.System.DEFAULT_NOTIFICATION_URI
                                )
                                setVolume(1.0f, 1.0f)
                                prepare()
                                start()
                            }
                    println("🔊 [Android] System beep started")
                } catch (e: Exception) {
                    println("❌ [Android] System beep failed: $e")

                    // Último recurso: usar AudioManager para generar un tono
                    try {
                        println("🔊 [Android] Using AudioManager tone...")
                        audioManager.playSoundEffect(AudioManager.FX_KEY_CLICK)
                        Thread.sleep(100)
                        audioManager.playSoundEffect(AudioManager.FX_KEY_CLICK)
                        Thread.sleep(100)
                        audioManager.playSoundEffect(AudioManager.FX_KEY_CLICK)
                        println("🔊 [Android] AudioManager tone played")
                    } catch (e: Exception) {
                        println("❌ [Android] AudioManager tone failed: $e")
                    }
                }
            }

            true
        } catch (e: Exception) {
            println("❌ [Android] Error playing system sound: $e")
            false
        }
    }

    private fun stopSystemSound(): Boolean {
        return try {
            println("🔇 [Android] Stopping system sound...")

            // Detener Ringtone
            currentRingtone?.stop()
            currentRingtone = null

            // Detener MediaPlayer
            currentMediaPlayer?.let { mediaPlayer ->
                if (mediaPlayer.isPlaying) {
                    mediaPlayer.stop()
                }
                mediaPlayer.release()
            }
            currentMediaPlayer = null

            println("🔇 [Android] System sound stopped")
            true
        } catch (e: Exception) {
            println("❌ [Android] Error stopping system sound: $e")
            false
        }
    }

    private fun getSystemSounds(): List<Map<String, String>> {
        return try {
            listOf(
                    mapOf(
                            "uri" to "default",
                            "name" to "Sonido por defecto",
                            "description" to "Sonido de notificación del sistema"
                    ),
                    mapOf(
                            "uri" to "alarm",
                            "name" to "Alarma",
                            "description" to "Sonido de alarma del sistema"
                    ),
                    mapOf(
                            "uri" to "notification",
                            "name" to "Notificación",
                            "description" to "Sonido de notificación"
                    ),
                    mapOf(
                            "uri" to "ringtone",
                            "name" to "Llamada",
                            "description" to "Sonido de llamada"
                    )
            )
        } catch (e: Exception) {
            emptyList()
        }
    }

    private fun triggerVibration(duration: Long): Boolean {
        return try {
            println("📳 [Android] Triggering vibration for $duration ms")

            val vibrator =
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        val vibratorManager =
                                getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as
                                        VibratorManager
                        vibratorManager.defaultVibrator
                    } else {
                        @Suppress("DEPRECATION")
                        getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                    }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                // Patrón de vibración: vibrar, pausa, vibrar, pausa, vibrar
                val pattern = longArrayOf(0, 500, 200, 500, 200, 500)
                val amplitudes = intArrayOf(0, 255, 0, 255, 0, 255)
                val vibrationEffect = VibrationEffect.createWaveform(pattern, amplitudes, -1)
                vibrator.vibrate(vibrationEffect)
            } else {
                @Suppress("DEPRECATION") vibrator.vibrate(duration)
            }

            println("📳 [Android] Vibration triggered successfully")
            true
        } catch (e: Exception) {
            println("❌ [Android] Vibration failed: $e")
            false
        }
    }
}

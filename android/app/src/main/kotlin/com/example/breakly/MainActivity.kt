package com.example.breakly

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import android.os.Build
import android.provider.Settings
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

    private var eventSink: EventChannel.EventSink? = null
    private var registered = false

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
            val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            
            // Verificar permisos
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (checkSelfPermission(android.Manifest.permission.READ_PHONE_STATE) 
                    != android.content.pm.PackageManager.PERMISSION_GRANTED) {
                    return null
                }
            }
            
            // Obtener número de teléfono
            val phoneNumber = telephonyManager.line1Number
            
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
}

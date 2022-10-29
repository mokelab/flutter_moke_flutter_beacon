package com.mokelab.moke_flutter_beacon

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodChannel
import java.io.File

class BackgroundExecutor(
    private val beaconManagerDelegate: BeaconManagerDelegate,
    private val context: Context,
) {
    companion object {
        private const val PREF_NAME = "com.mokelab.moke_flutter_beacon.pref"
        private const val KEY_ENTRY_POINT_FUNCTION_NAME = "entrypoint"
        private const val BACKGROUND_CHANNEL_NAME = "com.mokelab.moke_flutter_beacon/background"

        private val flutterLoader = FlutterLoader()
    }

    private val handler = Handler(Looper.getMainLooper())

    fun callFromBackground(args: List<String>) {
        handler.post {
            val engine = FlutterEngine(context)

            if (!flutterLoader.initialized()) {
                flutterLoader.startInitialization(context)
            }

            flutterLoader.ensureInitializationCompleteAsync(
                context,
                null,
                Handler(Looper.getMainLooper())
            ) {
                val entryPointFunctionName = loadEntryPointFunctionName()
                val dartBundlePath = flutterLoader.findAppBundlePath()

                val backgroundChannel = MethodChannel(engine.dartExecutor, BACKGROUND_CHANNEL_NAME)
                backgroundChannel.setMethodCallHandler { call, result ->
                    println("onMethodCall background ${call.method}")
                    when (call.method) {
                        "start_range" -> {
                            beaconManagerDelegate.startRange(call.toRegion())
                            result.success(true)
                        }
                        "stop_range" -> {
                            beaconManagerDelegate.stopRange(call.toRegion())
                            result.success(true)
                        }
                        "stop" -> {
                            engine.destroy()
                        }
                        "debug_write" -> {
                            val msg = call.argument<String>("msg") ?: ""
                            writeToLocalFile(msg)
                            result.success(true)
                        }
                    }
                }

                engine.dartExecutor.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint(
                        dartBundlePath,
                        entryPointFunctionName
                    ),
                    args
                )
            }
        }
    }

    private fun writeToLocalFile(msg: String) {
        val file = File(context.cacheDir, "debug.txt")
        if (file.exists()) {
            val current = file.readText()
            file.writeText(current + "\n" + msg)
        } else {
            file.writeText(msg)
        }
    }

    private fun loadEntryPointFunctionName(): String {
        val pref = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
        return pref.getString(KEY_ENTRY_POINT_FUNCTION_NAME, "") ?: ""
    }
}
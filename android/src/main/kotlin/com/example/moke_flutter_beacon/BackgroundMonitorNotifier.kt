package com.example.moke_flutter_beacon

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.altbeacon.beacon.MonitorNotifier
import org.altbeacon.beacon.Region

class BackgroundMonitorNotifier(
    private val context: Context,
) : MonitorNotifier, MethodChannel.MethodCallHandler {
    companion object {
        private const val PREF_NAME = "com.mokelab.moke_flutter_beacon.pref"
        private const val KEY_ENTRY_POINT_FUNCTION_NAME = "entrypoint"
        private const val BACKGROUND_CHANNEL_NAME = "com.mokelab.moke_flutter_beacon.background"

        private val flutterLoader = FlutterLoader()
    }

    override fun didEnterRegion(region: Region) {
        callFromBackground(listOf("didEnterRegion", region.uniqueId, region.id1.toString()))
    }

    override fun didExitRegion(region: Region) {
        callFromBackground(listOf("didExitRegion", region.uniqueId, region.id1.toString()))
    }

    override fun didDetermineStateForRegion(state: Int, region: Region) {
        callFromBackground(
            listOf(
                "didDetermineStateForRegion",
                region.uniqueId,
                region.id1.toString()
            )
        )
    }

    private fun callFromBackground(args: List<String>) {
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
            backgroundChannel.setMethodCallHandler(this@BackgroundMonitorNotifier)

            engine.dartExecutor.executeDartEntrypoint(
                DartEntrypoint(
                    dartBundlePath,
                    entryPointFunctionName
                ),
                args
            )
        }

    }

    private fun loadEntryPointFunctionName(): String {
        val pref = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
        return pref.getString(KEY_ENTRY_POINT_FUNCTION_NAME, "") ?: ""
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        println("onMethodCall background")
    }

}
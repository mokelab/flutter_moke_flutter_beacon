package com.example.moke_flutter_beacon

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.altbeacon.beacon.*
import java.lang.IllegalArgumentException

/** MokeFlutterBeaconPlugin */
class MokeFlutterBeaconPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var beaconManager: BeaconManager
    private lateinit var beaconMonitor: BeaconMonitor
    private lateinit var monitorChannel: EventChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val messenger = flutterPluginBinding.binaryMessenger
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "com.mokelab.moke_flutter_beacon/method"
        )
        channel.setMethodCallHandler(this)

        beaconManager =
            BeaconManager.getInstanceForApplication(flutterPluginBinding.applicationContext)
        beaconManager.beaconParsers.add(BeaconParser().setBeaconLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24"))
        beaconMonitor = BeaconMonitor(beaconManager)
        monitorChannel = EventChannel(messenger, "com.mokelab.moke_flutter_beacon/monitor")
        monitorChannel.setStreamHandler(beaconMonitor.streamHandler)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        println("onMethodCall: ${call.method}")
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "initialize" -> {
                result.success(true)
            }
            "start" -> {
                try {
                    beaconMonitor.start(call.toRegion())
                    result.success(true)
                } catch (e: IllegalArgumentException) {
                    println("start failed ${e.message}")
                    result.error("IllegalArgumentException", "", null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

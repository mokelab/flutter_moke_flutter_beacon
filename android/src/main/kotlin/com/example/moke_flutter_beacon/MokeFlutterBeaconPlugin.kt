package com.example.moke_flutter_beacon

import android.app.Activity
import android.app.Application
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import org.altbeacon.beacon.*
import java.lang.IllegalArgumentException
import java.lang.ref.WeakReference

/** MokeFlutterBeaconPlugin */
class MokeFlutterBeaconPlugin : FlutterPlugin,
    ActivityAware,
    MethodCallHandler,
    PluginRegistry.RequestPermissionsResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var activityRef = WeakReference<Activity>(null)

    private lateinit var channel: MethodChannel
    private lateinit var beaconManager: BeaconManager

    private lateinit var beaconMonitor: BeaconMonitor
    private lateinit var monitorChannel: EventChannel

    private lateinit var beaconRange: BeaconRange
    private lateinit var rangeChannel: EventChannel

    private var permissionResult: Result? = null

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

        beaconMonitor =
            BeaconMonitor(beaconManager, flutterPluginBinding.applicationContext as Application)
        monitorChannel = EventChannel(messenger, "com.mokelab.moke_flutter_beacon/monitor")
        monitorChannel.setStreamHandler(beaconMonitor.streamHandler)

        beaconRange = BeaconRange(beaconManager)
        rangeChannel = EventChannel(messenger, "com.mokelab.moke_flutter_beacon/range")
        rangeChannel.setStreamHandler(beaconRange.streamHandler)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "initialize" -> {
                result.success(true)
            }
            "permission" -> {
                val activity = activityRef.get() ?: return
                permissionResult = result
                PermissionHandler.request(activity, REQUEST_PERMISSION)
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
            "start_range" -> {
                try {
                    beaconRange.start(call.toRegion())
                } catch (e: Exception) {
                    result.error("Error", e.message, e)
                }
            }
            "stop_range" -> {
                try {
                    beaconRange.stop(call.toRegion())
                } catch (e: Exception) {
                    result.error("Error", e.message, e)
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

    //region ActivityAware

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityRef = WeakReference(binding.activity)
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityRef.clear()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityRef = WeakReference(binding.activity)
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activityRef.clear()
    }
    //endregion

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode == REQUEST_PERMISSION) {
            println("onRequestPermissionsResult")
            val allGranted =
                PermissionHandler.handleOnRequestPermissionResult(permissions, grantResults)
            println("onRequestPermissionsResult $allGranted")
            permissionResult?.success(allGranted)
            return true
        }
        return false
    }

    companion object {
        private const val REQUEST_PERMISSION = 1122
    }
}

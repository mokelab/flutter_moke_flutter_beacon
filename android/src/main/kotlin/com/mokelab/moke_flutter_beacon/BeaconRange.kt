package com.mokelab.moke_flutter_beacon

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import org.altbeacon.beacon.BeaconManager
import org.altbeacon.beacon.RangeNotifier
import org.altbeacon.beacon.Region

class BeaconRange(
    private val beaconManager: BeaconManager,
) {
    private var eventSink: EventChannel.EventSink? = null
    private val handler = Handler(Looper.getMainLooper())

    val notifier = RangeNotifier { beacons, region ->
        sendEvent(eventSink, RangeResult(beacons))
    }

    val streamHandler = object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
            println("onListen")
            eventSink = events
        }

        override fun onCancel(arguments: Any) {
            println("onCancel")
            eventSink = null
        }
    }

    init {
        beaconManager.addRangeNotifier(notifier)
    }

    fun start(region: Region) {
        println("startRangingBeacons region=${region}")
        beaconManager.startRangingBeacons(region)
        println("startRangingBeacons called")
    }

    fun stop(region: Region) {
        println("stopRangingBeacons region=${region}")
        beaconManager.stopRangingBeacons(region)
        println("stopRangingBeacons called")
    }

    private fun sendEvent(
        eventSink: EventChannel.EventSink?,
        result: RangeResult,
    ) {
        val sink = eventSink ?: return
        handler.post {
            sink.success(result.toList())
        }
    }
}
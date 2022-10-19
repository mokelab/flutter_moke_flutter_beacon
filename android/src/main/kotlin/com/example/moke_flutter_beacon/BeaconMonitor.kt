package com.example.moke_flutter_beacon

import android.app.Application
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import org.altbeacon.beacon.BeaconManager
import org.altbeacon.beacon.MonitorNotifier
import org.altbeacon.beacon.Region

/**
 * BeaconMonitor monitors beacon.
 */
class BeaconMonitor(
    private val beaconManager: BeaconManager,
    private val app: Application,
) {
    private var eventSink: EventChannel.EventSink? = null
    private val handler = Handler(Looper.getMainLooper())

    private val notifier = object : MonitorNotifier {
        override fun didEnterRegion(region: Region) {
            sendEvent(
                eventSink,
                MonitorResult(
                    eventName = MonitorResult.EVENT_ENTER,
                    region = region,
                )
            )
        }

        override fun didExitRegion(region: Region) {
            sendEvent(
                eventSink,
                MonitorResult(
                    eventName = MonitorResult.EVENT_EXIT,
                    region = region
                )
            )
        }

        override fun didDetermineStateForRegion(state: Int, region: Region) {
            sendEvent(
                eventSink,
                MonitorResult(
                    eventName = MonitorResult.EVENT_STATE,
                    state = state,
                    region = region
                )
            )
        }
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

    fun start(region: Region) {
        println("startMonitoring region=${region}")
        if (app is BeaconManagerDelegate) {
            app.startMonitor(region, notifier)
            return
        }
        beaconManager.removeAllMonitorNotifiers()
        beaconManager.addMonitorNotifier(notifier)
        beaconManager.startMonitoring(region)
        println("startMonitoring called")
    }

    private fun sendEvent(
        eventSink: EventChannel.EventSink?,
        result: MonitorResult,
    ) {
        val sink = eventSink ?: return
        handler.post {
            sink.success(result.toMap())
        }
    }
}
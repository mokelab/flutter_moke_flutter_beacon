package com.mokelab.moke_flutter_beacon_example

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.mokelab.moke_flutter_beacon.BackgroundExecutor
import com.mokelab.moke_flutter_beacon.BackgroundMonitorNotifier
import com.mokelab.moke_flutter_beacon.BackgroundRangeNotifier
import com.mokelab.moke_flutter_beacon.BeaconManagerDelegate
import io.flutter.app.FlutterApplication
import org.altbeacon.beacon.BeaconManager
import org.altbeacon.beacon.MonitorNotifier
import org.altbeacon.beacon.RangeNotifier
import org.altbeacon.beacon.Region

class MyApplication : FlutterApplication(), BeaconManagerDelegate {
    companion object {
        private const val CHANNEL_ID = "example"
        private const val NOTIFICATION_ID = 456
    }

    private lateinit var beaconManager: BeaconManager
    private lateinit var backgroundExecutor: BackgroundExecutor
    private lateinit var monitorNotifier: MonitorNotifier
    private lateinit var rangeNotifier: RangeNotifier

    override fun onCreate() {
        super.onCreate()
        beaconManager = BeaconManager.getInstanceForApplication(this)
        backgroundExecutor = BackgroundExecutor(this, this)
        monitorNotifier = BackgroundMonitorNotifier(backgroundExecutor)
        rangeNotifier = BackgroundRangeNotifier(backgroundExecutor, this)

        beaconManager.addMonitorNotifier(monitorNotifier)
        beaconManager.addRangeNotifier(rangeNotifier)
    }

    override fun startMonitor(region: Region) {
        createNotificationChannel()
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setOngoing(true)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("Foreground service")
            .setContentIntent(pendingIntent)
            .build()
        try {
            beaconManager.enableForegroundServiceScanning(notification, NOTIFICATION_ID)
            beaconManager.setEnableScheduledScanJobs(false)
        } catch (e: Exception) {
            println("Failed: e=${e}")
        }

        beaconManager.startMonitoring(region)
        println("startMonitor in Application done")
    }

    override fun stopMonitor(region: Region) {
        beaconManager.stopMonitoring(region)
    }

    override fun startRange(region: Region) {
        beaconManager.startRangingBeacons(region)
    }

    override fun stopRange(region: Region) {
        beaconManager.stopRangingBeacons(region)
    }

    override fun setForegroundMonitorNotifier(notifier: MonitorNotifier) {
        beaconManager.addMonitorNotifier(notifier)
    }

    override fun setForegroundRangeNotifier(notifier: RangeNotifier) {
        beaconManager.addRangeNotifier(notifier)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = NotificationManagerCompat.from(this)
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Foreground　Service",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channel.description = "Description"
            manager.createNotificationChannel(channel)
        }
    }
}
package com.example.moke_flutter_beacon_example

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.example.moke_flutter_beacon.BeaconManagerDelegate
import io.flutter.app.FlutterApplication
import org.altbeacon.beacon.BeaconManager
import org.altbeacon.beacon.MonitorNotifier
import org.altbeacon.beacon.Region

class MyApplication : FlutterApplication(), BeaconManagerDelegate {
    companion object {
        private const val CHANNEL_ID = "example"
        private const val NOTIFICATION_ID = 456
    }

    private lateinit var beaconManager: BeaconManager

    override fun onCreate() {
        super.onCreate()
        beaconManager = BeaconManager.getInstanceForApplication(this)
    }

    override fun startMonitor(region: Region, notifier: MonitorNotifier?) {
        beaconManager.removeAllMonitorNotifiers()
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

        if (notifier != null) {
            beaconManager.addMonitorNotifier(notifier)
        }
        beaconManager.startMonitoring(region)
        println("startMonitor in Application done")
    }

    override fun stopMonitor(region: Region) {
        beaconManager.stopMonitoring(region)
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
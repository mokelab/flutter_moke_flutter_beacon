package com.example.moke_flutter_beacon

import org.altbeacon.beacon.MonitorNotifier
import org.altbeacon.beacon.Region

/**
 * Delegate interface for {@link android.app.Application}
 */
interface BeaconManagerDelegate {
    fun startMonitor(region: Region, notifier: MonitorNotifier?)
    fun stopMonitor(region: Region)
    fun startRange(region: Region)
    fun stopRange(region: Region)
}
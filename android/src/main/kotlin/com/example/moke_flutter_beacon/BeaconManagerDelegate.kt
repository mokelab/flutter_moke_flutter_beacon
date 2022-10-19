package com.example.moke_flutter_beacon

import org.altbeacon.beacon.MonitorNotifier
import org.altbeacon.beacon.RangeNotifier
import org.altbeacon.beacon.Region

/**
 * Delegate interface for {@link android.app.Application}
 */
interface BeaconManagerDelegate {
    fun startMonitor(region: Region)
    fun stopMonitor(region: Region)
    fun startRange(region: Region)
    fun stopRange(region: Region)

    /**
     * Sets {@link MonitorNotifier} for sending foreground stream
     */
    fun setForegroundMonitorNotifier(notifier: MonitorNotifier)

    /**
     * Sets {@link RangeNotifier{ for sending foreground stream
     */
    fun setForegroundRangeNotifier(notifier: RangeNotifier)
}
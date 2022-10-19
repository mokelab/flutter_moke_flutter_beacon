package com.mokelab.moke_flutter_beacon

import org.altbeacon.beacon.MonitorNotifier
import org.altbeacon.beacon.Region

class BackgroundMonitorNotifier(
    private val executor: BackgroundExecutor,
) : MonitorNotifier {
    override fun didEnterRegion(region: Region) {
        executor.callFromBackground(
            listOf(
                "didEnterRegion",
                region.uniqueId,
                region.id1.toString()
            )
        )
    }

    override fun didExitRegion(region: Region) {
        executor.callFromBackground(listOf("didExitRegion", region.uniqueId, region.id1.toString()))
    }

    override fun didDetermineStateForRegion(state: Int, region: Region) {
        executor.callFromBackground(
            listOf(
                "didDetermineStateForRegion",
                region.uniqueId,
                region.id1.toString()
            )
        )
    }
}
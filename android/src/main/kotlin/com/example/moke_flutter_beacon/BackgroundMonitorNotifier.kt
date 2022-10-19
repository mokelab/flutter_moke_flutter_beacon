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
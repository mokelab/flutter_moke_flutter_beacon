package com.example.moke_flutter_beacon

import org.altbeacon.beacon.Beacon
import org.altbeacon.beacon.RangeNotifier
import org.altbeacon.beacon.Region
import org.json.JSONArray
import org.json.JSONObject

class BackgroundRangeNotifier(
    private val executor: BackgroundExecutor,
) : RangeNotifier {
    override fun didRangeBeaconsInRegion(beacons: MutableCollection<Beacon>?, region: Region?) {
        if (beacons == null) return
        val list = beacons.map { beacon -> beacon.toJSON() }
        val array = JSONArray().let { array ->
            list.forEach {
                array.put(it)
            }
            array
        }

        val json = JSONObject().apply {
            put("beacons", array)
        }
        executor.callFromBackground(listOf("didRangeBeacons", json.toString()))
    }
}
package com.mokelab.moke_flutter_beacon

import android.content.Context
import org.altbeacon.beacon.Beacon
import org.altbeacon.beacon.RangeNotifier
import org.altbeacon.beacon.Region
import org.json.JSONArray
import org.json.JSONObject

class BackgroundRangeNotifier(
    private val executor: BackgroundExecutor,
    private val context: Context,
) : RangeNotifier {
    companion object {
        private const val PREF_NAME = "moke_flutter_beacon_pref"
    }

    override fun didRangeBeaconsInRegion(beacons: MutableCollection<Beacon>?, region: Region?) {
        if (beacons == null) return
        val pref = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
        val token1 = pref.getString("token1", "")
        val token2 = pref.getString("token2", "")
        val token3 = pref.getString("token3", "")

        val list = beacons.map { beacon -> beacon.toJSON() }
        val array = JSONArray().let { array ->
            list.forEach {
                array.put(it)
            }
            array
        }

        val json = JSONObject().apply {
            put("beacons", array)
            put("tokens", JSONArray().apply {
                put(token1)
                put(token2)
                put(token3)
            })
        }
        executor.callFromBackground(listOf("didRangeBeacons", json.toString()))
    }
}
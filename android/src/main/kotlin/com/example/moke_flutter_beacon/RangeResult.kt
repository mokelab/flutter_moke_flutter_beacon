package com.example.moke_flutter_beacon

import org.altbeacon.beacon.Beacon

class RangeResult(
    private val beacons: Collection<Beacon>
) {
    fun toList() = beacons.map { beacon ->
        beacon.toMap()
    }.toList()
}

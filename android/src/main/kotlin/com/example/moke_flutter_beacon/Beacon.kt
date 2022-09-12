package com.example.moke_flutter_beacon

import org.altbeacon.beacon.Beacon

fun Beacon.toMap(): Map<String, Any?> = mapOf(
    KEY_IDENTIFIER to "",
    KEY_UUID to id1?.toString(),
    KEY_MAJOR to id2?.toInt(),
    KEY_MINOR to id3?.toInt(),
)

private const val KEY_IDENTIFIER = "identifier"
private const val KEY_UUID = "proximityUUID"
private const val KEY_MAJOR = "major"
private const val KEY_MINOR = "minor"
package com.mokelab.moke_flutter_beacon

import org.altbeacon.beacon.Beacon
import org.json.JSONObject

fun Beacon.toMap(): Map<String, Any?> = mapOf(
    KEY_IDENTIFIER to "",
    KEY_UUID to id1?.toString(),
    KEY_MAJOR to id2?.toInt(),
    KEY_MINOR to id3?.toInt(),
)

fun Beacon.toJSON(): JSONObject = JSONObject().apply {
    put(KEY_IDENTIFIER, "")
    put(KEY_UUID, id1?.toString())
    put(KEY_MAJOR, id2?.toInt())
    put(KEY_MINOR, id3?.toInt())
}

private const val KEY_IDENTIFIER = "identifier"
private const val KEY_UUID = "proximityUUID"
private const val KEY_MAJOR = "major"
private const val KEY_MINOR = "minor"
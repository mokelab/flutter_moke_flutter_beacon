package com.example.moke_flutter_beacon

import io.flutter.plugin.common.MethodCall
import org.altbeacon.beacon.Identifier
import org.altbeacon.beacon.Region

fun Region.toMap(): Map<String, Any?> {
    return mapOf(
        KEY_IDENTIFIER to uniqueId,
        KEY_UUID to id1?.toString(),
        KEY_MAJOR to id2?.toInt(),
        KEY_MINOR to id3?.toInt(),
    )
}

fun MethodCall.toRegion(): Region {
    val identifier = argument<String>(KEY_IDENTIFIER)
    val proximityUUID = argument<String>(KEY_UUID)
    val major = argument<Int>(KEY_MAJOR)
    val minor = argument<Int>(KEY_MINOR)

    return Region(
        identifier,
        if (proximityUUID == null) null else Identifier.parse(proximityUUID),
        if (major == null) null else Identifier.fromInt(major),
        if (minor == null) null else Identifier.fromInt(minor)
    )
}

private const val KEY_IDENTIFIER = "identifier"
private const val KEY_UUID = "proximityUUID"
private const val KEY_MAJOR = "major"
private const val KEY_MINOR = "minor"

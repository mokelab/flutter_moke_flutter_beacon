package com.mokelab.moke_flutter_beacon

import org.altbeacon.beacon.MonitorNotifier
import org.altbeacon.beacon.Region

class MonitorResult(
    private val eventName: String,
    private val state: String,
    private val region: Region,
) {
    constructor(eventName: String, region: Region) :
            this(eventName, STATE_EMPTY, region)

    constructor(eventName: String, state: Int, region: Region) :
            this(
                eventName,
                when (state) {
                    MonitorNotifier.INSIDE -> STATE_INSIDE
                    MonitorNotifier.OUTSIDE -> STATE_OUTSIDE
                    else -> STATE_UNKNOWN
                },
                region,
            )

    fun toMap() = mapOf(
        KEY_EVENT to eventName,
        KEY_STATE to state,
        KEY_RANGE to region.toMap(),
    )

    companion object {
        const val EVENT_ENTER = "didEnterRegion"
        const val EVENT_EXIT = "didExitRegion"
        const val EVENT_STATE = "didDetermineStateForRegion"

        private const val STATE_EMPTY = ""
        private const val STATE_INSIDE = "INSIDE"
        private const val STATE_OUTSIDE = "OUTSIDE"
        private const val STATE_UNKNOWN = "UNKNOWN"

        private const val KEY_EVENT = "event"
        private const val KEY_STATE = "state"
        private const val KEY_RANGE = "range"
    }
}

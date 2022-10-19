package com.mokelab.moke_flutter_beacon

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat

object PermissionHandler {
    fun request(activity: Activity, requestCode: Int) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(
                    Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.ACCESS_FINE_LOCATION,
                ),
                requestCode
            )
        } else {
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(
                    Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.BLUETOOTH_CONNECT,
                    Manifest.permission.BLUETOOTH_SCAN,
                ),
                requestCode
            )
        }
    }

    fun handleOnRequestPermissionResult(
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        for (i in permissions.indices) {
            val result = grantResults[i]
            if (result != PackageManager.PERMISSION_GRANTED) {
                return false
            }
        }
        return true

    }
}
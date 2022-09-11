//
//  CLRegionState+ext.swift
//  moke_flutter_beacon
//
//  Created by fkm on 2022/09/11.
//

import CoreLocation

extension CLRegionState {
    func toStr() -> String {
        if self == CLRegionState.inside {
            return "INSIDE"
        }
        if self == CLRegionState.outside {
            return "OUTSIDE"
        }
        return "UNKNOWN"
    }
}

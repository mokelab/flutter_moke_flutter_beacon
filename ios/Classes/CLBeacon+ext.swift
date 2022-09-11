//
//  CLBeacon+ext.swift
//  moke_flutter_beacon
//
//  Created by fkm on 2022/09/11.
//

import CoreLocation

extension CLBeacon {
    func toDict() -> [String: Any] {
        let map = [
            "identifier": "",
            "proximityUUID": self.uuid.uuidString,
            "major": self.major,
            "minor": self.minor
        ] as [String: Any]
        return map
    }
}

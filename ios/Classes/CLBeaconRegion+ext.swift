//
//  CLBeaconRegion+ext.swift
//  moke_flutter_beacon
//
//  Created by fkm on 2022/09/11.
//
import CoreLocation

extension CLBeaconRegion {
    func toDict() -> [String: Any] {
        var map = [
            "identifier": self.identifier,
        ] as [String: Any]
        map["proximityUUID"] = self.uuid.uuidString
        if self.major != nil {
            map["major"] = self.major!
        }
        if self.minor != nil {
            map["minor"] = self.minor!
        }
        return map
    }
}

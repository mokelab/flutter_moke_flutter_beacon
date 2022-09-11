import Flutter
import UIKit

import CoreLocation

public class SwiftMokeFlutterBeaconPlugin: NSObject,
                                           FlutterPlugin,
                                           CLLocationManagerDelegate
{
    private var locationManager: CLLocationManager!
    private var permissionResult: FlutterResult? = nil
    private var monitorStreamHandler: MFBStreamHandler!
    private var rangeStreamHandler: MFBStreamHandler!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.mokelab.moke_flutter_beacon/method", binaryMessenger: registrar.messenger())
        
        let instance = SwiftMokeFlutterBeaconPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        instance.monitorStreamHandler = MFBStreamHandler()
        let monitorChannel = FlutterEventChannel(
            name: "com.mokelab.moke_flutter_beacon/monitor",
            binaryMessenger: registrar.messenger()
        )
        monitorChannel.setStreamHandler(instance.monitorStreamHandler)
        
        instance.rangeStreamHandler = MFBStreamHandler()
        let rangeChannel = FlutterEventChannel(
            name: "com.mokelab.moke_flutter_beacon/range",
            binaryMessenger: registrar.messenger()
        )
        rangeChannel.setStreamHandler(instance.rangeStreamHandler)
        
        instance.locationManager = CLLocationManager()
        instance.locationManager.delegate = instance
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("handle \(call.method)")
        if call.method == "permission" {
            self.requestPermission(result: result)
            return
        }
        if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
            return
        }
        if call.method == "start" {
            let r = self.startMonitor(call)
            result(r)
            print("start result \(r)")
            return
        }
        if call.method == "start_range" {
            let r = self.startRange(call)
            result(r)
            print("start result \(r)")
            return
        }
        result("iOS " + UIDevice.current.systemVersion)
    }
    
    private func requestPermission(result: @escaping FlutterResult) {
        let status = self.locationManager.authorizationStatus
        if status == CLAuthorizationStatus.authorizedAlways {
            result(true)
            return
        }
        self.permissionResult = result
        self.locationManager.requestAlwaysAuthorization()
    }
    
    private func startMonitor(_ call: FlutterMethodCall) -> Bool {
        let region = self.regionFromCall(call)
        if region == nil {
            return false
        }
        print("region \(region!)")
        self.locationManager.startMonitoring(for: region!)
        return true
    }
    
    private func startRange(_ call: FlutterMethodCall) -> Bool {
        let region = self.regionFromCall(call)
        if region == nil {
            return false
        }
        print("region \(region!)")
        self.locationManager.startRangingBeacons(satisfying: region!.beaconIdentityConstraint)
        return true
    }
    
    private func regionFromCall(_ call: FlutterMethodCall) -> CLBeaconRegion? {
        if let args = call.arguments as? Dictionary<String, Any> {
            let identifier = args["identifier"] as? String
            let proximityUUID = args["proximityUUID"] as? String
            let major = args["major"] as? Int
            let minor = args["minor"] as? Int
            if major == nil && minor == nil {
                return CLBeaconRegion(
                    beaconIdentityConstraint: CLBeaconIdentityConstraint.init(
                        uuid: UUID.init(uuidString: proximityUUID!)!
                    ),
                    identifier: identifier ?? ""
                )
            }
            if major != nil && minor == nil {
                return CLBeaconRegion(
                    beaconIdentityConstraint: CLBeaconIdentityConstraint.init(
                        uuid: UUID.init(uuidString: proximityUUID!)!,
                        major: CLBeaconMajorValue(major!)
                    ),
                    identifier: identifier ?? ""
                )
            }
            return CLBeaconRegion(
                beaconIdentityConstraint: CLBeaconIdentityConstraint.init(
                    uuid: UUID.init(uuidString: proximityUUID!)!,
                    major: CLBeaconMajorValue(major!),
                    minor: CLBeaconMinorValue(minor!)
                ),
                identifier: identifier ?? ""
            )
        }
        return nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization status=\(status)")
        if status == CLAuthorizationStatus.authorizedAlways {
            self.permissionResult?(true)
            self.permissionResult = nil
            return
        }
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            self.locationManager.requestAlwaysAuthorization()
            return
        }
        self.permissionResult?(false)
        self.permissionResult = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            self.sendMonitorEvent(
                sink: self.monitorStreamHandler.eventSink,
                eventName: "didEnterRegion",
                state: "",
                region: beaconRegion
            )
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            self.sendMonitorEvent(
                sink: self.monitorStreamHandler.eventSink,
                eventName: "didExitRegion",
                state: "",
                region: beaconRegion
            )
        }
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didDetermineState state:
        CLRegionState,
        for region: CLRegion
    ) {
        if let beaconRegion = region as? CLBeaconRegion {
            self.sendMonitorEvent(
                sink: self.monitorStreamHandler.eventSink,
                eventName: "didDetermineStateForRegion",
                state: state.toStr(),
                region: beaconRegion
            )
        }
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didRangeBeacons beacons: [CLBeacon],
        in region: CLBeaconRegion
    ) {
        print("didRangeBeacons \(beacons)")
        if rangeStreamHandler.eventSink == nil {
            return
        } 
        var beaconDictList = [] as [[String: Any]]
        for beacon in beacons {
            beaconDictList.append(beacon.toDict())
        }
        rangeStreamHandler.eventSink!(beaconDictList)
    }

    
    private func sendMonitorEvent(
        sink: FlutterEventSink?,
        eventName: String,
        state: String,
        region: CLBeaconRegion
    ) {
        if sink == nil {
            return
        }
        let result = [
            "event": eventName,
            "state": state,
            "range": region.toDict()
        ] as [String : Any]
        sink!(result)
    }
}

import Flutter
import UIKit

import CoreLocation

public class SwiftMokeFlutterBeaconPlugin: NSObject,
                                           FlutterPlugin,
                                           CLLocationManagerDelegate
{
    private static let userDefaults = UserDefaults(suiteName: "com.mokelab.moke_flutter_beacon.userDefaults")!
    private static var flutterPluginRegistrantCallback: FlutterPluginRegistrantCallback?
    private var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    private var locationManager: CLLocationManager!
    private var permissionResult: FlutterResult? = nil
    private var monitorStreamHandler: MFBStreamHandler!
    private var rangeStreamHandler: MFBStreamHandler!
    
    @objc
    public static func setPluginRegistrantCallback(_ callback: @escaping FlutterPluginRegistrantCallback) {
        flutterPluginRegistrantCallback = callback
    }
    
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
        if call.method == "initialize" {
            self.initialize(call: call, result: result)
            return
        }
        if call.method == "permission" {
            self.requestPermission(result: result)
            return
        }
        if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
            return
        }
        if call.method == "save_tokens" {
            let r = self.saveTokens(call)
            result(r)
            print("save tokens done")
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
            print("start_range result \(r)")
            return
        }
        if call.method == "stop_range" {
            let r = self.stopRange(call)
            result(r)
            print("stop_range result \(r)")
            return
        }
        if call.method == "debug_read" {
            guard let dir = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask
            ).first else {
                result(false)
                return
            }
            let file = dir.appendingPathComponent("debug_log.txt")
            // read
            let strInFile = try? String(contentsOf: file)
            if strInFile == nil {
                result("")
            } else {
                result(strInFile!)
            }
            return
        }
        result("iOS " + UIDevice.current.systemVersion)
    }
    
    private func initialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any> {
            let handle = args["handle"] as? Int64
            self.saveCallbackHandle(handle)
        }
    }
    
    private func saveCallbackHandle(_ handle: Int64?) {
        if handle == nil { return }
        SwiftMokeFlutterBeaconPlugin.userDefaults.setValue(handle, forKey: "handle")
    }
    
    private func loadCallbackHandle() -> Int64? {
        SwiftMokeFlutterBeaconPlugin.userDefaults.value(forKey: "handle") as? Int64
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
    
    private func saveTokens(_ call: FlutterMethodCall) -> Bool {
        if let args = call.arguments as? Dictionary<String, Any> {
            let token1 = args["token1"] as? String
            let token2 = args["token2"] as? String
            let token3 = args["token3"] as? String
            
            let defaults = SwiftMokeFlutterBeaconPlugin.userDefaults
            defaults.setValue(token1 ?? "", forKey: "token1")
            defaults.setValue(token2 ?? "", forKey: "token2")
            defaults.setValue(token3 ?? "", forKey: "token3")
            defaults.synchronize()
            return true
        }
        return false
    }
    
    private func startMonitor(_ call: FlutterMethodCall) -> Bool {
        let region = self.regionFromCall(call)
        if region == nil {
            return false
        }
        print("startMonitor region \(region!)")
        self.locationManager.startMonitoring(for: region!)
        return true
    }
    
    private func startRange(_ call: FlutterMethodCall) -> Bool {
        let region = self.regionFromCall(call)
        if region == nil {
            return false
        }
        NSLog("startRange region \(region!)")
        self.locationManager.startRangingBeacons(satisfying: region!.beaconIdentityConstraint)
        return true
    }
    
    private func stopRange(_ call: FlutterMethodCall) -> Bool {
        let region = self.regionFromCall(call)
        if region == nil {
            return false
        }
        NSLog("stopRange region \(region!)")
        self.locationManager.stopRangingBeacons(satisfying: region!.beaconIdentityConstraint)
        return true
    }
    
    private func regionFromCall(_ call: FlutterMethodCall) -> CLBeaconRegion? {
        if let args = call.arguments as? Dictionary<String, Any> {
            let identifier = args["identifier"] as? String
            let proximityUUID = args["proximityUUID"] as? String
            let major = args["major"] as? Int
            let minor = args["minor"] as? Int
            if proximityUUID == nil || proximityUUID!.isEmpty {
                return CLBeaconRegion(beaconIdentityConstraint: CLBeaconIdentityConstraint.init(),
                                      identifier: identifier ?? ""
                )
            }
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
        NSLog("didChangeAuthorization status=\(status)")
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
            self.callFromBackground(args: ["didEnterRegion", beaconRegion.identifier, beaconRegion.uuid.uuidString])
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
            self.callFromBackground(args: ["didExitRegion", beaconRegion.identifier, beaconRegion.uuid.uuidString])
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
            self.callFromBackground(args: ["didDetermineStateForRegion", beaconRegion.identifier, beaconRegion.uuid.uuidString])
        }
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didRangeBeacons beacons: [CLBeacon],
        in region: CLBeaconRegion
    ) {
        NSLog("didRangeBeacons \(beacons) identifier=\(region.identifier)")
        
        let defaults = SwiftMokeFlutterBeaconPlugin.userDefaults
        let token1 = defaults.string(forKey: "token1") ?? ""
        let token2 = defaults.string(forKey: "token2") ?? ""
        let token3 = defaults.string(forKey: "token3") ?? ""
        
        var beaconDictList = [] as [[String: Any]]
        for beacon in beacons {
            var dict = beacon.toDict()
            dict["identifier"] = region.identifier
            beaconDictList.append(dict)
        }
        
        if rangeStreamHandler.eventSink != nil {
            rangeStreamHandler.eventSink!(beaconDictList)
        }
        
        let dictForBackground: [String: Any] = [
            "beacons": beaconDictList,
            "tokens": [token1, token2, token3],
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictForBackground, options: [])
            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
            self.callFromBackground(args: ["didRangeBeacons", jsonStr])
        } catch (let e) {
            print(e)
        }
        
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
    
    private func callFromBackground(args: [String]) {
        NSLog("start callFromBackground")
        guard let callbackHandle = self.loadCallbackHandle(),
              let flutterCallbackInformation = FlutterCallbackCache.lookupCallbackInformation(callbackHandle)
        else {
            print("Failed to find callback")
            return
        }
        var flutterEngine: FlutterEngine? = FlutterEngine(
            name: "com.mokelab.moke_flutter_beacon.background",
            project: nil,
            allowHeadlessExecution: true
        )
        flutterEngine!.run(
            withEntrypoint: flutterCallbackInformation.callbackName,
            libraryURI: flutterCallbackInformation.callbackLibraryPath,
            initialRoute: "",
            entrypointArgs: args
        )
        SwiftMokeFlutterBeaconPlugin.flutterPluginRegistrantCallback?(flutterEngine!)
        
        var backgroundMethodChannel: FlutterMethodChannel? = FlutterMethodChannel(
            name: "com.mokelab.moke_flutter_beacon/background",
            binaryMessenger: flutterEngine!.binaryMessenger
        )
        func cleanupFlutterResources() {
            flutterEngine?.destroyContext()
            backgroundMethodChannel = nil
            flutterEngine = nil
        }
        backgroundMethodChannel?.setMethodCallHandler { [weak self](call, result) in
            UIApplication.shared.beginBackgroundTask()
            if call.method == "start_range" {
                guard let self = self else { return }
                if self.backgroundTaskID.rawValue != 0 {
                    return
                }
                self.locationManager.delegate = self
                self.backgroundTaskID = UIApplication.shared.beginBackgroundTask()
                let r = self.startRange(call)
                result(r)
                return
            }
            if call.method == "stop_range" {
                guard let self = self else { return }
                if self.backgroundTaskID.rawValue == 0 {
                    NSLog("background Task ID is empty")
                    return
                }
                let r = self.stopRange(call)
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
                result(r)
                return
            }
            if call.method == "stop" {
                cleanupFlutterResources()
                result(true)
                return
            }
            if call.method == "debug_write" {
                if let args = call.arguments as? Dictionary<String, Any> {
                    guard let message = args["msg"] as? String else {
                        result(false)
                        return
                    }
                    guard let dir = FileManager.default.urls(for: .documentDirectory,
                                                             in: .userDomainMask
                    ).first else {
                        result(false)
                        return
                    }
                    let file = dir.appendingPathComponent("debug_log.txt")
                    // read
                    var strInFile = try? String(contentsOf: file)
                    if strInFile == nil {
                        strInFile = ""
                    } else {
                        strInFile!.append("\n")
                    }
                    strInFile!.append(message)
                    do {
                        try strInFile!.write(to: file, atomically: true, encoding: .utf8)
                        result(true)
                        return
                    } catch {
                        NSLog("Failed to write debug message")
                        result(false)
                        return
                    }
                }
            }
        }
    }
}

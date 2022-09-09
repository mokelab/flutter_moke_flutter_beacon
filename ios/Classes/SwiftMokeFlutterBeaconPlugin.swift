import Flutter
import UIKit

public class SwiftMokeFlutterBeaconPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "moke_flutter_beacon", binaryMessenger: registrar.messenger())
    let instance = SwiftMokeFlutterBeaconPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

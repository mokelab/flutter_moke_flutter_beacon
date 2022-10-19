import 'entity/monitor.dart';
import 'entity/range.dart';
import 'entity/range_result.dart';
import 'moke_flutter_beacon_platform_interface.dart';

class MokeFlutterBeacon {
  Future<String?> getPlatformVersion() {
    return MokeFlutterBeaconPlatform.instance.getPlatformVersion();
  }

  static Future<bool> initialize(
      Function callback, String entryPointFunctionName) async {
    return await MokeFlutterBeaconPlatform.instance
        .initialize(callback, entryPointFunctionName);
  }

  static Future<bool> requestPermission() async {
    return await MokeFlutterBeaconPlatform.instance.requestPermission();
  }

  static Future<bool> startMonitor(Range range) async {
    return await MokeFlutterBeaconPlatform.instance.startMonitor(range);
  }

  static Future<bool> startRange(Range range) async {
    return await MokeFlutterBeaconPlatform.instance.startRange(range);
  }

  static Future<bool> stopRange(Range range) async {
    return await MokeFlutterBeaconPlatform.instance.stopRange(range);
  }

  static Future<bool> startBackgroundRange(Range range) async {
    return await MokeFlutterBeaconPlatform.instance.startBackgroundRange(range);
  }

  static Future<bool> stopBackgroundRange(Range range) async {
    return await MokeFlutterBeaconPlatform.instance.stopBackgroundRange(range);
  }

  static Stream<MonitorResult> monitor() {
    return MokeFlutterBeaconPlatform.instance
        .monitor()
        .map((event) => MonitorResult.from(event));
  }

  static Stream<RangeResult> range() {
    return MokeFlutterBeaconPlatform.instance
        .range()
        .map((event) => RangeResult.from(event));
  }

  static Future<bool> stopBackground() {
    return MokeFlutterBeaconPlatform.instance.stopBackground();
  }
}

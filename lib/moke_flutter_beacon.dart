import 'entity/monitor.dart';
import 'entity/range.dart';
import 'moke_flutter_beacon_platform_interface.dart';

class MokeFlutterBeacon {
  Future<String?> getPlatformVersion() {
    return MokeFlutterBeaconPlatform.instance.getPlatformVersion();
  }

  static Future<bool> initialize() async {
    return await MokeFlutterBeaconPlatform.instance.initialize();
  }

  static Future<bool> requestPermission() async {
    return await MokeFlutterBeaconPlatform.instance.requestPermission();
  }

  static Future<bool> scanMonitor(Range range) async {
    return await MokeFlutterBeaconPlatform.instance.scanMonitor(range);
  }

  static Stream<MonitorResult> monitor() {
    return MokeFlutterBeaconPlatform.instance
        .monitor()
        .map((event) => MonitorResult.from(event));
  }
}

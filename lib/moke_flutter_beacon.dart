
import 'moke_flutter_beacon_platform_interface.dart';

class MokeFlutterBeacon {
  Future<String?> getPlatformVersion() {
    return MokeFlutterBeaconPlatform.instance.getPlatformVersion();
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:moke_flutter_beacon/moke_flutter_beacon.dart';
import 'package:moke_flutter_beacon/moke_flutter_beacon_platform_interface.dart';
import 'package:moke_flutter_beacon/moke_flutter_beacon_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMokeFlutterBeaconPlatform
    with MockPlatformInterfaceMixin
    implements MokeFlutterBeaconPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }
}

void main() {
  final MokeFlutterBeaconPlatform initialPlatform =
      MokeFlutterBeaconPlatform.instance;

  test('$MethodChannelMokeFlutterBeacon is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMokeFlutterBeacon>());
  });

  test('getPlatformVersion', () async {
    MokeFlutterBeacon mokeFlutterBeaconPlugin = MokeFlutterBeacon();
    MockMokeFlutterBeaconPlatform fakePlatform =
        MockMokeFlutterBeaconPlatform();
    MokeFlutterBeaconPlatform.instance = fakePlatform;

    expect(await mokeFlutterBeaconPlugin.getPlatformVersion(), '42');
  });
}

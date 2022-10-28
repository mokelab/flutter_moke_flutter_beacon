import 'package:flutter_test/flutter_test.dart';
import 'package:moke_flutter_beacon/entity/range.dart';
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
  Future<bool> initialize(
      Function callbackDispatcher, String entryPointFunctionName) {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Stream monitor() {
    // TODO: implement monitor
    throw UnimplementedError();
  }

  @override
  Stream range() {
    // TODO: implement range
    throw UnimplementedError();
  }

  @override
  Future<bool> requestPermission() {
    // TODO: implement requestPermission
    throw UnimplementedError();
  }

  @override
  Future<bool> startMonitor(Range range) {
    // TODO: implement startMonitor
    throw UnimplementedError();
  }

  @override
  Future<bool> startRange(Range range) {
    // TODO: implement startRange
    throw UnimplementedError();
  }

  @override
  Future<bool> stopRange(Range range) {
    // TODO: implement stopRange
    throw UnimplementedError();
  }

  @override
  Future<bool> startBackgroundRange(Range range) {
    // TODO: implement startBackgroundRange
    throw UnimplementedError();
  }

  @override
  Future<bool> stopBackground() {
    // TODO: implement stopBackground
    throw UnimplementedError();
  }

  @override
  Future<bool> stopBackgroundRange(Range range) {
    // TODO: implement stopBackgroundRange
    throw UnimplementedError();
  }

  @override
  Future<bool> debugWrite(String message) {
    // TODO: implement debugWrite
    throw UnimplementedError();
  }

  @override
  Future<String> debugRead() {
    // TODO: implement debugRead
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

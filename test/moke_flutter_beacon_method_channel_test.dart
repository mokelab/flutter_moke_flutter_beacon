import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moke_flutter_beacon/moke_flutter_beacon_method_channel.dart';

void main() {
  MethodChannelMokeFlutterBeacon platform = MethodChannelMokeFlutterBeacon();
  const MethodChannel channel = MethodChannel('moke_flutter_beacon');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}

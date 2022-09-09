import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'moke_flutter_beacon_platform_interface.dart';

/// An implementation of [MokeFlutterBeaconPlatform] that uses method channels.
class MethodChannelMokeFlutterBeacon extends MokeFlutterBeaconPlatform {
  /// The method channel used to interact with the native platform.
  final _methodChannel =
      const MethodChannel('com.mokelab.moke_flutter_beacon/method');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await _methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> initialize() async {
    return await _methodChannel.invokeMethod<bool>('initialize') ?? false;
  }
}

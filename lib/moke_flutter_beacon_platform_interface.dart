import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'moke_flutter_beacon_method_channel.dart';

abstract class MokeFlutterBeaconPlatform extends PlatformInterface {
  /// Constructs a MokeFlutterBeaconPlatform.
  MokeFlutterBeaconPlatform() : super(token: _token);

  static final Object _token = Object();

  static MokeFlutterBeaconPlatform _instance = MethodChannelMokeFlutterBeacon();

  /// The default instance of [MokeFlutterBeaconPlatform] to use.
  ///
  /// Defaults to [MethodChannelMokeFlutterBeacon].
  static MokeFlutterBeaconPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MokeFlutterBeaconPlatform] when
  /// they register themselves.
  static set instance(MokeFlutterBeaconPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> initialize() {
    throw UnimplementedError('initialize() has not been implemented.');
  }
}

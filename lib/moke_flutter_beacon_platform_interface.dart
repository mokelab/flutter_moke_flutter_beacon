import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'entity/range.dart';
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

  Future<bool> initialize(Function callbackDispatcher) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<bool> requestPermission() {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  Future<bool> startMonitor(Range range) {
    throw UnimplementedError('startMonitor() has not been implemented.');
  }

  Future<bool> startRange(Range range) {
    throw UnimplementedError('startRange() has not been implemented.');
  }

  Future<bool> stopRange(Range range) {
    throw UnimplementedError('stopRange() has not been implemented.');
  }

  Future<bool> startBackgroundRange(Range range) {
    throw UnimplementedError(
        'startBackgroundRange() has not been implemented.');
  }

  Future<bool> stopBackgroundRange(Range range) {
    throw UnimplementedError('stopBackgroundRange() has not been implemented.');
  }

  Stream<dynamic> monitor() {
    throw UnimplementedError('monitor() has not been implemented.');
  }

  Stream<dynamic> range() {
    throw UnimplementedError('range() has not been implemented.');
  }

  Future<bool> stopBackground() {
    throw UnimplementedError('stopBackground() has not been implemented.');
  }
}

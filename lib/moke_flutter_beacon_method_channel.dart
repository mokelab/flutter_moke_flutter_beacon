import 'dart:ui';

import 'package:flutter/services.dart';

import 'entity/range.dart';
import 'moke_flutter_beacon_platform_interface.dart';

/// An implementation of [MokeFlutterBeaconPlatform] that uses method channels.
class MethodChannelMokeFlutterBeacon extends MokeFlutterBeaconPlatform {
  /// The method channel used to interact with the native platform.
  final _methodChannel =
      const MethodChannel('com.mokelab.moke_flutter_beacon/method');
  final _monitorChannel =
      const EventChannel("com.mokelab.moke_flutter_beacon/monitor");
  final _rangeChannel =
      const EventChannel("com.mokelab.moke_flutter_beacon/range");

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await _methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> initialize(Function callbackDispatcher) async {
    final callback = PluginUtilities.getCallbackHandle(callbackDispatcher);
    if (callback == null) return false;
    final int handle = callback.toRawHandle();
    return await _methodChannel.invokeMethod<bool>('initialize', handle) ??
        false;
  }

  @override
  Future<bool> requestPermission() async {
    return await _methodChannel.invokeMethod<bool>('permission') ?? false;
  }

  @override
  Future<bool> startMonitor(Range range) async {
    return await _methodChannel.invokeMethod<bool>('start', range.toMap()) ??
        false;
  }

  @override
  Future<bool> startRange(Range range) async {
    return await _methodChannel.invokeMethod<bool>(
            'start_range', range.toMap()) ??
        false;
  }

  @override
  Future<bool> stopRange(Range range) async {
    return await _methodChannel.invokeMethod<bool>(
            'stop_range', range.toMap()) ??
        false;
  }

  @override
  Stream<dynamic> monitor() {
    return _monitorChannel.receiveBroadcastStream();
  }

  @override
  Stream<dynamic> range() {
    return _rangeChannel.receiveBroadcastStream();
  }
}

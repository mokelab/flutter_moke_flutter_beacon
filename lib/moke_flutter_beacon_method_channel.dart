import 'dart:ui';

import 'package:flutter/services.dart';

import 'entity/range.dart';
import 'moke_flutter_beacon_platform_interface.dart';

/// An implementation of [MokeFlutterBeaconPlatform] that uses method channels.
class MethodChannelMokeFlutterBeacon extends MokeFlutterBeaconPlatform {
  /// The method channel used to interact with the native platform.
  final _methodChannel =
      const MethodChannel('com.mokelab.moke_flutter_beacon/method');
  final _backgroundMethodChannel =
      const MethodChannel('com.mokelab.moke_flutter_beacon/background');
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
  Future<bool> initialize(
      Function callbackDispatcher, String entryPointFunctionName) async {
    final callback = PluginUtilities.getCallbackHandle(callbackDispatcher);
    if (callback == null) return false;
    final int handle = callback.toRawHandle();
    return await _methodChannel.invokeMethod<bool>(
            'initialize', <String, dynamic>{
          "handle": handle,
          "entryPointFunctionName": entryPointFunctionName
        }) ??
        false;
  }

  @override
  Future<bool> requestPermission() async {
    return await _methodChannel.invokeMethod<bool>('permission') ?? false;
  }

  @override
  Future<bool> saveTokens(String token1, String token2, String token3) async {
    return await _methodChannel.invokeMethod<bool>('save_tokens', {
          "token1": token1,
          "token2": token2,
          "token3": token3,
        }) ??
        false;
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
  Future<bool> startBackgroundRange(Range range) async {
    return await _backgroundMethodChannel.invokeMethod<bool>(
            'start_range', range.toMap()) ??
        false;
  }

  @override
  Future<bool> stopBackgroundRange(Range range) async {
    return await _backgroundMethodChannel.invokeMethod<bool>(
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

  @override
  Future<bool> stopBackground() async {
    return await _backgroundMethodChannel.invokeMethod<bool>('stop') ?? false;
  }

  @override
  Future<bool> debugWrite(String message) async {
    return await _backgroundMethodChannel
            .invokeMethod<bool>('debug_write', {"msg": message}) ??
        false;
  }

  @override
  Future<String> debugRead() async {
    return await _methodChannel.invokeMethod<String>('debug_read') ?? "";
  }
}

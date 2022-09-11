import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:moke_flutter_beacon/entity/range.dart';
import 'package:moke_flutter_beacon/moke_flutter_beacon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _mokeFlutterBeaconPlugin = MokeFlutterBeacon();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initMonitor();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _mokeFlutterBeaconPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> initMonitor() async {
    var granted = await MokeFlutterBeacon.requestPermission();
    if (!granted) {
      print("not granted");
      return;
    }
    Range range =
        //Range("test", null, null, null);
        Range("test", "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", null, null);
    var result = await MokeFlutterBeacon.scanMonitor(range);
    print("monitor: $result");

    MokeFlutterBeacon.monitor().listen((event) {
      print("event ${event.event} UUID=${event.range.proximityUUID}");
      if (event.event == "didEnterRegion") {
        MokeFlutterBeacon.scanRange(event.range);
      }
    });

    MokeFlutterBeacon.range().listen((event) {
      print("range \(event)");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}

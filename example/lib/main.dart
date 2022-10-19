import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:moke_flutter_beacon/entity/range.dart';
import 'package:moke_flutter_beacon/moke_flutter_beacon.dart';

@pragma("vm:entry-point")
void callbackDispatcher(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  print("call from Background args=$args");
  if (args[0] == "didEnterRegion") {
    MokeFlutterBeacon.startBackgroundRange(Range(args[1], args[2], null, null));
  } else if (args[0] == "didExitRegion") {
    MokeFlutterBeacon.stopBackgroundRange(Range(args[1], args[2], null, null));
  } else if (args[0] == "didRangeBeacons") {
    print("Called didRangeBeacons ${args[1]}");
    Map<String, dynamic> beaconJSON = json.decode(args[1]);
    List<dynamic> beacons = beaconJSON["beacons"] as List<dynamic>;
    String identifier = beacons[0]["identifier"];
    String uuid = beacons[0]["proximityUUID"];
    print("identifier=$identifier uuid=$uuid");
    MokeFlutterBeacon.stopBackgroundRange(Range("test", uuid, null, null));
  }
  MokeFlutterBeacon.stopBackground();
}

void main() {
  print("start main");
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
    MokeFlutterBeacon.initialize(callbackDispatcher, "callbackDispatcher");
    var granted = await MokeFlutterBeacon.requestPermission();
    if (!granted) {
      print("not granted");
      return;
    }
    Range range =
        //Range("test", null, null, null);
        Range("test", "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", null, null);
    var result = await MokeFlutterBeacon.startMonitor(range);
    print("monitor: $result");

    MokeFlutterBeacon.monitor().listen((event) {
      print("event ${event.event} UUID=${event.range.proximityUUID}");
      if (event.event == "didEnterRegion") {
        MokeFlutterBeacon.startRange(event.range);
      } else if (event.event == "didExitRegion") {
        MokeFlutterBeacon.stopRange(event.range);
      }
    });

    MokeFlutterBeacon.range().listen((event) {
      print("range $event");
      if (event.rangeList.isEmpty) return;
      MokeFlutterBeacon.stopRange(
          event.rangeList[0].copyWithIdentifier("test"));
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

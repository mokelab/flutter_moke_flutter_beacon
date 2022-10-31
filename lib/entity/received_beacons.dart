import 'dart:convert';

class ReceivedBeacons {
  final List<ReceivedBeacon> beacons;
  final List<String> tokens;

  ReceivedBeacons(this.beacons, this.tokens);

  static ReceivedBeacons parse(String jsonStr) {
    final Map<String, dynamic> data = json.decode(jsonStr);
    final beacons = (data["beacons"] as List<dynamic>)
        .map((e) => ReceivedBeacon.fromJSON(e))
        .toList();
    final tokens =
        (data["tokens"] as List<dynamic>).map((e) => e as String).toList();

    return ReceivedBeacons(beacons, tokens);
  }
}

class ReceivedBeacon {
  final String identifier;
  final String uuid;
  final int major;
  final int minor;

  const ReceivedBeacon(this.identifier, this.uuid, this.major, this.minor);

  static ReceivedBeacon fromJSON(Map<String, dynamic> json) {
    final identifier = json["identifier"] as String;
    final uuid = json["proximityUUID"] as String;
    final major = json["major"] as int;
    final minor = json["minor"] as int;
    return ReceivedBeacon(identifier, uuid, major, minor);
  }
}

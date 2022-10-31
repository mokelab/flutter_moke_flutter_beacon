import 'package:flutter_test/flutter_test.dart';
import 'package:moke_flutter_beacon/entity/received_beacons.dart';

void main() {
  test("OK", () {
    final beacons = ReceivedBeacons.parse(str1);
    expect(beacons.beacons.length, 1);
    expect(beacons.tokens.length, 3);
    expect(beacons.tokens[0], "access_token");
    expect(beacons.tokens[1], "refresh_token");
    expect(beacons.tokens[2], "");
  });

  test("empty beacons", () {
    final beacons = ReceivedBeacons.parse(str2);
    expect(beacons.beacons.length, 0);
    expect(beacons.tokens.length, 3);
  });
}

const String str1 = '''{
  "beacons":[{
    "identifier":"test",
    "proximityUUID":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0",
    "major":1,
    "minor":2
  }],
  "tokens":["access_token","refresh_token",""]
}''';

const String str2 = '''{
  "beacons":[],
  "tokens":["access_token","refresh_token",""]
}''';

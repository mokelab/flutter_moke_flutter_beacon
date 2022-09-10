import 'range.dart';

class MonitorResult {
  final String event;
  final String state;
  final Range range;

  MonitorResult(this.event, this.state, this.range);

  static MonitorResult from(dynamic json) {
    String event = json['event'];
    String state = json['state'];
    Range range = Range.from(json['range']);
    return MonitorResult(event, state, range);
  }
}

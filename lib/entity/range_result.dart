import 'range.dart';

class RangeResult {
  final List<Range> rangeList;

  RangeResult(this.rangeList);

  static RangeResult from(dynamic json) {
    List<dynamic> jsonArr = json as List<dynamic>;
    List<Range> rangeList = jsonArr.map((e) => Range.from(e)).toList();
    return RangeResult(rangeList);
  }
}

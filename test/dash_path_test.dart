import 'dart:ui' show Path;

import 'package:path_drawing/path_drawing.dart';

import 'package:test/test.dart';

void main() {
  test('CircularList tests', () {
    final List<int> ints = <int>[1, 2, 3];

    final CircularIntervalList<int> list = CircularIntervalList<int>(ints);

    expect(list.next, 1);
    expect(list.next, 2);
    expect(list.next, 3);
    expect(list.next, 1);
    expect(list.next, 2);
    expect(list.next, 3);
  });

  test('DashPath tests', () {
    final Path singleSegmentLine = Path()..lineTo(10.0, 10.0);
    final CircularIntervalList<double> dashArray =
        CircularIntervalList<double>(<double>[1.0, 5.0]);

    expect(
      () => dashPath(singleSegmentLine, dashArray: null),
      throwsA(const TypeMatcher<AssertionError>()),
    );
    expect(dashPath(singleSegmentLine, dashArray: dashArray), isNotNull);
    expect(
      dashPath(singleSegmentLine,
          dashArray: dashArray, dashOffset: DashOffset.percentage(5.0)),
      isNotNull,
    );

    expect(dashPath(null, dashArray: dashArray), isNull);
  });
}

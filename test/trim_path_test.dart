import 'dart:ui' show Path, Rect;

import 'package:path_drawing/path_drawing.dart';

import 'package:test/test.dart';

void main() {
  test('TrimPath tests', () {
    final Path singleSegmentLine = Path()..lineTo(10.0, 10.0);
    final Path multiSegmentLine = Path()
      ..lineTo(10.0, 10.0)
      ..moveTo(50.0, 10.0)
      ..lineTo(20.0, 20.0);

    expect(() => trimPath(singleSegmentLine, null),
        throwsA(const TypeMatcher<AssertionError>()));
    expect(() => trimPath(singleSegmentLine, 0.0, firstOnly: null),
        throwsA(const TypeMatcher<AssertionError>()));
    expect(() => trimPath(singleSegmentLine, 0.0, origin: null),
        throwsA(const TypeMatcher<AssertionError>()));
    expect(trimPath(singleSegmentLine, 0.5).getBounds(),
        Rect.fromLTRB(5, 5, 10, 10));
    expect(trimPath(singleSegmentLine, 1.0).getBounds(), Rect.zero);
    expect(trimPath(singleSegmentLine, 0.0).getBounds(),
        singleSegmentLine.getBounds());
    expect(trimPath(singleSegmentLine, 0.5, origin: PathTrimOrigin.end),
        isNotNull);
    expect(trimPath(singleSegmentLine, 0.5, firstOnly: false), isNotNull);

    expect(trimPath(multiSegmentLine, 0.5, firstOnly: false).getBounds(),
        Rect.fromLTRB(5, 5, 35, 20));
    expect(trimPath(multiSegmentLine, 0.5).getBounds(),
        Rect.fromLTRB(5, 5, 10, 10));

    expect(trimPath(null, 0.0), isNull);
  });
}

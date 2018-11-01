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
}

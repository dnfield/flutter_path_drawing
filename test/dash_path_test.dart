import 'package:path_drawing/path_drawing.dart';

import 'package:test/test.dart';

void main() {
  test('CircularList tests', () {
    List<int> ints = [1, 2, 3];

    CircularIntervalList list = new CircularIntervalList(ints);

    expect(list.next, 1);
    expect(list.next, 2);
    expect(list.next, 3);
    expect(list.next, 1);
    expect(list.next, 2);
    expect(list.next, 3);
  });
}
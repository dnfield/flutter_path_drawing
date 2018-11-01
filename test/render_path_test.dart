import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';

import 'package:test/test.dart';

import '../tool/path_to_image.dart';

void main() {
  test('Path rendering matches golden files', () async {
    for (int i = 0; i < paths.length; i++) {
      final Uint8List bytes = await getPathPngBytes(paths[i]);
      final File golden = File(join(
          dirname(Platform.script.path),
          dirname(Platform.script.path).endsWith('test') ? '..' : '',
          'golden',
          '$i.png'));
      final Uint8List goldenBytes = await golden.readAsBytes();

      expect(bytes, orderedEquals(goldenBytes));
    }
  });
}

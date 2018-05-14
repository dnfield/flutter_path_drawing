import 'dart:async';
import 'dart:io';
import 'dart:math' show max;
import 'dart:typed_data';
import 'dart:ui';

import 'package:path/path.dart';

import 'package:path_drawing/path_drawing.dart';

const List<String> paths = <String>[
  'M100,200 L3,4',
  'M100,200 l3,4',
  'M100,200 H3',
  'M100,200 h3',
  'M100,200 V3',
  'M100,200 v3',
  'M100,200 C3,4,5,6,7,8',
  'M100,200 c3,4,5,6,7,8',
  'M100,200 S3,4,5,6',
  'M100,200 s3,4,5,6',
  'M100,200 Q3,4,5,6',
  'M100,200 q3,4,5,6',
  'M100,200 T3,4',
  'M100,200 t3,4',
  'M100,200 A3,4,5,0,0,6,7',
  'M100,200 A3,4,5,1,0,6,7',
  'M100,200 A3,4,5,0,1,6,7',
  'M100,200 A3,4,5,1,1,6,7',
  'M100,200 a3,4,5,0,0,6,7',
  'M100,200 a3,4,5,0,1,6,7',
  'M100,200 a3,4,5,1,0,6,7',
  'M100,200 a3,4,5,1,1,6,7',
  'M100,200 a3,4,5,006,7',
  'M100,200 a3,4,5,016,7',
  'M100,200 a3,4,5,106,7',
  'M100,200 a3,4,5,116,7',
  '''M19.0281,19.40466 20.7195,19.40466 20.7195,15.71439 24.11486,15.71439 24.11486,14.36762 20.7195,14.36762
20.7195,11.68641 24.74134,11.68641 24.74134,10.34618 19.0281,10.34618 	z''',
  'M100,200 a0,4,5,0,0,10,0 a4,0,5,0,0,0,10 a0,0,5,0,0,-10,0 z',
  'M.1 .2 L.3 .4 .5 .6',
  'M1,1h2,3',
  'M1,1H2,3',
  'M1,1v2,3',
  'M1,1V2,3',
  'M1,1c2,3 4,5 6,7 8,9 10,11 12,13',
  'M1,1C2,3 4,5 6,7 8,9 10,11 12,13',
  'M1,1s2,3 4,5 6,7 8,9',
  'M1,1S2,3 4,5 6,7 8,9',
  'M1,1q2,3 4,5 6,7 8,9',
  'M1,1Q2,3 4,5 6,7 8,9',
  'M1,1t2,3 4,5',
  'M1,1T2,3 4,5',
  'M1,1a2,3,4,0,0,5,6 7,8,9,0,0,10,11',
  'M1,1A2,3,4,0,0,5,6 7,8,9,0,0,10,11',
];
final Paint blackStrokePaint = new Paint()
  ..color = const Color.fromARGB(255, 0, 0, 0)
  ..strokeWidth = 2.0
  ..style = PaintingStyle.stroke;
final Paint whiteFillPaint = new Paint()
  ..color = const Color.fromARGB(255, 255, 255, 255)
  ..style = PaintingStyle.fill;

Future<Uint8List> getPathPngBytes(String pathString) async {
    final PictureRecorder rec = new PictureRecorder();
    final Canvas canvas = new Canvas(rec);

    final Path p = parseSvgPathData(pathString);
    assert(p != null);

    final Rect bounds = p.getBounds();

    canvas.drawPaint(whiteFillPaint);

    canvas.drawPath(p, blackStrokePaint);

    final Picture pict = rec.endRecording();

    final int imgWidth =
        (max(max(bounds.width, bounds.right), 5.0) + 10.0).ceil();
    final int imgHeight =
        (max(max(bounds.height, bounds.bottom), 5.0) + 10.0).ceil();

    final Image image = pict.toImage(imgWidth, imgHeight);
    final ByteData bytes = await image.toByteData(format: ImageByteFormat.png);

    return bytes.buffer.asUint8List();
}

Future<Null> main() async {
  for (int i = 0; i < paths.length; i++) {
    final String pathName = join(dirname(Platform.script.path), 'golden', '$i.png');
    final File output = new File(pathName);
    await output.writeAsBytes(await getPathPngBytes(paths[i]));
  }
}

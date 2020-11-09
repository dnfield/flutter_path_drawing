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
  'm18 11.8a.41.41 0 0 1 .24.08l.59.43h.05.72a.4.4 0 0 1 .39.28l.22.69a.08.08 0 0 0 0 0l.58.43a.41.41 0 0 1 .15.45l-.22.68a.09.09 0 0 0 0 .07l.22.68a.4.4 0 0 1 -.15.46l-.58.42a.1.1 0 0 0 0 0l-.22.68a.41.41 0 0 1 -.38.29h-.79l-.58.43a.41.41 0 0 1 -.24.08.46.46 0 0 1 -.24-.08l-.58-.43h-.06-.72a.41.41 0 0 1 -.39-.28l-.22-.68a.1.1 0 0 0 0 0l-.58-.43a.42.42 0 0 1 -.15-.46l.23-.67v-.02l-.29-.68a.43.43 0 0 1 .15-.46l.58-.42a.1.1 0 0 0 0-.05l.27-.69a.42.42 0 0 1 .39-.28h.78l.58-.43a.43.43 0 0 1 .25-.09m0-1a1.37 1.37 0 0 0 -.83.27l-.34.25h-.43a1.42 1.42 0 0 0 -1.34 1l-.13.4-.35.25a1.42 1.42 0 0 0 -.51 1.58l.13.4-.13.4a1.39 1.39 0 0 0 .52 1.59l.34.25.13.4a1.41 1.41 0 0 0 1.34 1h.43l.34.26a1.44 1.44 0 0 0 .83.27 1.38 1.38 0 0 0 .83-.28l.35-.24h.43a1.4 1.4 0 0 0 1.33-1l.13-.4.35-.26a1.39 1.39 0 0 0 .51-1.57l-.13-.4.13-.41a1.4 1.4 0 0 0 -.51-1.56l-.35-.25-.13-.41a1.4 1.4 0 0 0 -1.34-1h-.42l-.34-.26a1.43 1.43 0 0 0 -.84-.28z',
];
final Paint blackStrokePaint = Paint()
  ..color = const Color.fromARGB(255, 0, 0, 0)
  ..strokeWidth = 1.0
  ..style = PaintingStyle.stroke;
final Paint whiteFillPaint = Paint()
  ..color = const Color.fromARGB(255, 255, 255, 255)
  ..style = PaintingStyle.fill;

Future<Uint8List> getPathPngBytes(String pathString) async {
  final PictureRecorder rec = PictureRecorder();
  final Canvas canvas = Canvas(rec);

  final Path p = parseSvgPathData(pathString);

  final Rect bounds = p.getBounds();
  const double scaleFactor = 5.0;
  canvas.scale(scaleFactor);
  canvas.drawPaint(whiteFillPaint);

  canvas.drawPath(p, blackStrokePaint);

  final Picture pict = rec.endRecording();

  final int imgWidth =
      (max(bounds.width, bounds.right) * 2 * scaleFactor).ceil();
  final int imgHeight =
      (max(bounds.height, bounds.bottom) * 2 * scaleFactor).ceil();

  final Image image = await pict.toImage(imgWidth, imgHeight);
  final ByteData bytes = (await image.toByteData(format: ImageByteFormat.png))!;

  return bytes.buffer.asUint8List();
}

Future<void> main() async {
  for (int i = 0; i < paths.length; i++) {
    final String pathName =
        join(dirname(Platform.script.path), 'golden', '$i.png');
    final File output = File(pathName);
    await output.writeAsBytes(await getPathPngBytes(paths[i]));
  }
}

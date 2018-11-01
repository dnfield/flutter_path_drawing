import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index;
  double _trimPercent;
  PathTrimOrigin _trimOrigin;

  @override
  void initState() {
    super.initState();
    index = 0;
    _trimPercent = 0.2;
    _trimOrigin = PathTrimOrigin.begin;
  }

  String get currPath => paths[index];

  void nextPath() {
    setState(() => index = index >= paths.length - 1 ? 0 : index + 1);
  }

  void prevPath() {
    setState(() => index = index == 0 ? paths.length - 1 : index - 1);
  }

  void setTrimPercent(double value) {
    setState(() {
      _trimPercent = value;
    });
  }

  void toggleTrimOrigin(PathTrimOrigin value) {
    setState(() {
      switch (_trimOrigin) {
        case PathTrimOrigin.begin:
          _trimOrigin = PathTrimOrigin.end;
          break;
        case PathTrimOrigin.end:
          _trimOrigin = PathTrimOrigin.begin;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: <Tab>[
              const Tab(text: 'Path Trim'),
              const Tab(text: 'Path Dash'),
              const Tab(text: 'Path Parse'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                CustomPaint(
                    painter: TrimPathPainter(_trimPercent, _trimOrigin)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Slider(
                        value: _trimPercent,
                        onChanged: (double value) => setTrimPercent(value),
                      ),
                      RadioListTile<PathTrimOrigin>(
                        title: Text(PathTrimOrigin.begin.toString()),
                        value: PathTrimOrigin.begin,
                        groupValue: _trimOrigin,
                        onChanged: toggleTrimOrigin,
                      ),
                      RadioListTile<PathTrimOrigin>(
                        title: Text(PathTrimOrigin.end.toString()),
                        value: PathTrimOrigin.end,
                        groupValue: _trimOrigin,
                        onChanged: toggleTrimOrigin,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CustomPaint(painter: DashPathPainter()),
            Stack(
              children: <Widget>[
                CustomPaint(painter: PathTestPainter(currPath)),
                GestureDetector(
                  onTap: nextPath,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

const List<String> paths = <String>[
  'm18 11.8a.41.41 0 0 1 .24.08l.59.43h.05.72a.4.4 0 0 1 .39.28l.22.69a.08.08 0 0 0 0 0l.58.43a.41.41 0 0 1 .15.45l-.22.68a.09.09 0 0 0 0 .07l.22.68a.4.4 0 0 1 -.15.46l-.58.42a.1.1 0 0 0 0 0l-.22.68a.41.41 0 0 1 -.38.29h-.79l-.58.43a.41.41 0 0 1 -.24.08.46.46 0 0 1 -.24-.08l-.58-.43h-.06-.72a.41.41 0 0 1 -.39-.28l-.22-.68a.1.1 0 0 0 0 0l-.58-.43a.42.42 0 0 1 -.15-.46l.23-.67v-.02l-.29-.68a.43.43 0 0 1 .15-.46l.58-.42a.1.1 0 0 0 0-.05l.27-.69a.42.42 0 0 1 .39-.28h.78l.58-.43a.43.43 0 0 1 .25-.09m0-1a1.37 1.37 0 0 0 -.83.27l-.34.25h-.43a1.42 1.42 0 0 0 -1.34 1l-.13.4-.35.25a1.42 1.42 0 0 0 -.51 1.58l.13.4-.13.4a1.39 1.39 0 0 0 .52 1.59l.34.25.13.4a1.41 1.41 0 0 0 1.34 1h.43l.34.26a1.44 1.44 0 0 0 .83.27 1.38 1.38 0 0 0 .83-.28l.35-.24h.43a1.4 1.4 0 0 0 1.33-1l.13-.4.35-.26a1.39 1.39 0 0 0 .51-1.57l-.13-.4.13-.41a1.4 1.4 0 0 0 -.51-1.56l-.35-.25-.13-.41a1.4 1.4 0 0 0 -1.34-1h-.42l-.34-.26a1.43 1.43 0 0 0 -.84-.28z',
  '''M 15 15.5 A 0.5 1.5 0 1 1  14,15.5 A 0.5 1.5 0 1 1  15 15.5 z''',
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

final Paint black = Paint()
  ..color = Colors.black
  ..strokeWidth = 1.0
  ..style = PaintingStyle.stroke;

class TrimPathPainter extends CustomPainter {
  TrimPathPainter(this.percent, this.origin);

  final double percent;
  final PathTrimOrigin origin;

  final Path p = Path()
    ..moveTo(10.0, 10.0)
    ..lineTo(100.0, 100.0)
    ..quadraticBezierTo(125.0, 20.0, 200.0, 100.0);

  @override
  bool shouldRepaint(TrimPathPainter oldDelegate) =>
      oldDelegate.percent != percent;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(trimPath(p, percent, origin: origin), black);
  }
}

class DashPathPainter extends CustomPainter {
  final Path p = Path()
    ..moveTo(10.0, 10.0)
    ..lineTo(100.0, 100.0)
    ..quadraticBezierTo(125.0, 20.0, 200.0, 100.0)
    ..addRect(Rect.fromLTWH(0.0, 0.0, 50.0, 50.0));

  @override
  bool shouldRepaint(DashPathPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        dashPath(
          p,
          dashArray: CircularIntervalList<double>(
            <double>[5.0, 2.5],
          ),
        ),
        black);
  }
}

class PathTestPainter extends CustomPainter {
  PathTestPainter(String path) : p = parseSvgPathData(path);

  final Path p;

  @override
  bool shouldRepaint(PathTestPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(p, black);
  }
}

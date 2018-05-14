import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
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
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new CustomPaint(painter: new PathTestPainter())],
        ),
      ),
    );
  }
}

class PathTestPainter extends CustomPainter {
  final Path p = parseSvgPathData(
      '''M19.0281,19.40466 20.7195,19.40466 20.7195,15.71439 24.11486,15.71439 24.11486,14.36762 20.7195,14.36762 
20.7195,11.68641 24.74134,11.68641 24.74134,10.34618 19.0281,10.34618 	z''');
  final Path p5 = parseSvgPathData(
      '''M 15 15.5 A 0.5 1.5 0 1 1  14,15.5 A 0.5 1.5 0 1 1  15 15.5 z''');
  final Path p2 = new Path()
    ..moveTo(10.0, 10.0)
    ..lineTo(100.0, 100.0)
    //..lineTo(125.0, 20.0)
    ..quadraticBezierTo(125.0, 20.0, 200.0, 100.0)
    ..addRect(new Rect.fromLTWH(0.0, 0.0, 50.0, 50.0));
  final Path p3 = new Path()
    ..addRect(new Rect.fromLTWH(20.0, 20.0, 50.0, 50.0));
  final Paint black = new Paint()
    ..color = Colors.black
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;
  final Paint red = new Paint()
    ..color = Colors.red
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;

  @override
  bool shouldRepaint(PathTestPainter old) => true;

  static Float64List matrix(
      double a, double b, double c, double d, double e, double f) {
    return new Matrix4(
            a, b, 0.0, 0.0, c, d, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, e, f, 0.0, 1.0)
        .storage;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        p5.transform(matrix(0.866, 0.5, -0.5, 0.866, 9.693, -5.173)), red);
    canvas.drawPath(p2, black);
    canvas.translate(0.0, -100.0);
    canvas.drawPath(
        dashPath(p2,
            dashArray: new CircularIntervalList<double>(
                <double>[5.0, 10.0, 15.0, 15.0]),
            dashOffset: new DashOffset.percentage(.05)),
        red);
    canvas
      ..scale(5.0, 5.0)
      ..translate(-50.0, -35.0);
    canvas.drawPath(p3, red);
    canvas.drawPath(p2, red);
    canvas.drawPath(Path.combine(PathOperation.intersect, p2, p3), black);
  }
}

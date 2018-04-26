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
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
          children: <Widget>[
new CustomPaint(painter: new PathTestPainter())
          ],
        ),
      ),
    );
  }
}

class PathTestPainter extends CustomPainter {
    final Path p = parseSvgPathData('''M19.0281,19.40466 20.7195,19.40466 20.7195,15.71439 24.11486,15.71439 24.11486,14.36762 20.7195,14.36762 
20.7195,11.68641 24.74134,11.68641 24.74134,10.34618 19.0281,10.34618 	z''');

  bool shouldRepaint(PathTestPainter old) => true;

  void paint(Canvas canvas, Size size) {
    canvas.drawPath(p, new Paint()..color = Colors.black);
  }
}
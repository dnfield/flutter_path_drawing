# path_drawing

[![pub package](https://img.shields.io/pub/v/path_drawing.svg)](https://pub.dev/packages/path_drawing)

A Flutter library to assist with creating and manipulating paths.

Currently supports parsing a `Path` from an SVG path data string
(including normalizing the path commands to be amenable to Flutter's exposed
Path methods).

Dash paths has an initial implementation that relies on flutter 0.3.6 at a minimum.

Planned for future release(s):

- Trim paths

## Example

Create CustomPainter:

```dart
class FilledPathPainter extends CustomPainter {
  const FilledPathPainter({
    @required this.path,
    @required this.color,
  });

  final Path path;
  final Color color;

  @override
  bool shouldRepaint(FilledPathPainter oldDelegate) =>
      oldDelegate.path != path || oldDelegate.color != color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool hitTest(Offset position) => path.contains(position);
}
```

Parse a path from svg string:

```dart
final trianglePath = parseSvgPathData('M150 0 L75 200 L225 200 Z');
```

Use it in widgets:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('tap'),
      child: CustomPaint(
        painter: FilledPathPainter(
          path: trianglePath,
          color: Colors.blue,
        ),
      ),
    );
  }
}
```

Another examples can be found in [example folder](example/lib/main.dart)

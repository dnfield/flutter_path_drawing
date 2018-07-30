import 'dart:ui' show Path;

import 'package:path_parsing/path_parsing.dart';

/// Creates a [Path] object from an SVG data string.
///
/// Passing a null string as `svg` will result in a null path.
/// Passing an empty string will result in an empty path.
Path parseSvgPathData(String svg) {
  if (svg == null) {
    return null;
  }
  if (svg == '') {
    return new Path();
  }

  final SvgPathStringSource parser = new SvgPathStringSource(svg);
  final FlutterPathProxy path = new FlutterPathProxy();
  final SvgPathNormalizer normalizer = new SvgPathNormalizer();
  for (PathSegmentData seg in parser.parseSegments()) {
    normalizer.emitSegment(seg, path);
  }
  return path.path;
}

class FlutterPathProxy extends PathProxy {
  FlutterPathProxy({Path p}) : path = p ?? new Path();

  final Path path;

  @override
  void close() {
    path.close();
  }

  @override
  void cubicTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    path.cubicTo(x1, y1, x2, y2, x3, y3);
  }

  @override
  void lineTo(double x, double y) {
    path.lineTo(x, y);
  }

  @override
  void moveTo(double x, double y) {
    path.moveTo(x, y);
  }
}

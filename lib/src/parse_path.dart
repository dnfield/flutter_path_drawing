import 'dart:ui' show Path;

import 'package:path_parsing/path_parsing.dart';

/// Creates a [Path] object from an SVG data string.
///
/// Passing an empty string will result in an empty path.
Path parseSvgPathData(String svg) {
  if (svg == '') {
    return Path();
  }

  final SvgPathStringSource parser = SvgPathStringSource(svg);
  final FlutterPathProxy path = FlutterPathProxy();
  final SvgPathNormalizer normalizer = SvgPathNormalizer();
  for (PathSegmentData seg in parser.parseSegments()) {
    normalizer.emitSegment(seg, path);
  }
  return path.path;
}

/// A [PathProxy] that takes the output of the path parsing library
/// and maps it to a dart:ui [Path].
class FlutterPathProxy extends PathProxy {
  FlutterPathProxy({Path? p}) : path = p ?? Path();

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

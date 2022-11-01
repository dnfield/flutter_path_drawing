import 'dart:ui';

import 'package:path_drawing/path_drawing.dart';

extension PathDrawingExtension on Path {
  Path trim(
    double percentage, {
    bool firstOnly = true,
    PathTrimOrigin origin = PathTrimOrigin.begin,
  }) {
    return trimPath(this, percentage, firstOnly: firstOnly, origin: origin);
  }

  Path dash({
    required CircularIntervalList<double> dashArray,
    DashOffset? dashOffset,
  }) {
    return dashPath(this, dashArray: dashArray, dashOffset: dashOffset);
  }
}

extension ParsePathExtension on String {
  Path get path => parseSvgPathData(this);
}

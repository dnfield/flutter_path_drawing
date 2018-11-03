import 'dart:ui';

/// The point on the path to trim from.
enum PathTrimOrigin {
  /// Specifies that trimming should start from the first point in a segment.
  begin,

  /// Specifies that trimming should start from the last point in a segment.
  end
}

/// Trims `percentage` of the `source` [Path] away and returns a new path.
///
/// The `percentage` parameter will be clamped between 0..1 and must not be null.
///
/// Use the `firstOnly` parameter to specify whether this should apply only
/// to the first segment of the path (and thus return only the first trimmed
/// segment) or all segments of the path.  Multi-segment paths (i.e. paths with a
/// move verb) will all be trimmed if this is false; otherwise, a trimmed version
/// of only the first path segment will be returned. It must not be null.
///
/// The `origin` parameter allows the user to control which end of the path will be
/// trimmed.  It must not be null.
///
/// If `source` is null, null will be returned.  If `source` is empty, an empty
/// path will be returned.
Path trimPath(
  Path source,
  double percentage, {
  bool firstOnly = true,
  PathTrimOrigin origin = PathTrimOrigin.begin,
}) {
  assert(percentage != null);
  assert(firstOnly != null);
  assert(origin != null);
  if (source == null) {
    return null;
  }
  percentage = percentage.clamp(0.0, 1.0);
  if (percentage == 1.0) {
    return Path();
  }
  if (percentage == 0.0) {
    return Path.from(source);
  }
  if (origin == PathTrimOrigin.end) {
    percentage = 1.0 - percentage;
  }

  final Path dest = Path();
  for (final PathMetric metric in source.computeMetrics()) {
    switch (origin) {
      case PathTrimOrigin.end:
        dest.addPath(
          metric.extractPath(0.0, metric.length * percentage),
          Offset.zero,
        );
        break;
      case PathTrimOrigin.begin:
        dest.addPath(
          metric.extractPath(metric.length * percentage, metric.length),
          Offset.zero,
        );
        break;
    }
    if (firstOnly) {
      break;
    }
  }

  return dest;
}

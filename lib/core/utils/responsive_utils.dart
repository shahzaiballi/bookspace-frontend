import 'package:flutter/widgets.dart';

class ResponsiveUtils {
  final BuildContext context;
  ResponsiveUtils(this.context);

  double get width => MediaQuery.sizeOf(context).width;
  double get height => MediaQuery.sizeOf(context).height;
  bool get isLandscape => MediaQuery.orientationOf(context) == Orientation.landscape;

  static const double _designWidth = 390.0;

  double wp(double pixels) {
    return (pixels / _designWidth) * width;
  }

  double sp(double size) {
    final scale = width / _designWidth;
    final clampedScale = scale > 1.2 ? 1.2 : (scale < 0.8 ? 0.8 : scale);
    return size * clampedScale;
  }
}

extension ResponsiveContext on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils(this);
}


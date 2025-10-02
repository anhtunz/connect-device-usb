import 'package:flutter/cupertino.dart';
import '../extension/context_extension.dart';

class ResponsiveText {
  static double getSize(BuildContext context, double size) {
    double screenWidth = context.width;
    double scaleFactor = screenWidth / 375;
    return (size * scaleFactor).clamp(size * 0.8, size * 1.4);
  }
}

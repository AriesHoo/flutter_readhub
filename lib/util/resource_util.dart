import 'package:flutter/material.dart';

class IconFonts {
  IconFonts._();

  static const String fontFamily = 'iconfont';

  static const IconData ic_link = IconData(0xe612, fontFamily: fontFamily);
  static const IconData ic_glass = IconData(0xe89a, fontFamily: fontFamily);
}

///装饰器工具类
class Decorations {
  ///添加边缘线
  static BoxBorder lineBoxBorder(
    BuildContext context, {
    double? width,
    Color? color,
    bool left = false,
    bool top = false,
    bool right = false,
    bool bottom = false,
  }) {
    BorderSide side = BorderSide(
      width: 0.4,
      color: Theme.of(context).hintColor.withOpacity(0.2),
      style: BorderStyle.solid,
    );
    return Border(
      left: left ? side : BorderSide.none,
      top: top ? side : BorderSide.none,
      right: right ? side : BorderSide.none,
      bottom: bottom ? side : BorderSide.none,
    );
  }

  ///添加边缘线
  static ShapeBorder lineShapeBorder(
    BuildContext context, {
    Color? color,
    double? lineWidth,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
  }) {
    return BeveledRectangleBorder(
      borderRadius: borderRadius,
      side: BorderSide(
        width: lineWidth ?? 0.2,
        color: color ?? Theme.of(context).hintColor.withOpacity(0.075),
        style: BorderStyle.solid,
      ),
    );
  }
}

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:shimmer/shimmer.dart';

///占位方块控件
class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final bool isCircle;
  final BorderRadiusGeometry borderRadius;

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  SkeletonBox({
    @required this.width,
    @required this.height,
    this.isCircle: false,
    this.borderRadius,
    this.margin: const EdgeInsets.all(0),
    this.padding: const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    Divider.createBorderSide(context, width: 0.7);
    LogUtil.e('SkeletonBox:${ThemeViewModel.darkMode}');
    return Container(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      decoration: SkeletonDecoration(
        isCircle: isCircle,
        isDark: ThemeViewModel.darkMode,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// 骨架屏元素 ->形状及颜色及圆角
class SkeletonDecoration extends BoxDecoration {
  SkeletonDecoration({
    isCircle: false,
    isDark: false,

    ///圆角
    BorderRadiusGeometry borderRadius,
  }) : super(
          color: !isDark ? Colors.grey[350] : Colors.grey[700],
          borderRadius: borderRadius ?? BorderRadius.circular(0),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        );
}

/// 骨架屏ListView
class SkeletonList extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final bool horizontal;

  ///模拟数量
  final int length;

  ///Item适配器
  final IndexedWidgetBuilder builder;

  ///基础颜色
  final Color baseColor;

  ///高亮颜色
  final Color highlightColor;

  SkeletonList({
    @required this.builder,
    this.length: 10,
    this.horizontal: false,
    this.baseColor,
    this.highlightColor,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
//    MaterialColor color =
//        theme.accentColor is MaterialColor ? theme.accentColor : Colors.grey;
    MaterialColor color = Colors.grey;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
        period: Duration(milliseconds: 1000),
        baseColor: baseColor ?? (ThemeViewModel.darkMode ? color[700] : color[350]),
        highlightColor:
            highlightColor ?? (ThemeViewModel.darkMode ? color[500] : color[200]),
        child: Padding(
            padding: padding,
            child: horizontal
                ? Row(
                    children: List.generate(
                        length, (index) => builder(context, index)),
                  )
                : Column(
                    children: List.generate(
                        length, (index) => builder(context, index)),
                  )),
      ),
    );
  }
}

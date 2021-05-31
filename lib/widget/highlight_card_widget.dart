import 'package:flutter/material.dart';
import 'package:flutter_readhub/basis/basis_highlight_view_model.dart';
import 'package:flutter_readhub/basis/basis_provider_widget.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/resource_util.dart';

///长按/悬浮效果Card-包括景深度、margin变化
class HighlightCardWidget extends StatelessWidget {
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  final double? margin;
  final double? marginHighlight;
  final double? elevation;
  final double? elevationHighlight;
  final Color? color;
  final Color? shadowColor;
  final Color? shadowHighlightColor;
  final BorderRadiusGeometry? borderRadius;
  final Widget Function(BuildContext context, BasisHighlightViewModel value)
      builder;

  const HighlightCardWidget({
    Key? key,
    this.onTap,
    this.onLongPress,
    this.margin,
    this.marginHighlight,
    this.elevation,
    this.elevationHighlight,
    this.color,
    this.shadowColor,
    this.shadowHighlightColor,
    this.borderRadius,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasisProviderWidget<BasisHighlightViewModel>(
      model: BasisHighlightViewModel(),
      builder: (context, highlightMode, widget) => InkWell(
        onHighlightChanged: highlightMode.onHighlightChanged,
        onHover: highlightMode.onHighlightChanged,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: onTap,
        onLongPress: () {
          onLongPress?.call();
        },
        child: Card(
          margin: PlatformUtil.isMobile
              ? null
              : EdgeInsets.all(
                  highlightMode.highlight
                      ? marginHighlight ?? 12
                      : margin ?? 12,
                ),
          elevation: highlightMode.highlight ? 0 : 0,
          color: color ?? Theme.of(context).cardColor,
          borderOnForeground: false,
          shadowColor: highlightMode.highlight
              ? shadowHighlightColor ?? Colors.deepPurpleAccent
              : shadowColor ?? Theme.of(context).accentColor,
          child: builder(context, highlightMode),
          clipBehavior: Clip.antiAlias,
          shape: PlatformUtil.isMobile
              ? null
              : Decorations.lineShapeBorder(
                  context,
                  lineWidth: highlightMode.highlight ? 1.5 : 0.5,
                  borderRadius: BorderRadius.circular(12),
                  color: highlightMode.highlight
                      ? Theme.of(context).accentColor
                      : Theme.of(context).hintColor.withOpacity(0.1),
                ),
          // shape: RoundedRectangleBorder(
          //   borderRadius: borderRadius ??
          //       BorderRadius.circular(
          //         12,
          //       ),
          //   side: BorderSide(
          //     width: 1.5,
          //     color: highlightMode.highlight
          //         ? Theme.of(context).accentColor
          //         : Theme.of(context).hintColor.withOpacity(0.1),
          //     // color: Colors.blue,
          //     style:
          //         PlatformUtil.isMobile ? BorderStyle.none : BorderStyle.solid,
          //   ),
          // ),
        ),
      ),
    );
  }
}

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
  final bool showBorder;
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
    this.showBorder = false,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasisProviderWidget<BasisHighlightViewModel>(
      model: BasisHighlightViewModel(),
      builder: (context, highlightMode, widget) => Card(
        margin: PlatformUtil.isMobile && !showBorder
            ? null
            : EdgeInsets.all(
                highlightMode.highlight ? marginHighlight ?? 10 : margin ?? 10,
              ),
        elevation: highlightMode.highlight ? 0 : 0,
        color: Colors.transparent,
        borderOnForeground: false,
        shadowColor: highlightMode.highlight
            ? shadowHighlightColor ?? Colors.deepPurpleAccent
            : shadowColor ?? Theme.of(context).primaryColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: PlatformUtil.isMobile && !showBorder
            ? null
            : Decorations.lineShapeBorder(
                context,
                lineWidth: highlightMode.highlight ? 1.6 : 0.8,
                borderRadius: BorderRadius.circular(12),
                color: highlightMode.highlight
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).hintColor.withOpacity(0.1),
              ),
        child: InkWell(
          canRequestFocus: true,
          autofocus: true,
          onHighlightChanged: highlightMode.onHighlightChanged,
          onHover: highlightMode.onHighlightChanged,
          // highlightColor: PlatformUtil.isMobile ? null : Colors.transparent,
          // splashColor: PlatformUtil.isMobile ? null : Colors.transparent,
          // hoverColor: PlatformUtil.isMobile ? null : Colors.transparent,
          onTap: () {
            onTap?.call();
            highlightMode.onHighlightChanged.call(!PlatformUtil.isMobile);
          },
          onLongPress: () {
            onLongPress?.call();
            highlightMode.onHighlightChanged.call(!PlatformUtil.isMobile);
          },
          child: builder(context, highlightMode),
        ),
      ),
    );
  }
}

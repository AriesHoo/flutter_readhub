import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_readhub/util/platform_util.dart';

///基础Dialog
class BasisDialog extends Dialog {
  final Widget? kid;
  final double maxWidth;
  final double minWidth;
  final AlignmentGeometry alignment;

  BasisDialog({
    Key? key,
    this.kid,
    this.maxWidth: 360.0,
    this.minWidth: 280.0,
    this.alignment: Alignment.center,
  });

  @override
  EdgeInsets? get insetPadding => EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
        top: PlatformUtil.isMobile
            ? MediaQueryData.fromWindow(window).padding.top
            : 20,
      );

  @override
  Widget? get child => SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: kid,
      );

  @override
  Clip get clipBehavior => Clip.antiAliasWithSaveLayer;

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    final EdgeInsets effectivePadding =
        MediaQuery.of(context).viewInsets + (insetPadding ?? EdgeInsets.zero);
    final Widget childWidget = AnimatedPadding(
      padding: effectivePadding,
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Align(
          alignment: alignment,
          child: Material(
            color: backgroundColor ??
                dialogTheme.backgroundColor ??
                Theme.of(context).dialogBackgroundColor,
            elevation: elevation ?? dialogTheme.elevation ?? 0,
            shape: shape ?? dialogTheme.shape,
            type: MaterialType.card,
            clipBehavior: clipBehavior,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: minWidth,
                maxWidth: maxWidth,
              ),

              /// 特殊处理点击child部分不响应关闭事件
              ///即：点击半透明部分才关闭Dialog
              child: GestureDetector(
                onTap: () => LogUtil.v('点击child'),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );

    ///ModalBottomSheet 特殊处理点击非child部分关闭
    return Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () => Navigator.of(context).pop(),
        child: childWidget,
      ),
    );
  }
}

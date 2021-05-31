import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///基础Dialog
class BasisDialog extends Dialog {
  final Widget? kid;

  BasisDialog({this.kid});

  @override
  Duration get insetAnimationDuration => Duration(milliseconds: 2000);

  @override
  EdgeInsets? get insetPadding => EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      );

  @override
  Widget? get child => SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 360,
          ),
          child: kid,
        ),
      );

  @override
  Clip get clipBehavior => Clip.antiAliasWithSaveLayer;

  @override
  Widget build(BuildContext context) {
    // if (isDisplayDesktop) {
    //   Navigator.of(context).pop();
    // }
    return super.build(context);
  }
}

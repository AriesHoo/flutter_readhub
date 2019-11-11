import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_readhub/view_model/theme_model.dart';

class ToastUtil {
  static BuildContext get context => null;

  static show(
    String text, {
    ToastPosition position,
    Duration duration,
  }) {
    position ??= ToastPosition.bottom;
    duration ??= Duration(
      milliseconds: 2000,
    );

    showToast(
      text,
      textStyle: TextStyle(
        fontSize: 14,
        fontFamily: ThemeModel.fontFamily(),
      ),
      backgroundColor: Color(0xA0000000),
      dismissOtherToast: true,
      radius: 6,
      textPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      position: position,
      duration: duration,
    );
  }
}

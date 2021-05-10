import 'package:flutter/material.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:oktoast/oktoast.dart';

///Toast工具类
class ToastUtil {
  static BuildContext? get context => null;

  static show(
    String text, {
    ToastPosition? position,
    Duration? duration,
  }) {
    position ??= ToastPosition.bottom;
    duration ??= Duration(
      milliseconds: text.length > 5 ? 3500 : 2000,
    );

    Color textColor = ThemeViewModel.darkMode ? Colors.black : Colors.white;
    Color bgColor = !ThemeViewModel.darkMode ? Colors.black : Colors.white;
    showToast(
      text,
      textStyle: TextStyle(
        fontSize: 14,
        fontFamily: ThemeViewModel.fontFamily(),
        color: textColor,
      ),
      // backgroundColor:
      //     Color(ThemeViewModel.platformDarkMode ? 0xA0FFFFFF : 0xA0000000),
      backgroundColor: bgColor.withAlpha(200),
      dismissOtherToast: true,
      radius: 6,
      textPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      position: position,
      duration: duration,
    );
  }
}

import 'package:bot_toast/bot_toast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';

///Toast工具类---初步使用BotToast
class ToastUtil {
  ///展示提示
  static CancelFunc show(
    String text, {
    AlignmentGeometry? align,
    Duration? duration,
    Color? backgroundColor,
    Color? textColor,
    int? milliseconds,

    ///是否通知形式
    bool notification: true,
    BorderRadiusGeometry borderRadius:
        const BorderRadius.all(Radius.circular(6)),
  }) {
    align ??= Alignment.center;
    duration ??= Duration(
      milliseconds: milliseconds != null
          ? milliseconds
          : !TextUtil.isEmpty(text) && text.length > 10
              ? 5000
              : 2500,
    );
    LogUtil.v(
        'text:$text;textScale:$textScale'
        ';textScaleFactor:${MediaQuery.of((navigatorKey.currentContext)!).textScaleFactor}',
        tag: 'showToast');
    bool isDark = ThemeViewModel.darkMode;
    return notification
        ? BotToast.showSimpleNotification(
            title: '$text',
            titleStyle: Theme.of(navigatorKey.currentContext!)
                .textTheme
                .subtitle1!
                .copyWith(
                  fontSize: 16 * textScale,
                  color: textColor ?? (isDark ? Colors.black : Colors.white),
                ),
            hideCloseButton: true,
            animationDuration: Duration(milliseconds: 800),
            // backgroundColor: backgroundColor ?? Color(0xA0000000),
            backgroundColor: backgroundColor ??
                (isDark ? Colors.white : Colors.black).withOpacity(0.75),
            borderRadius: 6,
            duration: duration,

            ///只显示一个
            onlyOne: true,
            crossPage: true,
          )
        : BotToast.showText(
            text: '$text',
            textStyle: TextStyle(
              fontSize: 16 * textScale,
              color: Colors.white,
            ),
            align: align,
            backgroundColor: Colors.transparent,
            contentColor: backgroundColor ?? Color(0xA0000000),
            borderRadius: borderRadius,
            contentPadding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 10,
            ),
            duration: duration,

            ///只显示一个
            onlyOne: true,
            crossPage: true,
          );
  }

  ///成功
  static CancelFunc showSuccess(
    String text, {
    AlignmentGeometry? align,
    Duration? duration,
    Color? textColor,

    ///是否通知形式
    bool notification: true,
    BorderRadiusGeometry borderRadius:
        const BorderRadius.all(Radius.circular(6)),
  }) {
    return show(
      text,
      align: align,
      duration: duration,
      backgroundColor: Colors.green.withOpacity(0.7),
      textColor: textColor,
      notification: notification,
      borderRadius: borderRadius,
    );
  }

  ///错误
  static CancelFunc showError(
    String text, {
    AlignmentGeometry? align,
    Duration? duration,
    Color? textColor,

    ///是否通知形式
    bool notification: true,
    BorderRadiusGeometry borderRadius:
        const BorderRadius.all(Radius.circular(6)),
  }) {
    return show(
      text,
      align: align,
      duration: duration,
      backgroundColor: Colors.red.withOpacity(0.7),
      textColor: textColor,
      notification: notification,
      borderRadius: borderRadius,
    );
  }

  ///提醒
  static CancelFunc showWarning(
    String text, {
    AlignmentGeometry? align,
    Duration? duration,
    Color? textColor,

    ///是否通知形式
    bool notification: true,
    BorderRadiusGeometry borderRadius:
        const BorderRadius.all(Radius.circular(6)),
  }) {
    return show(
      text,
      align: align,
      duration: duration,
      backgroundColor: Colors.amber.withOpacity(0.7),
      textColor: textColor,
      notification: true,
      borderRadius: borderRadius,
    );
  }
}

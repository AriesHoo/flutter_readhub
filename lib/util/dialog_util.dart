import 'dart:io';
import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///dialog提示
class DialogUtil {

  /// 弹出对话框
  static Future<int> showAlertDialog(
    BuildContext context, {
    String title,
    Widget titleWidget,
    String content,
    Widget contentWidget,
    String cancel,
    Widget cancelWidget,
    String ensure,
    Widget ensureWidget,
    bool barrierDismissible = true,
  }) async {
    Widget widgetTitle =
        titleWidget != null ? titleWidget : title != null ? Text(title) : null;
    Widget widgetContent = contentWidget != null
        ? contentWidget
        : content != null ? Text(content,textAlign: TextAlign.left,) : null;
    Widget widgetCancel = cancelWidget != null
        ? cancelWidget
        : !TextUtil.isEmpty(cancel)
            ? Platform.isIOS
                ? CupertinoButton(
                    child: Text(
                      cancel,
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 16,
                          ),
                    ),
                    onPressed: () {
                      ///关闭对话框并返回0
                      Navigator.of(context).pop(0);
                    },
                  )
                : FlatButton(
                    child: Text(
                      cancel,
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 16,
                          ),
                    ),
                    onPressed: () {
                      ///关闭对话框并返回
                      Navigator.of(context).pop(0);
                    },
                  )
            : null;
    Widget widgetEnsure = ensureWidget != null
        ? ensureWidget
        : !TextUtil.isEmpty(ensure)
            ? Platform.isIOS
                ? CupertinoButton(
                    child: Text(ensure),
                    onPressed: () {
                      ///关闭对话框并返回
                      Navigator.of(context).pop(1);
                    },
                  )
                : FlatButton(
                    child: Text(ensure),
                    onPressed: () {
                      ///关闭对话框并返回
                      Navigator.of(context).pop(1);
                    },
                  )
            : null;
    return await showDialog<int>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: widgetTitle,
                content: widgetContent,
                actions: [
                  widgetCancel,
                  widgetEnsure,
                ],
              )
            : AlertDialog(
                contentPadding: EdgeInsets.fromLTRB(
                    24.0,
                    titleWidget == null && title == null ? 24.0 : 10.0,
                    24.0,
                    10.0),
                title: widgetTitle,
                content: widgetContent,
                elevation: 0,
                actions: <Widget>[
                  widgetCancel,
                  widgetEnsure,
                ],
              );
      },
    );
  }
}

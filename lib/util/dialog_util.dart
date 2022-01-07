import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/util/platform_util.dart';

///dialog提示
class DialogUtil {
  /// 弹出对话框
  static Future<int?> showAlertDialog(
    BuildContext context, {
    String? title,
    Widget? titleWidget,
    String? content,
    Widget? contentWidget,
    String? cancel,
    Widget? cancelWidget,
    String? ensure,
    Widget? ensureWidget,
    bool barrierDismissible = true,
  }) async {
    Widget? widgetTitle = titleWidget != null
        ? titleWidget
        : title != null
            ? Text(title)
            : null;
    Widget? widgetContent = contentWidget != null
        ? contentWidget
        : content != null
            ? Text(
                content,
                textAlign: TextAlign.left,
              )
            : null;
    Widget? widgetCancel = cancelWidget != null
        ? cancelWidget
        : !TextUtil.isEmpty(cancel)
            ? PlatformUtil.isIOS
                ? CupertinoButton(
                    child: Text(
                      cancel!,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    onPressed: () {
                      ///关闭对话框并返回0
                      Navigator.of(context).pop(0);
                    },
                  )
                : TextButton(
                    child: Text(
                      cancel!,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: MaterialStateProperty.all(
                        EdgeInsets.all(16),
                      ),
                    ),
                    onPressed: () {
                      ///关闭对话框并返回
                      Navigator.of(context).pop(0);
                    },
                  )
            : null;
    Widget? widgetEnsure = ensureWidget != null
        ? ensureWidget
        : !TextUtil.isEmpty(ensure)
            ? PlatformUtil.isIOS
                ? CupertinoButton(
                    child: Text(
                      ensure!,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                          ),
                    ),
                    onPressed: () {
                      ///关闭对话框并返回
                      Navigator.of(context).pop(1);
                    },
                  )
                : TextButton(
                    child: Text(
                      ensure!,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                          ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: MaterialStateProperty.all(
                        EdgeInsets.all(16),
                      ),
                    ),
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
        return PlatformUtil.isIOS
            ? CupertinoAlertDialog(
                title: widgetTitle,
                content: widgetContent,
                actions: [
                  widgetCancel!,
                  widgetEnsure!,
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
                actions: [
                  widgetCancel!,
                  widgetEnsure!,
                ],
              );
      },
    );
  }

  /// 底部BottomSheetDialog-少量
  static Future showModalBottomSheetDialog(
    BuildContext context, {
    Widget? child,
    IndexedWidgetBuilder? itemBuilder,
    int count: 1,
    Color? barrierColor,
    Color? backgroundColor,
    RouteSettings? settings,
    ShapeBorder? shape,
    Clip? clipBehavior,
    bool childOutside: false,
  }) async {
    // if (isDisplayDesktop) {
    //   return await showDialog(
    //     context: context,
    //     builder: (context) => BasisDialog(
    //       kid: Container(
    //         child: child,
    //       ),
    //     ),
    //   );
    // }
    return await showModalBottomSheet(
        context: context,
        routeSettings: settings,
        shape: shape,
        isScrollControlled: true,
        useRootNavigator: false,
        clipBehavior: clipBehavior,

        ///背景色默认设置
        backgroundColor: backgroundColor ?? Theme.of(context).cardColor,

        ///背景蒙层颜色
        barrierColor: barrierColor ?? Colors.black54,

        ///itemBuilder
        builder: (BuildContext context) {
          return child != null && childOutside
              ? child
              : ListView.builder(
                  itemCount: count,
                  shrinkWrap: true,

                  ///通过控制滚动用于手指跟随
                  physics: BouncingScrollPhysics(),
                  itemBuilder:
                      itemBuilder ?? (context, index) => child ?? SizedBox(),
                );
        });
  }
}

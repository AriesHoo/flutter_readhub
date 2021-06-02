import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/dialog/basis_dialog.dart';
import 'package:flutter_readhub/helper/provider_helper.dart';
import 'package:flutter_readhub/util/dialog_util.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';

///弹出颜色选择框
Future<void> showThemeDialog(BuildContext context) async {
  DialogUtil.showModalBottomSheetDialog(
    context,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(12),
      ),
    ),
    barrierColor: Colors.black54.withOpacity(0.2),
    // backgroundColor: Colors.transparent,
    child: ThemeDialog(),
  );
}

///主题选择Dialog
class ThemeDialog extends BasisDialog {
  @override
  bool get modalBottomSheet => true;

  @override
  double get minWidth => double.infinity;

  @override
  double get maxWidth => double.infinity;

  @override
  EdgeInsets? get insetPadding => EdgeInsets.zero;

  @override
  AlignmentGeometry get alignment => Alignment.bottomLeft;

  @override
  ShapeBorder? get shape => RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      );

  @override
  Widget? get kid => Builder(builder: (context) {
        ///单个Button最终宽度
        double finalWidth = 200;

        ///单个Button最小宽度
        double minWidth = 200;

        ///Button间水平间距
        double spacing = 24;

        ///Button可用屏幕宽度-屏幕宽度减去 整个区域水平边界
        double screenWidth = MediaQuery.of(context).size.width - 24;

        int count = screenWidth ~/ (minWidth + spacing);

        if (count > 4) {
          count = 4;
        }

        ///只够显示一个
        if (count <= 1) {
          finalWidth = double.infinity;
        } else {
          finalWidth = (screenWidth - count * spacing) / count;
        }
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: count <= 1 ? 24 : 0,
            top: 24,
            bottom: 24,
          ),

          ///所有颜色按钮垂直排列
          child: Wrap(
            runSpacing: count <= 1 ? 12 : 16,
            spacing: spacing,
            children: ThemeViewModel.themeValueList.map((color) {
              int index = ThemeViewModel.themeValueList.indexOf(color);
              return Material(
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.hardEdge,
                color: ThemeViewModel.getThemeColor(i: index),
                child: InkWell(
                  onTap: () {
                    var model = ProviderHelper.of<ThemeViewModel>(context);
                    model.switchTheme(themeIndex: index);
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.black.withAlpha(50),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Container(
                        width: finalWidth,
                        height: count > 1 ? 52 : 46,
                        child: Center(
                          child: Text(
                            ThemeViewModel.themeName(i: index),
                            textScaleFactor: ThemeViewModel.textScaleFactor,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 120),
                        child: Icon(
                          Icons.check,
                          size: 22,
                          color: index ==
                                  ProviderHelper.of<ThemeViewModel>(context)
                                      .themeIndex
                              ? Colors.white
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      });
}

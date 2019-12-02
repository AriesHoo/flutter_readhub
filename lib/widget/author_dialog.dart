import 'package:flutter/material.dart';
import 'package:flutter_readhub/generated/i18n.dart';
import 'package:flutter_readhub/view_model/theme_model.dart';
import 'package:flutter_readhub/widget/home_drawer_widget.dart';
import 'package:provider/provider.dart';

///弹出分享提示框
Future<void> showAuthorDialog(BuildContext context) async {
  await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AuthorDialog();
    },
  );
}

///弹出颜色选择框
Future<void> showThemeDialog(BuildContext context) async {
  await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return ThemeDialog();
    },
  );
}

///用户信息Dialog
class AuthorDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    Color iconColor = Theme.of(context).accentColor;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///圆角
          ClipRRect(
            borderRadius: BorderRadius.circular(6),

            ///整体背景
            child: Container(
              color: Theme.of(context).cardColor,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ///顶部信息
                      TopRoundWidget(),

                      ///选择颜色主题
                      Material(
                        color: Theme.of(context).cardColor,
                        elevation: 12,
                        child: ListTile(
                          title: Text(S.of(context).choiceTheme),
                          onTap: () => showThemeDialog(context),
                          leading: Icon(
                            Icons.color_lens,
                            color: iconColor,
                          ),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

///颜色选择dialog
class ThemeDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                color: Theme.of(context).cardColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: <Widget>[
                    ...ThemeModel.themeValueList.map((color) {
                      int index = ThemeModel.themeValueList.indexOf(color);
                      return Material(
                        borderRadius: BorderRadius.circular(4),
                        color: color,
                        child: InkWell(
                          onTap: () {
                            var model = Provider.of<ThemeModel>(context);
                            model.switchTheme(themeIndex: index);
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.white.withAlpha(50),
                          child: Container(
                            width: double.infinity,
                            height: 44,
                            child: Center(
                              child: Text(
                                ThemeModel.themeName(context, i: index),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

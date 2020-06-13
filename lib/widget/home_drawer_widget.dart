import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/generated/l10n.dart';
import 'package:flutter_readhub/view_model/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

///设置功能抽屉栏
class HomeDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width * 0.8,
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                TopRoundWidget(),
                Material(
                  borderOnForeground: true,
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    selected: true,
                    contentPadding:
                        EdgeInsets.only(left: 12, right: 0, top: 0, bottom: 0),
                    title: Text(
                      S.of(context).settingHideFloatingButton,
                      textScaleFactor: ThemeModel.textScaleFactor,
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    trailing: Checkbox(
                      activeColor: Theme.of(context).accentColor,
                      value: ThemeModel.hideFloatingButton,
                      onChanged: (checked) {
                        Provider.of<ThemeModel>(context)
                            .switchHideFloatingButton(checked);
                      },
                    ),
                    onTap: () {
                      Provider.of<ThemeModel>(context).switchHideFloatingButton(
                          !ThemeModel.hideFloatingButton);
                    },
                  ),
                ),
                ChoiceThemeWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///顶部个人信息介绍
class TopRoundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        ClipPath(
          clipper: BottomClipper(),
          child: Container(
            height: 80,
            color: Theme.of(context).accentColor.withOpacity(0.8),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 32,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                'assets/images/user.jpg',
                width: 56,
                height: 56,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            GestureDetector(
              onTap: () async => launch(
                'https://github.com/AriesHoo',
              ),
              child: Text(
                "AriesHoo",
                textScaleFactor: ThemeModel.textScaleFactor,
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ],
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    LogUtil.e('BottomClipper:${size.height}');
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height / 2);

    var p1 = Offset(size.width / 2, size.height);
    var p2 = Offset(size.width, size.height / 2);
    path.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}

///颜色主题选择
class ChoiceThemeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        S.of(context).choiceTheme,
        textScaleFactor: ThemeModel.textScaleFactor,
        style: Theme.of(context).textTheme.title.copyWith(
              fontSize: 14,
            ),
      ),
      initiallyExpanded: false,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Wrap(
            runSpacing: 5,
            spacing: 5,
            children: <Widget>[
              ...ThemeModel.themeValueList.map((color) {
                int index = ThemeModel.themeValueList.indexOf(color);
                return Material(
                  borderRadius: BorderRadius.circular(2),
                  color: color,
                  child: InkWell(
                    onTap: () {
                      var model = Provider.of<ThemeModel>(context);
                      model.switchTheme(themeIndex: index);
                    },
                    splashColor: Colors.white.withAlpha(50),
                    child: Container(
                      width: 36,
                      height: 36,
                      child: Center(
                        child: Text(
                          ThemeModel.themeName(context, i: index),
                          textScaleFactor: ThemeModel.textScaleFactor,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}

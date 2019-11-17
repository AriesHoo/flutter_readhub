import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/generated/i18n.dart';
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
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        ClipPath(
          clipper: BottomClipper(),
          child: Container(
            height: 200,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Container(
          padding: EdgeInsets.all(0),
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: CachedNetworkImage(
                  width: 64,
                  height: 64,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  imageUrl:
                      'https://avatars0.githubusercontent.com/u/19605922?s=460&v=4',
                  placeholder: (context, url) {
                    return Center(
                      child: Container(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  },
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
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50);

    var p1 = Offset(size.width / 2, size.height);
    var p2 = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    path.lineTo(size.width, size.height - 50);
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
                      model.switchTheme(color: color);
                    },
                    splashColor: Colors.white.withAlpha(50),
                    child: Container(
                      width: 36,
                      height: 36,
                      child: Center(
                        child: Text(
                          ThemeModel.themeName(context, i: index),
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

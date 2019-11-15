import 'package:flutter/material.dart';
import 'package:flutter_readhub/generated/i18n.dart';
import 'package:flutter_readhub/view_model/theme_model.dart';
import 'package:provider/provider.dart';

///设置功能抽屉栏
class HomeDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      ///留出状态栏+appBar高度56+24
      margin: EdgeInsets.only(
        top: 0,
      ),
      height: double.infinity,
      width: 240,
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Material(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 16, right: 4),
                    title: Text(S.of(context).settingHideFloatingButton),
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

///颜色主题选择
class ChoiceThemeWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(S.of(context).choiceTheme),
      initiallyExpanded: false,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: <Widget>[
              ...ThemeModel.themeValueList.map((color) {
                int index = ThemeModel.themeValueList.indexOf(color);
                return Material(
                  borderRadius: BorderRadius.circular(2),
                  color: color,
                  child: InkWell(
                    onTap: () {
                      var model = Provider.of<ThemeModel>(context);
                      var brightness = Theme.of(context).brightness;
                      model.switchTheme(color: color);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Text(
                          ThemeModel.themeName(context, i: index),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
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
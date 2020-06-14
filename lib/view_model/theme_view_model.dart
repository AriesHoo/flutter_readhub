import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_readhub/generated/l10n.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/util/platform_util.dart';

///主题管理
class ThemeViewModel with ChangeNotifier {
  static const SP_KEY_THEME_COLOR_INDEX = 'SP_KEY_THEME_COLOR_INDEX';
  static const SP_KEY_THEME_DARK_MODE = 'SP_KEY_THEME_DARK_MODE';
  static const SP_KEY_FONT_INDEX = 'SP_KEY_FONT_INDEX';
  static const SP_KEY_FONT_TEXT_SIZE = 'SP_KEY_FONT_TEXT_SIZE';

  ///颜色主题列表
  static const List<MaterialColor> themeValueList = <MaterialColor>[
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.purple,
    Colors.pink
  ];

  ///字体列表
  static const fontValueList = ['system', 'StarCandy'];

  /// 当前主题颜色
  static MaterialColor _themeColor = Colors.blue;
  static Color _accentColor = _themeColor;

  /// 用户选择的明暗模式
  static bool _userDarkMode = false;

  static bool get platformDarkMode =>
      navigatorKey.currentContext != null &&
      MediaQuery.of(navigatorKey.currentContext).platformBrightness ==
          Brightness.dark;

  static bool get userDarkMode => _userDarkMode;

  static bool get darkMode => userDarkMode || platformDarkMode;

  ///是否隐藏悬浮按钮-用于回到顶部
  static bool _hideFloatingButton = false;

  static bool get hideFloatingButton => _hideFloatingButton;

  /// 当前字体索引
  static int _fontIndex = 0;

  int get fontIndex => _fontIndex;

  /// 当前主题索引
  static int _themeIndex = 5;

  int get themeIndex => _themeIndex;

  static MaterialColor get themeColor => _themeColor;

  ///白色主题状态栏及导航栏颜色
  static Color colorWhiteTheme = Color(0x66000000);

//  Color colorWhiteTheme = Colors.transparent;

  static Color colorBlackTheme = Colors.grey[900];

  static Color get accentColor => _accentColor;

  static Color get themeAccentColor =>
      _userDarkMode ? colorBlackTheme : accentColor;

  static double get textScaleFactor => 1;

  /// 当前主size textScaleFactor
  static double _fontTextSize = 1.0;

  static double get fontTextSize => _fontTextSize;

  ThemeViewModel() {
    /// 用户选择的明暗模式
    _userDarkMode = SpUtil.getBool(SP_KEY_THEME_DARK_MODE, defValue: false);

    /// 获取主题色
    _themeIndex =
        SpUtil.getInt(SP_KEY_THEME_COLOR_INDEX, defValue: _themeIndex);
    LogUtil.e("_themeIndex:$_themeIndex");
    _themeColor = themeValueList[_themeIndex];
    _accentColor = _themeColor;

    /// 获取本地字体
    _fontIndex = SpUtil.getInt(SP_KEY_FONT_INDEX);

    /// 获取本地文字缩放
    _fontTextSize = SpUtil.getDouble(SP_KEY_FONT_TEXT_SIZE, defValue: 1.0);

    ///如果缓存为黑色字体则进行
//    if (_userDarkMode) {
    switchTheme(userDarkMode: _userDarkMode);
//    }
  }

  /// 切换是否
  switchHideFloatingButton(bool hide) {
    _hideFloatingButton = hide;
    switchTheme();
  }

  /// 切换字体
  switchFont(int index) {
    _fontIndex = index;
    switchTheme();
    SpUtil.putInt(SP_KEY_FONT_INDEX, _fontIndex);
  }

  /// 切换文字字号缩放
  switchFontTextSize(double textSize) {
    _fontTextSize = textSize;
    switchTheme();
    SpUtil.putDouble(SP_KEY_FONT_TEXT_SIZE, _fontTextSize);
  }

  static String fontFamily() {
    return fontValueList[_fontIndex];
  }

  String fontFamilyIndex({int index}) {
    return fontValueList[index ?? _fontIndex];
  }

  /// 切换指定色彩
  ///
  /// 没有传[brightness]就不改变brightness,color同理
  void switchTheme(
      {bool userDarkMode, int themeIndex, MaterialColor color}) async {
    if (themeIndex != null && themeIndex != _themeIndex) {
      SpUtil.putInt(SP_KEY_THEME_COLOR_INDEX, themeIndex);
    }
    _userDarkMode = userDarkMode ?? _userDarkMode;
    _themeIndex = themeIndex ?? _themeIndex;
    _themeColor = color ?? getThemeColor();
    LogUtil.e("_userDarkMode" +
        _userDarkMode.toString() +
        "_themeIndex:" +
        _themeIndex.toString() +
        "_themeColor:" +
        _themeColor.toString());
//    await setSystemBarTheme();

    ///存入缓存
    SpUtil.putBool(SP_KEY_THEME_DARK_MODE, _userDarkMode);
    notifyListeners();
  }

  ///设置系统Bar主题
  static Future setSystemBarTheme() async {
    bool statusEnable =
        Platform.isAndroid ? await PlatformUtil.isStatusColorChange() : true;
    bool navigationEnable = Platform.isAndroid
        ? await PlatformUtil.isNavigationColorChange()
        : true;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: darkMode || statusEnable ? Colors.transparent : null,
      statusBarIconBrightness: darkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: darkMode
          ? colorBlackTheme
          : navigationEnable ? Colors.transparent : null,
      systemNavigationBarIconBrightness:
          darkMode ? Brightness.dark : Brightness.light,
    ));
  }

  /// 根据主题 明暗 和 颜色 生成对应的主题
  /// [dark]系统的Dark Mode
  themeData({bool platformDarkMode: false}) {
    LogUtil.e('themeData_platform:$platformDarkMode');
    var isDark = platformDarkMode || _userDarkMode;
    var themeColor = _themeColor;
    _accentColor = isDark ? themeColor[600] : _themeColor;
    Brightness brightness = isDark ? Brightness.dark : Brightness.light;
    var themeData = ThemeData(
      brightness: brightness,
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      primarySwatch: themeColor,
      accentColor: accentColor,
      primaryColor: accentColor,

      ///类苹果跟随滑动返回-修改后返回箭头及主标题iOS风格
//      platform: TargetPlatform.iOS,
      errorColor: Colors.red,
      toggleableActiveColor: accentColor,

      ///输入框光标
      cursorColor: accentColor,

      ///字体
      fontFamily: fontValueList[_fontIndex],
    );

    themeData = themeData.copyWith(
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: themeColor,
      ),
      appBarTheme: themeData.appBarTheme.copyWith(
        ///设置主题决定状态栏icon颜色
        brightness: isDark ? Brightness.dark : Brightness.light,
        color: isDark ? colorBlackTheme : Colors.white,
        elevation: 0,
        textTheme: TextTheme(
          title: TextStyle(
            color: isDark ? Colors.white : accentColor,
            fontSize: 17,
            fontWeight: FontWeight.w500,

            ///字体
            fontFamily: fontValueList[_fontIndex],
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : accentColor,
        ),
      ),
      iconTheme: themeData.iconTheme.copyWith(
        color: accentColor,
      ),
      splashColor: themeColor.withAlpha(50),
      hintColor: themeData.hintColor.withAlpha(90),
      textTheme: themeData.textTheme.copyWith(
          subhead: themeData.textTheme.subhead.copyWith(
        textBaseline: TextBaseline.alphabetic,
      )),
      textSelectionColor: accentColor.withAlpha(60),
      textSelectionHandleColor: accentColor.withAlpha(60),
      chipTheme: themeData.chipTheme.copyWith(
        pressElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 6),
        labelStyle: themeData.textTheme.caption,
        backgroundColor: themeData.chipTheme.backgroundColor.withOpacity(0.1),
      ),

      ///长按提示文本样式
      tooltipTheme: themeData.tooltipTheme.copyWith(
          textStyle: TextStyle(
              fontSize: 13,
              color:
                  (darkMode ? Colors.black : Colors.white).withOpacity(0.9))),

      ///TabBar样式设置
      tabBarTheme: themeData.tabBarTheme.copyWith(
        ///标签内边距
        labelPadding: EdgeInsets.symmetric(horizontal: 8),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,

          ///字体
          fontFamily: fontValueList[_fontIndex],
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13,

          ///字体
          fontFamily: fontValueList[_fontIndex],
        ),
      ),
      floatingActionButtonTheme: themeData.floatingActionButtonTheme.copyWith(
        backgroundColor: themeAccentColor,
        splashColor: themeColor.withAlpha(50),
      ),
    );
    setSystemBarTheme();
    return themeData;
  }

  /// 根据索引获取字体名称,这里牵涉到国际化
  static String fontName(context, {int i}) {
    int index = i ?? _fontIndex;
    switch (index) {
      case 0:
//        return S.of(context).autoBySystem;
      case 1:
//        return S.of(context).starCandy;
      default:
        return '';
    }
  }

  /// 根据索引获取颜色名称,这里牵涉到国际化
  static String themeName(context, {int i}) {
    int index = i ?? _themeIndex;
    switch (index) {
      case 0:
        return S.of(context).red;
      case 1:
        return S.of(context).orange;
      case 2:
        return S.of(context).yellow;
      case 3:
        return S.of(context).green;
      case 4:
        return S.of(context).cyan;
      case 5:
        return S.of(context).blue;
      case 6:
        return S.of(context).purple;
      case 7:
        return getWeekStr(context) +
            '-${themeName(context, i: DateTime.now().weekday - 1)}';
      default:
        return '';
    }
  }

  static MaterialColor getThemeColor({int i}) {
    int index = i ?? _themeIndex;
    return index == themeValueList.length - 1
        ? themeValueList[DateTime.now().weekday - 1]
        : themeValueList[index];
  }

  static String getWeekStr(BuildContext context) {
    int week = DateTime.now().weekday;
    switch (week) {
      case 1:
        return S.of(context).monday;
      case 2:
        return S.of(context).tuesday;
      case 3:
        return S.of(context).wednesday;
      case 4:
        return S.of(context).thursday;
      case 5:
        return S.of(context).friday;
      case 6:
        return S.of(context).saturday;
      case 7:
        return S.of(context).sunday;
      default:
        return '';
    }
  }
}

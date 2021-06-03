import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
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
      MediaQuery.of(navigatorKey.currentContext!).platformBrightness ==
          Brightness.dark;

  static bool get userDarkMode => _userDarkMode;

  static bool get darkMode => userDarkMode || platformDarkMode;

  ///是否隐藏悬浮按钮-用于回到顶部
  static bool _hideFloatingButton = false;

  static bool get hideFloatingButton => _hideFloatingButton;

  /// 当前字体索引
  static int? _fontIndex = 0;

  int? get fontIndex => _fontIndex;

  /// 当前主题索引
  static int? _themeIndex = 7;

  int? get themeIndex => _themeIndex;

  static MaterialColor get themeColor => _themeColor;

  ///白色主题状态栏及导航栏颜色
  static Color colorWhiteTheme = Color(0x66000000);

//  Color colorWhiteTheme = Colors.transparent;

  static Color colorBlackTheme = Colors.grey[900]!;

  static Color get accentColor => _accentColor;

  static Color get themeAccentColor =>
      _userDarkMode ? colorBlackTheme : accentColor;

  static double get textScaleFactor => 1;

  /// 当前主size textScaleFactor
  static double? _articleTextScaleFactor = 1.0;

  static double? get articleTextScaleFactor => _articleTextScaleFactor;

  ThemeViewModel() {
    /// 用户选择的明暗模式
    _userDarkMode = SpUtil.getBool(SP_KEY_THEME_DARK_MODE, defValue: false)!;

    /// 获取主题色
    _themeIndex =
        SpUtil.getInt(SP_KEY_THEME_COLOR_INDEX, defValue: _themeIndex);
    _themeColor = themeValueList[_themeIndex!];
    _accentColor = _themeColor;

    /// 获取本地字体
    _fontIndex = SpUtil.getInt(SP_KEY_FONT_INDEX);

    /// 获取本地文字缩放
    _articleTextScaleFactor =
        SpUtil.getDouble(SP_KEY_FONT_TEXT_SIZE, defValue: 1.0);

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
    SpUtil.putInt(SP_KEY_FONT_INDEX, _fontIndex!);
  }

  /// 切换文字字号缩放
  switchFontTextSize(double textScaleFactor) {
    _articleTextScaleFactor = textScaleFactor;
    switchTheme();
    SpUtil.putDouble(SP_KEY_FONT_TEXT_SIZE, _articleTextScaleFactor!);
  }

  static String fontFamily() {
    return fontValueList[_fontIndex!];
  }

  String fontFamilyIndex({int? index}) {
    return fontValueList[index ?? _fontIndex!];
  }

  /// 切换指定色彩；没有传[brightness]就不改变brightness,color同理
  void switchTheme(
      {bool? userDarkMode, int? themeIndex, MaterialColor? color}) async {
    if (themeIndex != null && themeIndex != _themeIndex) {
      SpUtil.putInt(SP_KEY_THEME_COLOR_INDEX, themeIndex);
    }
    _userDarkMode = userDarkMode ?? _userDarkMode;
    _themeIndex = themeIndex ?? _themeIndex;
    _themeColor = color ?? getThemeColor();

    ///存入缓存
    SpUtil.putBool(SP_KEY_THEME_DARK_MODE, _userDarkMode);
    notifyListeners();
  }

  ///设置系统Bar主题
  static Future setSystemBarTheme() async {
    ///非手机系统不做处理
    if (!PlatformUtil.isMobile) {
      return;
    }
    LogUtil.v('platformDarkMode:$platformDarkMode;userDarkMode:$userDarkMode');
    bool statusEnable = PlatformUtil.isAndroid
        ? await PlatformUtil.isStatusColorChange()
        : true;
    bool navigationEnable = PlatformUtil.isAndroid
        ? await PlatformUtil.isNavigationColorChange()
        : true;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      ///状态栏背景色
      statusBarColor: darkMode || statusEnable ? Colors.transparent : null,

      ///状态栏icon 亮度（浅色/深色）
      statusBarIconBrightness: darkMode ? Brightness.light : Brightness.dark,

      ///导航栏颜色
      systemNavigationBarColor: darkMode
          ? colorBlackTheme
          : navigationEnable
              ? Colors.transparent
              : null,

      ///导航栏icon（浅色/深色）
      systemNavigationBarIconBrightness:
          darkMode ? Brightness.light : Brightness.dark,
    ));
  }

  ///根据主题 明暗 和 颜色 生成对应的主题[dark]系统的Dark Mode
  themeData({bool platformDarkMode: false}) {
    LogUtil.v('themeData_platform:$platformDarkMode');
    var isDark = platformDarkMode || _userDarkMode;
    var themeColor = _themeColor;
    _accentColor = (isDark ? themeColor[600] : _themeColor)!;
    Brightness brightness = isDark ? Brightness.dark : Brightness.light;
    var themeData = ThemeData(
      ///主题浅色或深色-
      brightness: brightness,
      primaryColorBrightness: brightness,
      accentColorBrightness: brightness,
      primarySwatch: themeColor,

      ///强调色
      accentColor: accentColor,
      primaryColor: accentColor,

      ///类苹果跟随滑动返回-修改后返回箭头及主标题iOS风格
//      platform: TargetPlatform.iOS,
      errorColor: Colors.red,
      toggleableActiveColor: accentColor,

      ///输入框光标
      // cursorColor: accentColor,
      ///输入框光标
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accentColor,
        selectionColor: accentColor.withAlpha(60),
        selectionHandleColor: accentColor.withAlpha(60),
      ),

      ///字体
      fontFamily: fontValueList[_fontIndex!],
    );

    themeData = themeData.copyWith(
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: themeColor,
      ),

      ///主题设置Appbar样式背景
      appBarTheme: themeData.appBarTheme.copyWith(
        ///根据主题设置Appbar样式背景
        color: isDark ? colorBlackTheme : Colors.white,

        ///去掉海拔高度
        elevation: 0,
        textTheme: TextTheme(
          ///title Text样式 原title 被废弃
          headline6: TextStyle(
            color: isDark ? Colors.white : accentColor,
            fontSize: 17,
            fontWeight: FontWeight.w500,

            ///字体
            fontFamily: fontValueList[_fontIndex!],
          ),

          ///action及leading Text样式 原body1废弃
          bodyText2: TextStyle(
            color: isDark ? Colors.white : accentColor,
            fontSize: 10,
            fontWeight: FontWeight.w500,

            ///字体
            fontFamily: fontValueList[_fontIndex!],
          ),
        ),

        ///icon样式
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : accentColor,
        ),
      ),
      iconTheme: themeData.iconTheme.copyWith(
        color: accentColor,
      ),

      ///水波纹
      splashColor: themeColor.withAlpha(50),

      ///鼠标悬浮颜色
      hoverColor: themeColor.withAlpha(50),

      ///长按提示文本样式
      tooltipTheme: themeData.tooltipTheme.copyWith(
        textStyle: TextStyle(
          fontSize: 14,
          color: (darkMode ? Colors.black : Colors.white).withOpacity(0.9),
        ),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 12,
          top: 2,
        ),
        decoration: BoxDecoration(
          color: (isDark ? Colors.white : Colors.black).withOpacity(0.75),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),

      ///TabBar样式设置
      tabBarTheme: themeData.tabBarTheme.copyWith(
        ///标签内边距
        labelPadding: EdgeInsets.symmetric(horizontal: 8),

        ///选中文字样式
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,

          ///字体
          fontFamily: fontValueList[_fontIndex!],
        ),

        ///未选择样式
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13,

          ///字体
          fontFamily: fontValueList[_fontIndex!],
        ),
      ),

      ///floatingActionButton
      floatingActionButtonTheme: themeData.floatingActionButtonTheme.copyWith(
        foregroundColor: accentColor,
        backgroundColor: themeData.cardColor,
        elevation: 10,
        splashColor: themeColor.withOpacity(0.5),
      ),

      ///dialog主题
      dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        contentTextStyle: themeData.textTheme.subtitle1!.copyWith(
          fontSize: 14,
        ),

        ///背景圆角
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      ///Divider分割线组件样式添加一个间隔线
      dividerTheme: DividerThemeData(
        ///线颜色
        color: themeData.hintColor.withOpacity(0.075),

        ///线粗细
        thickness: 0.7,

        ///前间隔
        indent: 0,

        ///后间隔
        endIndent: 0,
      ),
    );
    setSystemBarTheme();
    return themeData;
  }

  /// 根据索引获取颜色名称,这里牵涉到国际化
  static String themeName({int? i}) {
    int? index = i ?? _themeIndex;
    switch (index) {
      case 0:
        return StringHelper.getS()!.red;
      case 1:
        return StringHelper.getS()!.orange;
      case 2:
        return StringHelper.getS()!.yellow;
      case 3:
        return StringHelper.getS()!.green;
      case 4:
        return StringHelper.getS()!.cyan;
      case 5:
        return StringHelper.getS()!.blue;
      case 6:
        return StringHelper.getS()!.purple;
      case 7:
        return '${getWeekStr()}-${themeName(i: DateTime.now().weekday - 1)}';
      default:
        return '';
    }
  }

  static MaterialColor getThemeColor({int? i}) {
    int? index = i ?? _themeIndex;
    return index == themeValueList.length - 1
        ? themeValueList[DateTime.now().weekday - 1]
        : themeValueList[index!];
  }

  ///获取周
  static String getWeekStr() {
    int week = DateTime.now().weekday;
    switch (week) {
      case 1:
        return StringHelper.getS()!.monday;
      case 2:
        return StringHelper.getS()!.tuesday;
      case 3:
        return StringHelper.getS()!.wednesday;
      case 4:
        return StringHelper.getS()!.thursday;
      case 5:
        return StringHelper.getS()!.friday;
      case 6:
        return StringHelper.getS()!.saturday;
      case 7:
        return StringHelper.getS()!.sunday;
      default:
        return '';
    }
  }
}

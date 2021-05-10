import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

///国际化语言切换-刚开始做了语言切换后面废弃
class LocaleViewModel extends ChangeNotifier {
  static const localeValueList = ['', 'zh-CN', 'en'];

  static const SP_KEY_LOCALE_INDEX = 'SP_KEY_LOCALE_INDEX';

  int? _localeIndex;

  int? get localeIndex => _localeIndex;

  Locale? get locale {
    if (_localeIndex! > 0) {
      var value = localeValueList[_localeIndex!].split("-");
      return Locale(value[0], value.length == 2 ? value[1] : '');
    }
    // 跟随系统
    return null;
  }

  LocaleViewModel() {
    _localeIndex = SpUtil.getInt(SP_KEY_LOCALE_INDEX);
    switchLocale(_localeIndex);
  }

  switchLocale(int? index) {
    _localeIndex = index;
    SpUtil.putInt(SP_KEY_LOCALE_INDEX, _localeIndex!);
    notifyListeners();
  }

  String localeName(index, context) {
    switch (index) {
      case 0:
//        return StringHelper.getS().autoBySystem;
      case 1:
//        return StringHelper.getS().chinese;
      case 2:
//        return StringHelper.getS().english;
      default:
        return '';
    }
  }

  String localeCurrentName(context) {
    return localeName(localeIndex, context);
  }
}

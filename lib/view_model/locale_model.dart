import 'package:flutter/material.dart';
import 'package:flutter_readhub/generated/i18n.dart';
import 'package:flutter_readhub/util/sp_util.dart';

///国际化语言切换
class LocaleModel extends ChangeNotifier {
  static const localeValueList = ['', 'zh-CN', 'en'];

  static const SP_KEY_LOCALE_INDEX = 'SP_KEY_LOCALE_INDEX';

  int _localeIndex;

  int get localeIndex => _localeIndex;

  Locale get locale {
    if (_localeIndex > 0) {
      var value = localeValueList[_localeIndex].split("-");
      return Locale(value[0], value.length == 2 ? value[1] : '');
    }
    // 跟随系统
    return null;
  }

  LocaleModel() {
    _localeIndex = SPUtil.getInt(SP_KEY_LOCALE_INDEX);
    switchLocale(_localeIndex);
  }

  switchLocale(int index) {
    _localeIndex = index;
    SPUtil.putInt(SP_KEY_LOCALE_INDEX, _localeIndex);
    notifyListeners();
  }

  String localeName(index, context) {
    switch (index) {
      case 0:
        return S.of(context).autoBySystem;
      case 1:
        return S.of(context).chinese;
      case 2:
        return S.of(context).english;
      default:
        return '';
    }
  }

  String localeCurrentName(context) {
    return localeName(localeIndex, context);
  }
}


import 'package:flutter_readhub/generated/l10n.dart';
import 'package:flutter_readhub/main.dart';

///String 资源获取帮助类
///减少context传递
class StringHelper {
  static S? getS() {
    return S.of(navigatorKey.currentContext!);
  }
}

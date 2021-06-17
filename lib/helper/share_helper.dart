import 'package:flustars/flustars.dart';
import 'package:flutter/services.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';

///分享帮助类
class ShareHelper {
  static final ShareHelper _singleton = ShareHelper._internal();

  static ShareHelper get singleton => _singleton;

  ///工厂构造函数
  factory ShareHelper() {
    return _singleton;
  }

  ///构造函数私有化，防止被误创建
  ShareHelper._internal();

  ///分享文本到粘贴板
  Future<void> shareTextToClipboard(String text, {String? tip}) {
    return Clipboard.setData(ClipboardData(text: text)).then((value) =>
        ToastUtil.show(tip ?? StringHelper.getS()!.copyToClipboardSucceed));
  }

  ///分享网址-通过系统浏览器打开
  void shareTextOpenByBrowser(String url) async {
    try {
      await launch(url);
    } catch (e) {
      LogUtil.v('e:$e}', tag: 'shareTextOpenByBrowser');
    }
  }
}

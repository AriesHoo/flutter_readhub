import 'package:share/share.dart';

///分享工具类
class ShareUtil {
  ///分享
  static share(String text) async {
    Share.share(text);
  }
}

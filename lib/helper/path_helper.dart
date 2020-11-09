import 'dart:io';

import 'package:path_provider/path_provider.dart';

///文件路径帮助类
class PathHelper {
//   /// 获取存储路径
//   static Future<String> getLocalPath() async {
//     /// 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
//     /// 如果是android，使用getExternalStorageDirectory
//     /// 如果是iOS，使用getApplicationSupportDirectory
// //    final directory = Platform.isAndroid
// //        ? await getExternalStorageDirectory()
// //        : await getApplicationSupportDirectory();
//     final directory = await getTemporaryDirectory();
//     return directory.path;
//   }

  /// 获取存储路径
  static Future<String> getLocalPath() async {
    /// 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
    /// 如果是android，使用getExternalStorageDirectory
    /// 如果是iOS，使用getApplicationDocumentsDirectory-这样下载后通过系统打开
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 斜杠'/'打头
  static Future<String> getFilePath(String path) async {
    /// 获取存储路径
    var _localPath = (await getLocalPath()) + path;
    var _savedDir = Directory(_localPath);

    /// 判断路径是否存在
    bool hasExisted = await _savedDir.exists();

    /// 不存在就新建路径
    if (!hasExisted) {
      _savedDir.create();
    }
    return _savedDir.path;
  }

  ///获取分享图片截图
  static Future<String> getImagePath() async {
    return getFilePath('/ShareScreenShots');
  }
}

import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

///权限获取帮助类
class PermissionHelper {
  /// 申请权限
  static Future<bool> checkPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    if (status != PermissionStatus.granted) {
      status = await permission.request();
      return status == PermissionStatus.granted;
    } else {
      return true;
    }
  }

  ///文件读写android storage iOS photos
  static Future<bool> checkStoragePermission() async {
    return checkPermission(
        Platform.isAndroid ? Permission.storage : Permission.photos);
  }
}

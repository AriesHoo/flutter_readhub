import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

export 'dart:io';

/// 是否是生产环境
const bool inProduction = const bool.fromEnvironment("dart.vm.product");

class PlatformUtil {
  // static Future<PackageInfo> getAppPackageInfo() {
  //   return PackageInfo.fromPlatform();
  // }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  // static Future<String> getPackageName() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   return packageInfo.packageName;
  // }

  // static Future getDeviceInfo() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   if (PlatformUtil.isAndroid) {
  //     return await deviceInfo.androidInfo;
  //   } else if (Platform.isIOS) {
  //     return await deviceInfo.iosInfo;
  //   } else {
  //     return null;
  //   }
  // }

  ///Android 6.0及以上-状态栏icon颜色
  static Future<bool> isStatusColorChange() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (PlatformUtil.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      return info.version.sdkInt! >= 23;
    } else {
      return true;
    }
  }

  ///Android 8.0及以上-底部导航栏icon颜色
  static Future<bool> isNavigationColorChange() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (PlatformUtil.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      return info.version.sdkInt! >= 26;
    } else {
      return true;
    }
  }

  ///判断当前是否为web系统
  static bool get isBrowser => kIsWeb;

  ///是否Linux系统
  static bool get isLinux => !isBrowser && Platform.isLinux;

  ///是否Mac系统
  static bool get isMacOS => !isBrowser && Platform.isMacOS;

  ///是否Windows系统
  static bool get isWindows => !isBrowser && Platform.isWindows;

  ///是否Android系统
  static bool get isAndroid => !isBrowser && Platform.isAndroid;

  ///是否iOS系统
  static bool get isIOS => !isBrowser && Platform.isIOS;

  ///是否Fuchsia系统
  static bool get isFuchsia => !isBrowser && Platform.isFuchsia;

  ///是否手机系统
  static bool get isMobile => isAndroid || isIOS;
}

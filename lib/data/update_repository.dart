
import 'package:flustars/flustars.dart';
import 'package:flutter_readhub/data/update_http.dart';
import 'package:flutter_readhub/model/app_update_model.dart';
import 'package:flutter_readhub/util/platform_util.dart';

import 'basis_http.dart';

/// App更新相关接口
class UpdateRepository {
  ///检查app版本升级
  static Future<AppUpdateModel?> checkUpdate() async {
    Response<dynamic> response;
    if (PlatformUtil.isMobile) {
      response = await http.post('app/check');
    } else if (PlatformUtil.isMacOS) {
      response = await checkDesktopUpdate();
    } else {
      return null;
    }
    var result = AppUpdateModel.fromJson(response.data);

    ///此处如此处理主要因iOS-buildVersion
    ///蒲公英判断出错 貌似根据 buildBuildVersion-判断
    if (PlatformUtil.isMobile) {
      result.buildHaveNewVersion = true == result.buildHaveNewVersion &&
          await PlatformUtil.getBuildNumber() != result.buildVersionNo;
    } else {
      result.buildHaveNewVersion =
          await PlatformUtil.getBuildNumber() != result.buildVersionNo;
    }
    if (result.buildHaveNewVersion!) {
      LogUtil.v('checkUpdate-发现新版本->${result.buildVersion}');
      return result;
    }
    return null;
  }

  ///检测桌面版本新版
  static Future<dynamic> checkDesktopUpdate() async {
    return await http.get(
      'https://gitee.com/AriesHoo/flutter_readhub/raw/master/update/macos',
      queryParameters: {'String': true},
    );
  }
}

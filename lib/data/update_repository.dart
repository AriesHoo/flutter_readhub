import 'package:flustars/flustars.dart';
import 'package:flutter_readhub/data/update_http.dart';
import 'package:flutter_readhub/model/app_update_model.dart';
import 'package:flutter_readhub/util/platform_util.dart';

/// App更新相关接口
class UpdateRepository {

  ///检查app版本升级
  static Future<AppUpdateModel> checkUpdate() async {
    var response = await http.post('app/check');
    var result = AppUpdateModel.fromJson(response.data);
    result.buildHaveNewVersion = result.buildHaveNewVersion &&
        await PlatformUtil.getBuildNumber() != result.buildVersionNo;
    if(result.buildHaveNewVersion){
      LogUtil.e('checkUpdate-发现新版本->${result.buildVersion}');
      return result;
    }
    return null;
  }
}

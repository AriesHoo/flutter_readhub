import 'package:flustars/flustars.dart';
import 'package:flutter_readhub/data/update_http.dart';

/// App更新相关接口
class UpdateRepository {

  ///检查app版本升级
  static Future<AppUpdateInfo> checkUpdate() async {
    var response = await http.post('app/check');
    var result = AppUpdateInfo.fromJson(response.data);
    if(result.buildHaveNewVersion){
      LogUtil.e('checkUpdate-发现新版本->${result.buildVersion}');
      return result;
    }
    return null;
  }
}

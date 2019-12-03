import 'package:flutter/cupertino.dart';
import 'package:flutter_readhub/data/update_http.dart';

/// App更新相关接口
class UpdateRepository {

  static Future<AppUpdateInfo> checkUpdate() async {
    var response = await http.post('app/check');
    var result = AppUpdateInfo.fromMap(response.data);
    if(result.buildHaveNewVersion){
      debugPrint('发现新版本===>${result.buildVersion}');
      return result;
    }
    debugPrint('没有发现新版本');
    return null;
  }
}

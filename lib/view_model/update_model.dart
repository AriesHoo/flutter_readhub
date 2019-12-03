import 'package:flutter_readhub/data/update_http.dart';
import 'package:flutter_readhub/data/update_repository.dart';
import 'package:flutter_readhub/util/log_util.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/view_model/basis/basis_view_model.dart';

///检查更新
class UpdateModel extends BasisViewModel {
  static String _appVersion;

  static String get appVersion => _appVersion != null ? _appVersion : "";

  static String _packageName;

  static String get packageName =>
      _packageName != null ? _packageName : "cn.aries.freadhub";

  ///检查新版本
  Future<AppUpdateInfo> checkUpdate() async {
    AppUpdateInfo appUpdateInfo;
    setLoading();
    try {
      appUpdateInfo = await UpdateRepository.checkUpdate();
      setSuccess();
    } catch (e, s) {
      setError(e, s);
    }
    return appUpdateInfo;
  }

  UpdateModel() {
    LogUtil.e('UpdateModel');
    PlatformUtil.getAppVersion().then((str) {
      _appVersion = str;
    });
    PlatformUtil.getPackageName().then((str) {
      _packageName = str;
    });
  }
}

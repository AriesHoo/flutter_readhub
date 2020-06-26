import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/data/update_http.dart';
import 'package:flutter_readhub/data/update_repository.dart';
import 'package:flutter_readhub/generated/l10n.dart';
import 'package:flutter_readhub/util/dialog_util.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/basis/basis_view_model.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

///检查更新
class UpdateViewModel extends BasisViewModel {
  static String _appVersion;

  static String get appVersion => _appVersion != null ? _appVersion : "";

  static String _appVersionCode;

  static String get appVersionCode =>
      _appVersionCode != null ? _appVersionCode : '-1';

  static String _packageName;

  static String get packageName =>
      _packageName != null ? _packageName : "cn.aries.freadhub";

  ///检查新版本
  Future<AppUpdateInfo> checkUpdate(BuildContext context,
      {bool showError = false}) async {
    if (Platform.isIOS) {
      return null;
    }
    AppUpdateInfo appUpdateInfo;
    setLoading();
    try {
      appUpdateInfo = await UpdateRepository.checkUpdate();
      showUpdateDialog(context, appUpdateInfo, background: !showError);
      setSuccess();
    } catch (e, s) {
      setError(e, s);
      if (showError) {
        ToastUtil.show('检查失败,请稍后重试!$e',
            duration: Duration(
              seconds: 6,
            ));
      }
    }
    return appUpdateInfo;
  }

  UpdateViewModel() {
    LogUtil.e('UpdateViewModel');
    PlatformUtil.getAppVersion().then((str) {
      _appVersion = str;
      notifyListeners();
    });
    PlatformUtil.getBuildNumber().then((num) {
      _appVersionCode = num;
      notifyListeners();
    });
    PlatformUtil.getPackageName().then((str) {
      _packageName = str;
      notifyListeners();
    });
  }

  ///弹出升级新版本Dialog
  Future<void> showUpdateDialog(BuildContext context, AppUpdateInfo info,
      {bool background = true}) async {
    if (info == null || !info.buildHaveNewVersion) {
      if (!background) {
        ToastUtil.show(S.of(context).currentIsNew);
      }
      return;
    }
    DialogUtil.showAlertDialog(
      context,
      titleWidget: RichText(
        textScaleFactor: ThemeViewModel.textScaleFactor,
        text: TextSpan(
            style: Theme.of(context).textTheme.subtitle1,
            text: '发现新版本:${info.buildVersion}',
            children: [
              TextSpan(
                  text: '\n系统自带浏览器打开',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Theme.of(context).accentColor,
                        fontSize: 13,
                      ))
            ]),
      ),
      content: info.buildUpdateDescription,
      cancel: S.of(context).updateNextTime,
      ensure: S.of(context).updateNow,
    ).then((value) {
      if (value == 1) {
        launch(info.downloadURL);
      }
    });
  }
}

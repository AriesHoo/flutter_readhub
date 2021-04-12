import 'package:flutter/material.dart';
import 'package:flutter_readhub/basis/basis_view_model.dart';
import 'package:flutter_readhub/data/update_repository.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/model/app_update_model.dart';
import 'package:flutter_readhub/util/dialog_util.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

///检查更新
class UpdateViewModel extends BasisViewModel {
  static String? _appVersion;

  static String? get appVersion => _appVersion != null ? _appVersion : "";

  static String? _appVersionCode;

  static String? get appVersionCode =>
      _appVersionCode != null ? _appVersionCode : '-1';

  ///检查新版本
  Future<AppUpdateModel?> checkUpdate(BuildContext context,
      {bool showError = false}) async {
    AppUpdateModel? appModel;
    setLoading();
    try {
      appModel = await UpdateRepository.checkUpdate();
      showUpdateDialog(context, appModel, background: !showError);
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
    return appModel;
  }

  UpdateViewModel() {
    PlatformUtil.getAppVersion().then((str) {
      _appVersion = str;
      setSuccess();
    });
    PlatformUtil.getBuildNumber().then((num) {
      _appVersionCode = num;
      setSuccess();
    });
  }

  ///弹出升级新版本Dialog
  Future<void> showUpdateDialog(BuildContext context, AppUpdateModel? info,
      {bool background = true}) async {
    if (info == null || !info.buildHaveNewVersion!) {
      if (!background) {
        ToastUtil.show(StringHelper.getS()!.currentIsNew);
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
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).accentColor,
                        fontSize: 13,
                      ))
            ]),
      ),
      content: info.buildUpdateDescription,
      cancel: StringHelper.getS()!.updateNextTime,
      ensure: StringHelper.getS()!.updateNow,
    ).then((index) {
      if (index == 1) {
        launch(info.downloadURL!);
      }
    });
  }
}

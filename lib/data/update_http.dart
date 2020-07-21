import 'package:flustars/flustars.dart';
import 'package:flutter_readhub/data/basis_http.dart';
import 'package:flutter_readhub/util/platform_util.dart';

final UpdateHttp http = UpdateHttp();

///检查版本更新
class UpdateHttp extends BasisHttp {
  @override
  void init() {
    options.baseUrl = 'https://www.pgyer.com/apiv2/';
    interceptors.add(UpdateInterceptor());
    interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}

/// App相关 API
class UpdateInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    options.queryParameters['_api_key'] = 'f4d7dae2132cf8715c99ca79043deefb';
    options.queryParameters['appKey'] = '9d5adc8a82bdcf48a905d8d5aa7f19e3';
    options.queryParameters['buildVersion'] = await PlatformUtil.getAppVersion();
    options.queryParameters['buildBuildVersion'] = await PlatformUtil.getBuildNumber();
    LogUtil.e('---UpdateHttp-UpdateInterceptor-request--->url--> ${options.baseUrl}${options.path}' +
        ' queryParameters: ${options.queryParameters}');
    return options;
  }

  @override
  onResponse(Response response) {
    ResponseData respData = ResponseData.fromJson(response.data);
    LogUtil.e('UpdateHttp-UpdateInterceptor-onResponse:$respData');
    if (respData.success) {
      response.data = respData.data;
      return http.resolve(response);
    } else {
      throw DioError();
    }
  }
}

class ResponseData {
  int code = 0;
  String message;
  dynamic data;

  bool get success => code == 0;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }
}

/// CheckApp更新接口
class AppUpdateInfo {
  String buildBuildVersion;
  String forceUpdateVersion;
  String forceUpdateVersionNo;
  bool needForceUpdate;
  String downloadURL;
  bool buildHaveNewVersion;
  String buildVersionNo;
  String buildVersion;
  String buildShortcutUrl;
  String buildUpdateDescription;

  static AppUpdateInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    AppUpdateInfo pgyerApiBean = AppUpdateInfo();
    pgyerApiBean.buildBuildVersion = map['buildBuildVersion'];
    pgyerApiBean.forceUpdateVersion = map['forceUpdateVersion'];
    pgyerApiBean.forceUpdateVersionNo = map['forceUpdateVersionNo'];
    pgyerApiBean.needForceUpdate = map['needForceUpdate'];
    pgyerApiBean.downloadURL = map['downloadURL'];
    pgyerApiBean.buildHaveNewVersion = map['buildHaveNewVersion'];
    pgyerApiBean.buildVersionNo = map['buildVersionNo'];
    pgyerApiBean.buildVersion = map['buildVersion'];
    pgyerApiBean.buildShortcutUrl = map['buildShortcutUrl'];
    pgyerApiBean.buildUpdateDescription = map['buildUpdateDescription'];
    return pgyerApiBean;
  }

  Map toJson() => {
        "buildBuildVersion": buildBuildVersion,
        "forceUpdateVersion": forceUpdateVersion,
        "forceUpdateVersionNo": forceUpdateVersionNo,
        "needForceUpdate": needForceUpdate,
        "downloadURL": downloadURL,
        "buildHaveNewVersion": buildHaveNewVersion,
        "buildVersionNo": buildVersionNo,
        "buildVersion": buildVersion,
        "buildShortcutUrl": buildShortcutUrl,
        "buildUpdateDescription": buildUpdateDescription,
      };
}

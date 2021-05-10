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
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.queryParameters['_api_key'] = 'f4d7dae2132cf8715c99ca79043deefb';
    options.queryParameters['appKey'] = Platform.isAndroid
        ? '9d5adc8a82bdcf48a905d8d5aa7f19e3'
        : '430e714ebb8fb7c3f2ab72fa5c5009dc';
    options.queryParameters['buildVersion'] =
        await PlatformUtil.getAppVersion();
    options.queryParameters['buildBuildVersion'] =
        await PlatformUtil.getBuildNumber();
    LogUtil.v(
        '---UpdateHttp-UpdateInterceptor-request--->url--> ${options.baseUrl}${options.path}' +
            ' queryParameters: ${options.queryParameters}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    ResponseData respData = ResponseData.fromJson(response.data);
    LogUtil.v('UpdateHttp-UpdateInterceptor-onResponse:$respData');
    if (respData.success) {
      response.data = respData.data;
      return handler.resolve(response);
    } else {
      handler.reject(DioError(requestOptions: response.requestOptions));
    }
  }
}

class ResponseData {
  int? code = 0;
  String? message;
  dynamic data;

  bool get success => code == 0;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }
}

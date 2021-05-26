import 'dart:convert';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_readhub/util/platform_util.dart';

export 'package:dio/dio.dart';

/// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

///网络请求基类--mobile使用
abstract class BasisHttp with DioMixin implements Dio {
  BasisHttp() {
    options = BaseOptions();
    httpClientAdapter =  DefaultHttpClientAdapter();

    /// 初始化 加入app通用处理
    if (PlatformUtil.isMobile) {
      (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    }
    interceptors..add(HeaderInterceptor());
    init();
  }

  void init();
}

/// 添加常用Header
class HeaderInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.connectTimeout = 1000 * 15;
    options.receiveTimeout = 1000 * 15;
    options.responseType = ResponseType.json;
    options.contentType = Headers.jsonContentType;
    super.onRequest(options, handler);
  }
}

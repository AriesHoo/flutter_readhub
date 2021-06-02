import 'dart:convert';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_readhub/helper/sp_helper.dart';

export 'package:dio/dio.dart';

/// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

///网络请求基类--Native使用
abstract class BasisHttp with DioMixin implements Dio {
  BasisHttp() {
    options = BaseOptions();
    httpClientAdapter = DefaultHttpClientAdapter();
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
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
    Map<String, dynamic> headers = options.headers;
    if (!TextUtil.isEmpty(SpHelper.getPoemToken())) {
      headers.putIfAbsent('X-User-Token', () => SpHelper.getPoemToken());
    }
    options.headers = headers;
    super.onRequest(options, handler);
  }
}

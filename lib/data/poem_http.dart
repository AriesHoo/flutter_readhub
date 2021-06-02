import 'package:dio/dio.dart';
import 'package:flutter_readhub/data/basis_http.dart';

final PoemHttp http = PoemHttp();

///诗歌 http请求基础处理
class PoemHttp extends BasisHttp {
  @override
  void init() {
    options.baseUrl = 'https://v2.jinrishici.com/';
    interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    interceptors..add(ApiInterceptor());
  }
}

class ApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
  }
}

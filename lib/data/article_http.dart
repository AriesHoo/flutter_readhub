import 'package:flustars/flustars.dart';
import 'package:flutter_readhub/data/basis_http.dart';

final ArticleHttp http = ArticleHttp();

///ReadHub http请求基础处理
class ArticleHttp extends BasisHttp {
  ///热门话题
  static const String API_TOPIC = "topic";

  ///科技动态--news lab
  static const String API_NEWS = "news";

  ///技术资讯
  static const String API_TECH_NEWS = "technews";

  ///区块链
  static const String API_BLOCK_CHAIN = "blockchain";

  @override
  void init() {
    options.baseUrl = 'https://api.readhub.me/';
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
    LogUtil.v('---article-request--->url--> ${options.baseUrl}${options.path}' +
        ' queryParameters: ${options.queryParameters}');
    super.onRequest(options, handler);
  }
}

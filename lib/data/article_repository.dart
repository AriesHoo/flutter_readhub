import 'package:flutter_readhub/data/article_http.dart';
import 'package:flutter_readhub/data/basis_http.dart';
import 'package:flutter_readhub/model/article_model.dart';
import 'package:flutter_readhub/util/platform_util.dart';

///Readhub 文章接口调用
class ArticleRepository {
  ///根据传入URL获取首页数据--根据是否传递 lastCursor标识第一页
  static Future getArticleList(String url,
      {String? lastCursor, int pageSize: 20}) async {
    Map<String, dynamic>? param = lastCursor != null && lastCursor.isNotEmpty
        ? {
            "lastCursor": lastCursor,
            "pageSize": pageSize,
          }
        : null;
    Response response;
    if (PlatformUtil.isMobile) {
      response = await http.get(
        url,
        queryParameters: param,
      );
    } else {
      response = await Dio()
          .get('https://api.readhub.me/$url', queryParameters: param);
    }
    return ArticleModel.fromJson(response.data);
  }
}

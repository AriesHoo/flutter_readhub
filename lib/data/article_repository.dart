import 'package:flustars/flustars.dart';
import 'package:flutter_readhub/data/article_http.dart';
import 'package:flutter_readhub/data/basis_http.dart';
import 'package:flutter_readhub/model/article_model.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';

///Readhub 文章接口调用
class ArticleRepository {
  static Dio _dio = Dio();

  ///根据传入URL获取首页数据--根据是否传递 lastCursor标识第一页
  ///查证只支持每页最多20个
  static Future getArticleList(String url,
      {String? lastCursor, int pageSize: 20}) async {
    Map<String, dynamic>? param = lastCursor != null && lastCursor.isNotEmpty
        ? {
            "lastCursor": lastCursor,
            "pageSize": pageSize,
          }
        : null;
    Response response;
    if (!PlatformUtil.isBrowser) {
      response = await http.get(
        url,
        queryParameters: param,
      );
    } else {
      _dio.options.headers
          .putIfAbsent('Access-Control-Allow-Origin', () => '*');

      // await _dio
      //     .get(
      //         'http://192.168.100.160:9710/web/courseDetail/course/category?pageNum=1&pageSize=10')
      //     .then(
      //         (value) => ToastUtil.showSuccess('${value.data}'));
      response = await _dio.get(
        'https://api.readhub.me/$url',
        queryParameters: param,
      );
    }
    return ArticleModel.fromJson(response.data);
  }
}

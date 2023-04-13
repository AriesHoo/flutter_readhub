import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_readhub/data/article_http.dart';
import 'package:flutter_readhub/data/basis_http.dart';
import 'package:flutter_readhub/model/article_model.dart';
import 'package:flutter_readhub/util/platform_util.dart';

///Readhub 文章接口调用
class ArticleRepository {
  static Dio _dio = Dio();

  ///根据传入URL获取首页数据--根据是否传递 lastCursor标识第一页
  ///查证只支持每页最多20个
  static Future getArticleList(
    String url, {
    String? lastCursor,
    int pageSize = 20,
  }) async {
    Map<String, dynamic>? param = lastCursor != null && lastCursor.isNotEmpty
        ? {
            "lastCursor": lastCursor,
            "pageSize": pageSize,
          }
        : null;
    Response response;
    if (!PlatformUtil.isWeb) {
      response = await http.get(
        url,
        queryParameters: param,
      );
    } else {
      String targetUrl = 'https://api.readhub.me/$url?pageSize=$pageSize';
      if (ObjectUtil.isNotEmpty(lastCursor)) {
        targetUrl += '&lastCursor=$lastCursor';
      }
      if (kIsWeb) {
        targetUrl =
            'http://192.168.100.239:9000/common/requestHttpGet?url=$targetUrl';
      }
      response = await _dio.get(
        targetUrl,
      );
    }
    return ArticleModel.fromJson(json.decode(json.encode(response.data)));
  }
}

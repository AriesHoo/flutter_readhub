import 'package:flutter/cupertino.dart';
import 'package:flutter_readhub/data/basis_http.dart';
import 'package:flutter_readhub/data/read_hub_http.dart';
import 'package:flutter_readhub/model/list_model.dart';

///Readhub 接口调用
class ReadHubRepository {
  ///根据传入URL获取首页数据
  static Future getFirstPage(String url) async {
    Response response = await http.get(url);
    debugPrint("response:" + response.toString());
    debugPrint("response_data:" + response.data.toString());
    ListModel model = ListModel.fromJson(response.data);
    debugPrint("getFirstPage:" + model.data.length.toString());
    return model;
  }

  ///根据传入URL获取首页数据
  static Future getNextPage(String url, String lastCursor, int pageSize) async {
    Response response = await http.get(url, queryParameters: {
      "lastCursor": lastCursor,
      "pageSize": pageSize,
    });
    debugPrint("getNextPage_response:" + response.toString());
    debugPrint("getNextPage_response_data:" + response.data.toString());
    ListModel model = ListModel.fromJson(response.data);
    return model;
  }
}

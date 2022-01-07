import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/basis/basis_refresh_list_view_model.dart';
import 'package:flutter_readhub/data/article_http.dart';
import 'package:flutter_readhub/data/article_repository.dart';
import 'package:flutter_readhub/model/article_model.dart';
import 'package:flutter_readhub/util/toast_util.dart';

///获取资讯列表Model
class ArticleViewModel extends BasisRefreshListViewModel<ArticleItemModel> {
  String? lastCursor;
  String url;

  ArticleViewModel(this.url);

  ///预刷新--该方式非100%准确,只适用于一段时间(这段时间最多更新20条新资讯)
  preRefresh() async {
    ArticleModel model = await ArticleRepository.getArticleList(
      url,
      pageSize: pageSize,
    );
    if (model.data != null && model.data!.isNotEmpty) {
      List<ArticleItemModel> listData = model.data!.toList();

      ///移除已经存在的
      model.data!.removeWhere(
          (element) => list.any((itemList) => itemList.id == element.id));

      ///有新的资讯
      if (model.data!.isNotEmpty) {
        ///移除当前list与返回重复资讯
        list.removeWhere(
            (element) => listData.any((itemData) => itemData.id == element.id));

        ///将新获取资讯添加到list顶部
        listData.addAll(list);
        list = listData;

        ToastUtil.show(
          '发现${model.data!.length}条新${getLabel()}',
          backgroundColor: Colors.green.withOpacity(0.9),
          textColor: Colors.white,
          notification: true,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        );
      }
      ///至少刷新新闻发布时间间隔
      setSuccess();
      LogUtil.v('length:${model.data!.length};listLength:${list.length}'
          ';listData_length:${listData.length}');
    }
  }

  String getLabel() {
    String result = '讯息';
    switch (url) {

      ///热门话题
      case ArticleHttp.API_TOPIC:
        result = '话题';
        break;

      ///科技动态
      case ArticleHttp.API_NEWS:
        result = '动态';
        break;

      ///技术资讯
      case ArticleHttp.API_TECH_NEWS:
        result = '资讯';
        break;
    }
    return result;
  }

  @override
  Future<List<ArticleItemModel>?> loadData({int? pageNum}) async {
    ///第一页将游标重置
    lastCursor = pageNum == 0 ? null : lastCursor;
    ArticleModel model = await ArticleRepository.getArticleList(
      url,
      lastCursor: lastCursor,
      pageSize: pageSize,
    );
    lastCursor = model.getLastCursor();

    LogUtil.v('lastCursor:$lastCursor');
    return model.data;
  }
}
